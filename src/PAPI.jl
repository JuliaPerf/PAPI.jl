module PAPI

include("constants.jl")
include("error.jl")
include("events.jl")
include("counters.jl")
include("sampling.jl")
include("prettyprint.jl")
include("components.jl")
include("eventsets.jl")

function __init__()
    # init the library and make sure that some counters are available
    if num_counters() == 0
        error("PAPI init error: No counters are available on the current system")
    end
    atexit() do
        ccall((:PAPI_shutdown, :libpapi), Cvoid, ())
    end
end

"""
Get the number of hardware counters available on the system

`PAPI.num_counters()` initializes the PAPI library if necessary.

`PAPI_num_counters()`` returns the number of hardware counters available on the system.
"""
function num_counters()
    errcode = ccall((:PAPI_num_counters, :libpapi), Cint, ())
    if errcode < 0
        throw(PAPIError(errcode))
    else
        Int(errcode)
    end
end

export PAPIError, num_counters, start_counters, read_counters!, accum_counters!, stop_counters, stop_counters!
export @profile, @sample, sample, profile, name_to_event, event_to_name, @event_str
export find_component, exists, available_presets, Event, Counts
end # module
