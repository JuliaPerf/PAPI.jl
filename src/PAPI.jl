module PAPI

const REFCOUNT = Ref(zero(UInt))
function deref_shutdown()
    REFCOUNT[] -= 1
    if REFCOUNT[] == 0
        # no objects to be finalized
        ccall((:PAPI_shutdown, :libpapi), Cvoid, ())
    end
end

include("constants.jl")
include("error.jl")
include("events.jl")
include("eventsets.jl")
include("counters.jl")
include("components.jl")
include("sampling.jl")
include("prettyprint.jl")

function __init__()
    # init the library and make sure that some counters are available
    if num_counters() == 0
        error("PAPI init error: No counters are available on the current system")
    end
    REFCOUNT[] += 1
    atexit(deref_shutdown)
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
export find_component, exists, available_presets, available_native, Event, Counts, EventSet
end # module
