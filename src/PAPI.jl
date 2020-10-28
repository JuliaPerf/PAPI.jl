module PAPI

include("constants.jl")
include("error.jl")
include("events.jl")
include("counters.jl")

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

struct EventStats
    events::Vector{Event}
    vals::Vector{Clonglong}
end

EventStats(events::Event...) = EventStats(events, zeros(Clonglong, length(events)))
EventStats(events::NTuple{N, Event}) where N = EventStats(collect(events), zeros(Clonglong, N))
EventStats(events::Vector{Event}) = EventStats(events, zeros(Clonglong, length(events)))

macro profile(events, ex)
    quote
        stats = EventStats($events)
        start_counters(stats.events)
        try
            $(esc(ex))
        finally
            stop_counters!(stats.vals)
        end
        stats
    end
end

import Base: show, IO
function show(io::IO, ::MIME"text/plain", stats::EventStats)
    print(io, "PerfStats:")
    for (e,v) in zip(stats.events, stats.vals)
        print(io, "\n  ", e, " = ", v)
    end
end

function show(io::IO, stats::EventStats)
    print(io, "PerfStats")
    if !get(io, :compact, false)
        for (e,v) in zip(stats.events, stats.vals)
            print(io, " ", e, "=", v)
        end
    end
end

export PAPIError, num_counters, start_counters, read_counters, accum_counters, stop_counters, @profile
end # module
