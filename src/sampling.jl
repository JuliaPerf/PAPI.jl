struct EventValues
    events::Vector{Event}
    vals::Vector{Counts}
    time::Counts
end

EventValues(events::Event...) = EventValues(events, zeros(Counts, length(events)), Counts(0))
EventValues(events::NTuple{N, Event}) where N = EventValues(collect(events), zeros(Counts, N), Counts(0))
EventValues(events::Vector{Event}) = EventValues(events, zeros(Counts, length(events)), Counts(0))

struct EventStats
    events::Vector{Event}
    samples::Matrix{Counts}
    time::Vector{Counts}
end

EventStats(events::Vector{Event}) = EventStats(events, zeros(Counts, (0, length(events))),zeros(Counts, 0))

gcscrub() = (GC.gc(); GC.gc(); GC.gc(); GC.gc())

function run_and_collect!(f::Function, evtsets::Vector{EventSet}, vals::Vector{Counts})
    last = 0

    time = UInt64(0)
    for evtset in evtsets
        first = last + 1
        last = last + length(evtset)

        start_counters(evtset)
        time += try
            local t0 = time_ns()
            f()
            (time_ns() - t0)
        finally
            stop_counters!(evtset, view(vals, first:last))
        end
    end
    div(time, length(evtsets))
end

"""
    profile(f::Function, events::Vector{Event}; gcfirst::Bool=true, warmup::Int64=0)

Execute the function `f` once while counting specific `events`.

**Arguments**:

    -`f`: the function to profile
    -`events`: the events to count
    -`gcfirst`: run the gc several times before the execution to reduce gc noise
    -`warmup`: number of times to run the function prior to counting

**Return values**:

`EventValues` containing the events, counts and runtime collected
"""
function profile(f::Function, events::Vector{Event}; gcfirst::Bool=true, warmup::Int64=0, multi::Bool=true)
    gcfirst && gcscrub()

    for i in 1:warmup
      f()
    end

    evtsets = measurement_groups(events)
    if length(evtsets) != 1 && !multi
        throw(ArgumentError("cannot profile the events at the same time"))
    end

    vals = zeros(Counts, length(events))
    time = run_and_collect!(f, evtsets, vals)
    EventValues(collect_events(evtsets), vals, time)
end

profile(f::Function, events::NTuple{N, Event}) where N = profile(f, collect(events))

function _sample(f::Function, evtsets::Vector{EventSet}, counts::Vector{Counts}, samples::Vector{Vector{Counts}}, times::Vector{UInt64};
         max_secs::Real=5., max_epochs::Int64=1000, gcsample::Bool=false)

    start_time = Base.time()
    iters = 1
    while (Base.time() - start_time) < max_secs && iters ≤ max_epochs
        gcsample && gcscrub()

        time = run_and_collect!(f, evtsets, counts)

        push!(samples, copy(counts))
        push!(times, time)
        iters += 1
    end
end

function _sample(f::Function, evtset::EventSet, counts::Vector{Counts}, samples::Vector{Vector{Counts}}, times::Vector{UInt64};
         max_secs::Real=5., max_epochs::Int64=1000, gcsample::Bool=false)

    start_counters(evtset)
    try
        start_time = Base.time()
        iters = 1
        while (Base.time() - start_time) < max_secs && iters ≤ max_epochs
            gcsample && gcscrub()

            reset_counters!(evtset)
            local t0 = time_ns()
            f()
            time = (time_ns() - t0)
            read_counters!(evtset, counts)

            push!(samples, copy(counts))
            push!(times, time)
            iters += 1
        end
    finally
        stop_counters(evtset)
    end
end

"""
    sample(f::Function, events::Vector{Event}; max_secs::Float64=5, max_epochs::Int64=1000, gcsample::Bool=false, warmup::Int64=1)

Execute the function `f` several times, each time counting specific `events`.
Sampling continues until either the maximum number of samples `max_epochs` are collected or the runtime budget `max_secs` is exceeded.

**Arguments**:

    -`f`: the function to profile
    -`events`: the events to count
    -`max_secs`: maximum number of seconds to sample for
    -`gcsample`: run the gc several times before the execution to reduce gc noise
    -`warmup`: number of times to run the function prior to counting

**Return values**:

`EventStats` containing the events, counts and runtime collected
"""
function sample(f::Function, events::Vector{Event}; max_secs::Real=5., max_epochs::Int64=1000, gcsample::Bool=false, warmup::Int64=1, multi::Bool=true)
    num_events = length(events)
    counts = Vector{Counts}(undef, num_events)
    samples = Vector{Counts}[]
    times = UInt64[]

    evtsets = measurement_groups(events)
    if length(evtsets) != 1 && !multi
        throw(ArgumentError("cannot profile the events at the same time"))
    end

    gcscrub()

    for i in 1:warmup
        f()
    end

    if length(evtsets) == 1
        _sample(f, first(evtsets), counts, samples, times; max_secs=max_secs, max_epochs=max_epochs, gcsample=gcsample)
    else
        _sample(f, evtsets, counts, samples, times; max_secs=max_secs, max_epochs=max_epochs, gcsample=gcsample)
    end
    EventStats(collect_events(evtsets), hcat(samples...)', times)
end

sample(f::Function, events::NTuple{N, Event}; kw...) where N = sample(f, collect(events); kw...)

function kwargs(default_events, ex, args...)
    events, ex, params = if isa(ex, Symbol) || (isa(ex, Expr) && (ex.head == :tuple || ex.head == :vect))
      ex, first(args), collect(Iterators.drop(args, 1))
    else
      default_events, ex, collect(args)
    end

    for ex in params
        if isa(ex, Expr) && ex.head == :(=)
            ex.head = :kw
        end
    end
    events, ex, params
end

"""
    profile(ex, args...)

Convience macro for profiling an expression.
Events can be specified as a first argument, otherwise the default events `[BR_INS, BR_MSP, TOT_INS, TOT_CYC]` are counted

Arguments and return values are similar to [`profile`](@ref)

**Example**:
```julia
@profile f(x, y, z) # sampling default events
@profile [PAPI.TOT_INS, PAPI.DP_OPS, native_event] f(x, y, z) gcfirst=false
```
"""
macro profile(ex, args...)
    events, ex, params = kwargs([BR_INS, BR_MSP, TOT_INS, TOT_CYC], ex, args...)
    quote
        profile(() -> $(esc(ex)), Event[$(esc(events))...], $(params...))
    end
end

"""
    sample(ex, args...)

Convience macro for sampling an expression.
Events can be specified as a first argument, otherwise the default events `[BR_INS, BR_MSP, TOT_INS, TOT_CYC]` are counted

Arguments and return values are similar to [`sample`](@ref)

**Example**:
```julia
@sample f(x, y, z) # sampling default events
@sample [PAPI.TOT_INS, PAPI.DP_OPS, native_event] f(x, y, z) max_secs=1
```
"""
macro sample(ex, args...)
    events, ex, params = kwargs([BR_INS, BR_MSP, TOT_INS, TOT_CYC], ex, args...)
    quote
        sample(() -> $(esc(ex)), Event[$(esc(events))...], $(params...))
    end
end
