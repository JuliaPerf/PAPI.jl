module PAPI

include("constants.jl")
include("error.jl")
include("events.jl")
include("counters.jl")
include("sampling.jl")
include("prettyprint.jl")

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

`PAPI_num_counters()`` returns the optimal length of the values array for the high level functions.
This value corresponds to the number of hardware counters supported by the current CPU component.
"""
function num_counters()
    errcode = ccall((:PAPI_num_counters, :libpapi), Cint, ())
    if errcode < 0
        throw(PAPIError(errcode))
    else
        Int(errcode)
    end
end


export PAPIError, num_counters, start_counters, read_counters, accum_counters, stop_counters
export @profile_once, @profile, sample, sample_once
end # module
