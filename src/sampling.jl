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

function profile(f::Function, events::Vector{Event})
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

macro profile(events, ex)
    quote
        profile(() -> $(esc(ex)), $events)
    end
end

macro profile(ex)
    quote
        profile(() -> $(esc(ex)), [BR_INS, BR_MSP, TOT_INS, TOT_CYC])
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

macro sample(events, ex, args...)
    params = kwargs(args...)
    quote
        sample(() -> $(esc(ex)), $events, $(params...))
    end
end
