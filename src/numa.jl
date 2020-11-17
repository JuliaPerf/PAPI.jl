@static if Sys.isunix()

const PROT_READ     = Cint(1)
const PROT_WRITE    = Cint(2)
const MAP_SHARED    = Cint(1)
const MAP_PRIVATE   = Cint(2)
const MAP_ANONYMOUS = Cint(Sys.isbsd() ? 0x1000 : 0x20)

const MPOL_DEFAULT     = Cint(0)
const MPOL_PREFERRED   = Cint(1)
const MPOL_BIND        = Cint(2)
const MPOL_INTERLEAVE  = Cint(3)
const MPOL_LOCAL       = Cint(4)
const MPOL_MF_STRICT   = Cint(1)
const MPOL_MF_MOVE     = Cint(2)
const MPOL_MF_MOVE_ALL = Cint(4)

function mmap_mbind(::Type{Array{T,N}}, dims::NTuple{N, Integer}, nodeid::Int64) where {T,N}
    size = prod(dims) * sizeof(T)
    size >= 0 || throw(ArgumentError("size should be >= 0, but $size"))

    prot = PROT_READ | PROT_WRITE
    flags = MAP_PRIVATE | MAP_ANONYMOUS
    ptr = ccall(:jl_mmap, Ptr{Cvoid}, (Ptr{Cvoid}, Csize_t, Cint, Cint, Cint, Int64),
            C_NULL, size, prot, flags, -1, 0)
    systemerror("memory mapping failed", reinterpret(Int, ptr) == -1)

    try
        nodemask = Ref{Culong}(1 << nodeid)
        ret = ccall((:mbind, :libnuma), Clong, (Ptr{Cvoid}, Culong, Cint, Ptr{Culong}, Culong, Cuint),
                ptr, size, MPOL_BIND, nodemask, sizeof(Culong)*8, MPOL_MF_MOVE)
        systemerror("mbind failed", ret == -1)
    catch
        systemerror("munmap",  ccall(:munmap, Cint, (Ptr{Cvoid}, Int), ptr, size) != 0)
        rethrow()
    end

    A = unsafe_wrap(Array, convert(Ptr{T}, ptr), dims)
    finalizer(A) do x
        @static if Sys.isunix()
            systemerror("munmap",  ccall(:munmap, Cint, (Ptr{Cvoid}, Int), ptr, size) != 0)
        end
    end

    A
end

const MBytes = 1024*1024
const KBytes = 1024

page_size_bytes() = Int(ccall(:jl_getpagesize, Clong, ()))
function huge_page_size_in_bytes()
    for line in eachline("/proc/meminfo")
        if startswith(line, "Hugepagesize")
            _, count, unit = split(line)
            size = parse(Int64, count)
            return if unit == "kB"
                size * KBytes
            else
                error("unknown unit $unit")
            end
        end
    end
end

function parse_node(descr::AbstractString)
    node, pages = split(descr, '=')
    parse(Int64, node[2:end]), parse(Int64, pages)
end

function numastat(pid::Int32=getpid())
    categories = ["huge", "heap", "stack", "N"]

    default_page_size = page_size_bytes()
    huge_page_size = huge_page_size_in_bytes()

    NT = NamedTuple{(:huge, :heap, :stack, :private, :total), NTuple{5, Float64}}

    numa_maps = "/proc/$pid/numa_maps"
    open(numa_maps) do io
        table = Dict{Int64, NT}()

        for line in eachline(io)
            category = 4
            parts = split(line)

            for p in parts
                if category == 4
                    idx = findfirst(cat -> startswith(p, cat), categories)
                    idx !== nothing && (category = idx)
                end

                # per-node page quantity
                if p[1] == 'N'
                    node, pages = parse_node(p)

                    multiplier = category == 1 ? huge_page_size : default_page_size
                    mbytes = pages * multiplier / MBytes

                    vals = get(table, node_num, NT((0.0, 0.0, 0.0, 0.0, 0.0)))
                    table[node_num] = NT((vals[1] + (category == 1 ? mbytes : 0.),
                                         vals[2] + (category == 2 ? mbytes : 0.),
                                         vals[3] + (category == 3 ? mbytes : 0.),
                                         vals[4] + (category == 4 ? mbytes : 0.),
                                         vals[5] + mbytes))
                end
            end
        end

        table
    end
end

function find_numa_mapping(ptr::UInt64, pid::Int32=getpid())
    default_page_size = page_size_bytes()
    huge_page_size = huge_page_size_in_bytes()

    numa_maps = "/proc/$pid/numa_maps"
    line = open(numa_maps) do io
        prev = nothing
        for line in eachline(io)
            parts = split(line; limit=2)
            address = parse(UInt64, parts[1], base=16)
            address > ptr && break
            prev = line
        end
        return prev
    end

    if line === nothing
        error("mapping for $ptr not found")
    end

    parts = split(line)
    offset = ptr - parse(UInt64, parts[1], base=16)
    nodepages = map(parse_node, filter(startswith("N"), parts))

    multiplier = if "huge" in parts
        huge_page_size
    else
        default_page_size
    end

    pages = sum(last, nodepages)
    bytes = pages * multiplier
    @assert offset < bytes

    Dict(((n, p*multiplier/MBytes) for (n,p) in nodepages))
end

find_numa_mapping(ptr::Ptr) = find_numa_mapping(convert(UInt64, ptr))
find_numa_mapping(a::AbstractArray) = find_numa_mapping(pointer(a))

function numaprofile(f::Function; gcfirst::Bool=true, warmup::Int64=0)
    node_stores = event"node-stores"
    node_loads = event"node-loads"
    node_store_misses = event"node-store-misses"
    node_load_misses = event"node-load-misses"
    profile(f, Event[node_stores, node_loads, node_store_misses, node_load_misses], gcfirst=gcfirst, warmup=warmup)
end

"""
    numaprofile(ex, args...)

Convience macro for numa profiling an expression.
"""
macro numaprofile(ex, args...)
    params = collect(args)
    for ex in params
        if isa(ex, Expr) && ex.head == :(=)
            ex.head = :kw
        end
    end
    quote
        numaprofile(() -> $(esc(ex)), $(params...))
    end
end


end
