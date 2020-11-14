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

EventStats(events::Vector{Event}) = EventStats(events, zeros(Counts, Counts[]), Counts(0))

gcscrub() = (GC.gc(); GC.gc(); GC.gc(); GC.gc())

function profile(f::Function, events::Vector{Event}; gcfirst::Bool=false, warmup::Int64=1)
    gcfirst && gcscrub()

    for i in 1:warmup
      f()
    end

    vals = zeros(Counts, length(events))
    start_counters(events)
    time = try
        local t0 = time_ns()
        f()
        (time_ns() - t0)
    finally
        stop_counters!(vals)
    end

    EventValues(events, vals, time)
end

profile(f::Function, events::NTuple{N, Event}) where N = profile(f, collect(events))

function sample(f::Function, events::Vector{Event}; max_secs::Int64=5, max_epochs::Int64=1000, gcsample::Bool=false, warmup::Int64=1)
    num_events = length(events)
    counts = Vector{Counts}(undef, num_events)
    samples = Vector{Counts}[]
    times = UInt64[]

    start_counters(events)
    try
        gcscrub()

        for i in 1:warmup
          f()
        end

        start_time = Base.time()
        iters = 1
        while (Base.time() - start_time) < max_secs && iters ≤ max_epochs
            gcsample && gcscrub()
            read_counters!(counts)
            local t0 = time_ns()
            f()
            time = (time_ns() - t0)
            read_counters!(counts)
            push!(samples, copy(counts))
            push!(times, time)
            iters += 1
        end
    finally
        stop_counters!(counts)
    end

    EventStats(events, hcat(samples...)', times)
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

macro profile(ex, args...)
    events, ex, params = kwargs([BR_INS, BR_MSP, TOT_INS, TOT_CYC], ex, args...)
    quote
        profile(() -> $(esc(ex)), Event[$(esc(events))...], $(params...))
    end
end

macro sample(ex, args...)
    events, ex, params = kwargs([BR_INS, BR_MSP, TOT_INS, TOT_CYC], ex, args...)
    quote
        sample(() -> $(esc(ex)), Event[$(esc(events))...], $(params...))
    end
end
