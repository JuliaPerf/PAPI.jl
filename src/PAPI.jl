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

const Counts = Clonglong

struct EventValues
    events::Vector{Event}
    vals::Vector{Counts}
end

EventValues(events::Event...) = EventValues(events, zeros(Counts, length(events)))
EventValues(events::NTuple{N, Event}) where N = EventValues(collect(events), zeros(Counts, N))
EventValues(events::Vector{Event}) = EventValues(events, zeros(Counts, length(events)))

struct EventStats
    events::Vector{Event}
    samples::Matrix{Counts}
end

EventStats(events::Vector{Event}) = EventStats(events, zeros(Counts, Counts[]))

gcscrub() = (GC.gc(); GC.gc(); GC.gc(); GC.gc())

function sample_once(f::Function, events::Vector{Event})
    stats = EventValues(events)
    start_counters(stats.events)
    try
        f()
    finally
        stop_counters!(stats.vals)
    end

    stats
end

sample_once(f::Function, events::NTuple{N, Event}) where N = sample_once(f, collect(events))

function sample(f::Function, events::Vector{Event}; max_secs::Int64=5, max_epochs::Int64=1000)
    num_events = length(events)
    counts = Vector{Counts}(undef, num_events)
    samples = Vector{Counts}[]

    start_counters(events)
    try
        start_time = Base.time()
        iters = 1
        while (Base.time() - start_time) < max_secs && iters ≤ max_epochs
            gcscrub()
            read_counters!(counts)
            f()
            read_counters!(counts)
            push!(samples, copy(counts))
        end
    finally
        stop_counters!(counts)
    end

    EventStats(events, hcat(samples...))
end

sample(f::Function, events::NTuple{N, Event}; kw...) where N = sample(f, collect(events); kw...)

macro profile_once(events, ex)
    quote
        sample_once(() -> $(esc(ex)), $events)
    end
end

function kwargs(args...)
    params = collect(args)
    for ex in params
        if isa(ex, Expr) && ex.head == :(=)
            ex.head = :kw
        end
    end
    params
end

macro profile(events, ex, args...)
    params = kwargs(args...)
    quote
        sample(() -> $(esc(ex)), $events, $(params...))
    end
end

import Base: show, IO
function show(io::IO, ::MIME"text/plain", stats::EventValues)
    print(io, "EventValues:")
    for (e,v) in zip(stats.events, stats.vals)
        print(io, "\n  ", e, " = ", v)
    end
end

function show(io::IO, stats::EventValues)
    print(io, "EventValues")
    if !get(io, :compact, false)
        for (e,v) in zip(stats.events, stats.vals)
            print(io, " ", e, "=", v)
        end
    end
end

function show(io::IO, ::MIME"text/plain", stats::EventStats)
    print(io, "EventStats:")
    for (e,v) in zip(stats.events, eachrow(stats.samples))
        print(io, "\n  ", e, " = ", v)
    end
end

function show(io::IO, stats::EventStats)
    print(io, "EventStats")
    if !get(io, :compact, false)
        for (e,v) in zip(stats.events, eachrow(stats.samples))
            print(io, " ", e, "=", v)
        end
    end
end

export PAPIError, num_counters, start_counters, read_counters, accum_counters, stop_counters
export @profile_once, @profile, sample, sample_once
end # module
