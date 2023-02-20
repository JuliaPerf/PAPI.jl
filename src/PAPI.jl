module PAPI

using NUMA_jll
using PAPI_jll
using Preferences

if !PAPI_jll.is_available()
    const libpapi = load_preference(PAPI_jll, "libPAPI_path", nothing)
    is_available() = libpapi !== nothing
else
    is_available() = PAPI_jll.is_available()
end

"""
    locate()

Locate the PAPI library currently being used, by PAPI.jl
"""
function locate()
    if libpapi === nothing
        error("libpapi not available. Use `set_library` to set the path to libpapi")
    end
    return libpapi
end

"""
    set_library!(path)

Change the library path used by PAPI.jl for `libpapi.so` to `path`. 

!!! note
    You will need to restart Julia to use the new library.

!!! warning
    Due to a bug in Julia (until 1.6.5 and 1.7.1), setting preferences in transitive dependencies
    is broken (https://github.com/JuliaPackaging/Preferences.jl/issues/24). To fix this either update
    your version of Julia, or add PAPI_jll as a direct dependency to your project.
"""
function set_library!(path)
    if !ispath(path)
        error("PAPI library path $path not found")
    end
    set_preferences!(
        PAPI_jll,
        "libPAPI_path" => realpath(path);
        force=true,
    )
    @warn "PAPI library path changed, you will need to restart Julia for the change to take effect" path

    if VERSION <= v"1.6.5" || VERSION == v"1.7.0"
        @warn """
        Due to a bug in Julia (until 1.6.5 and 1.7.1), setting preferences in transitive dependencies
        is broken (https://github.com/JuliaPackaging/Preferences.jl/issues/24). To fix this either update
        your version of Julia, or add PAPI_jll as a direct dependency to your project.
        """
    end
end

const REFCOUNT = Ref(zero(UInt))
function deref_shutdown()
    REFCOUNT[] -= 1
    if REFCOUNT[] == 0
        # no objects to be finalized
        ccall((:PAPI_shutdown, libpapi), Cvoid, ())
    end
end

include("constants.jl")
include("error.jl")
include("options.jl")
include("events.jl")
include("eventsets.jl")
include("counters.jl")
include("components.jl")
include("sampling.jl")
include("prettyprint.jl")
include("serialization.jl")
include("numa.jl")

if is_available()
    const papi_current_version = get_option(PAPI_LIB_VERSION, C_NULL)
end

function __init__()
    if is_available()
        # init the library and make sure that some counters are available
        rv = ccall((:PAPI_library_init, libpapi), Cint, (Cint,), papi_current_version)
        if rv != papi_current_version
            if rv > 0
                error("PAPI library version mismatch!")
            else
                throw(PAPIError(rv))
            end
        end

        if num_counters() == 0
            error("PAPI init error: No counters are available on the current system")
        end

        REFCOUNT[] += 1
        atexit(deref_shutdown)
    end
end

"""
Get the number of hardware counters available on the system

`PAPI.num_counters()` initializes the PAPI library if necessary.

`PAPI_num_counters()`` returns the number of hardware counters available on the system.
"""
function num_counters()
    errcode = ccall((:PAPI_num_hwctrs, libpapi), Cint, ())
    if errcode < 0
        throw(PAPIError(errcode))
    else
        Int(errcode)
    end
end

export PAPIError, num_counters, start_counters, read_counters!, accum_counters!, stop_counters, stop_counters!
export @profile, @sample, sample, profile, @numaprofile, numaprofile
export name_to_event, event_to_name, @event_str
export find_component, exists, available_presets, available_native, Event, Counts, EventSet
export load, save
end # module
