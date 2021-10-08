import JSON

const SUPPORTED_TYPES = Union{EventValues, EventStats}

JSON.lower(es::Event) = event_to_name(es)
function JSON.lower(x::Union{EventValues, EventStats})
    d = Dict{String,Any}()
    T = typeof(x)
    for i = 1:nfields(x)
        name = String(fieldname(T, i))
        value = getfield(x, i)
        ft = typeof(value)
        d[name] = value
    end

    [string(T.name.name), d]
end

function recover(x::Vector)
    length(x) == 2 || throw(ArgumentError("Expecting a vector of length 2"))
    typename = x[1]::String
    fields = x[2]::Dict

    T = if typename == "EventValues"
        EventValues
    elseif typename == "EventStats"
        EventStats
    else
        throw(ArgumentError("Unknown typename $typename"))
    end

    fc = fieldcount(T)
    xs = map(1:fc) do i
        ft = fieldtype(T, i)
        fn = String(fieldname(T, i))

        if ft == Vector{Event}
            map(name_to_event, fields[fn])
        elseif ft <: AbstractMatrix
            C = eltype(ft)
            hcat(Vector{C}.(fields[fn])...)
        else
            convert(ft, fields[fn])
        end
    end

    T(xs...)
end

function save(filename::AbstractString, args::SUPPORTED_TYPES...)
    endswith(filename, ".json") || throw(ArgumentError("Only JSON serialization is supported."))
    open(filename, "w") do io
        save(io, args...)
    end
end

function save(io::IO, args::SUPPORTED_TYPES...)
    isempty(args) && throw(ArgumentError("Nothing to save"))
    JSON.print(io, args)
end

function load(filename::AbstractString)
    endswith(filename, ".json") || throw(ArgumentError("Only JSON serialization is supported."))
    open(filename, "r") do io
        load(io)
    end
end

function load(io::IO)
    parsed = JSON.parse(io)
    map(recover, parsed)
end
