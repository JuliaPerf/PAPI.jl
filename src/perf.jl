const Perf = find_component("perf_event")
export Perf

@info "loading perf support"

function print_shadow(::Val{Perf.BRANCH_MISSES}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(Perf.BRANCHES, stats) do branches
        pct = percentage(value, branches)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all branches")
    end
end

function print_shadow(::Val{Perf.L1_DCACHE_LOAD_MISSES}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(Perf.L1_DCACHE_LOADS, stats) do loads
        pct = percentage(value, loads)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L1 loads")
    end
end

function print_shadow(::Val{Perf.LLC_LOAD_MISSES}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(Perf.LLC_LOADS, stats) do loads
        pct = percentage(value, loads)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all LLC loads")
    end
end

function print_shadow(::Val{Perf.L1_DCACHE_STORE_MISSES}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(Perf.L1_DCACHE_STORES, stats) do loads
        pct = percentage(value, loads)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L1 stores")
    end
end

function print_shadow(::Val{Perf.LLC_STORE_MISSES}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(Perf.LLC_STORES, stats) do loads
        pct = percentage(value, loads)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all LLC stores")
    end
end
