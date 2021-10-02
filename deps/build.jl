using Pkg.TOML, Libdl

config_toml = joinpath(first(DEPOT_PATH), "prefs", "PAPI.toml")
mkpath(dirname(config_toml))

if !isfile(config_toml)
    touch(config_toml)
end

config = TOML.parsefile(config_toml)
update_config = false

if haskey(ENV, "JULIA_PAPI_BINARY")
    config["binary"] = ENV["JULIA_PAPI_BINARY"]
    update_config = true
end

if haskey(ENV, "JULIA_PAPI_LIBRARY")
    config["library"] = ENV["JULIA_PAPI_LIBRARY"]
    update_config = true
end

if haskey(ENV, "JULIA_PAPI_PATH")
    config["path"] = ENV["JULIA_PAPI_PATH"]
    update_config = true
end

if update_config
    open(config_toml, write=true) do f
        TOML.print(f, config)
    end
end

binary = get(config, "binary", "")

# 2. generate deps.jl
deps = if binary == "system"
    @info "using system PAPI"
    library = get(config, "library", "libpapi")
    path    = get(config, "path", "")

    const libpapi = find_library(library, path == "" ? [] : [joinpath(path, "lib"), joinpath(path, "lib64")])
    if libpapi == ""
        error("libpapi could not be found")
    end

    papi_version = try
        papi_version = Cmd([path == "" ? "papi_version" : joinpath(path, "bin", "papi_version")])
        output = chomp(read(papi_version, String))
        startswith(output, "PAPI Version: ") || error("unexpected output from $papi_version")
        v = output[15:end]
        m = match(r"^(\d+)(?:\.(\d+))?(?:\.(\d+))?(?:\.(\d+))?$", v)
        m === nothing && throw(ArgumentError("invalid version string: $v"))
        major, minor, patch, _ = map(m.captures) do x
            x !== nothing ? parse(Int, x) : 0
        end
        VersionNumber(major, minor, patch)
    catch e
        error("failed to find papi version: $e")
    end

    quote
        const libpapi = $libpapi
        const papi_version = $papi_version
    end
else
    @warn "using PAPI_jll: the use of a system library is probably recommended"
    papi_version = v"6.0.0"

    quote
        using PAPI_jll
        const papi_version = $papi_version
    end
end

remove_line_numbers(x) = x
function remove_line_numbers(ex::Expr)
    if ex.head == :macrocall
        ex.args[2] = nothing
    else
        ex.args = [remove_line_numbers(arg) for arg in ex.args if !(arg isa LineNumberNode)]
    end
    return ex
end

# only update deps.jl if it has changed.
# allows users to call Pkg.build("PAPI") without triggering another round of precompilation
deps_str =
    """
    # This file has been generated automatically.
    # It will be overwritten the next time `Pkg.build("PAPI")` is called.
    """ *
    string(remove_line_numbers(deps))

if !isfile("deps.jl") || deps_str != read("deps.jl", String)
    write("deps.jl", deps_str)
end
