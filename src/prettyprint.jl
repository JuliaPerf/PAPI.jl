import Statistics: mean

import Base: show, IO
function show_events_array(io::IO, v::Vector{Event}, i1=1, l=length(v))
    i = i1
    if l >= i
        while true
            show(io, v[i])
            i += 1
            i > l && break

            print(io, ", ")
        end
    end
end

function show(io::IO, evtset::EventSet)
    limited = get(io, :limit, false)::Bool

    print(io, "EventSet: [")
    if limited && length(evtset) > 20
        f, l = 1, length(evtset)
        show_events_array(io, evtset.events, f, f+9)
        print(io, "  …  ")
        show_events_array(io, evtset.events, l-9, l)
    else
        show_events_array(io, evtset.events)
    end
    print(io, "]")
end

function show(io::IO, ::MIME"text/plain", stats::EventValues)
    print(io, "EventValues:")
    for (e,v) in zip(stats.events, stats.vals)
        print(io, "\n  ", e, " = ", v)
        print_shadow(io, e, v, stats)
    end
    print(io, "\n  runtime = ", stats.time, " nsecs")
end

function show(io::IO, stats::EventValues)
    print(io, "EventValues")
    if !get(io, :compact, false)
        for (e,v) in zip(stats.events, stats.vals)
            print(io, " ", e, "=", v)
        end
    end
    print(io, "\n  runtime = ", stats.time, " nsecs")
end

function show(io::IO, ::MIME"text/plain", stats::EventStats)
    print(io, "EventStats:")
    for (e,v) in zip(stats.events, eachcol(stats.samples))
        print(io, "\n  ", e, " = ", v)
        print_shadow(io, e, v, stats)
    end
    print(io, "\n  runtime = ", stats.time, " nsecs")
end

function show(io::IO, stats::EventStats)
    print(io, "EventStats")
    if !get(io, :compact, false)
        for (e,v) in zip(stats.events, eachcol(stats.samples))
            print(io, " ", e, "=", v)
        end
    end
    print(io, "\n  runtime = ", stats.time, " nsecs")
end

function has_event(f::Function, evt::Event, stats::EventValues, args...)
    idx = findfirst(isequal(evt), stats.events)
    if idx !== nothing
        f(stats.vals[idx], args...)
    end
end

function has_event(f::Function, evt::Event, stats::EventStats, args...)
    idx = findfirst(isequal(evt), stats.events)
    if idx !== nothing
        f(stats.samples[:, idx], args...)
    end
end

const COLOR_NONE = ""
const COLOR_RESET = "\033[m"
const COLOR_BOLD = "\033[1m"
const COLOR_RED	= "\033[31m"
const COLOR_GREEN = "\033[32m"
const COLOR_YELLOW = "\033[33m"
const COLOR_BLUE = "\033[34m"
const COLOR_MAGENTA ="\033[35m"
const COLOR_CYAN = "\033[36m"
const COLOR_BG_RED = "\033[41m"

pct_color(ratio) = if ratio > 20
    COLOR_RED
elseif ratio > 10
    COLOR_MAGENTA
elseif ratio > 5
    COLOR_YELLOW
else
    COLOR_NONE
end

function ratio(num::Union{Counts, AbstractVector{Counts}}, den::Union{Counts, AbstractVector{Counts}})
    round(mean(num./ den), digits=3)
end

function percentage(num::Union{Counts, AbstractVector{Counts}}, den::Union{Counts, AbstractVector{Counts}})
    round(mean(num./ den) * 100, digits=0)
end

function print_shadow(io::IO, evt::Event, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    print_shadow(Val(evt), io, value, stats)
end

function print_shadow(::Val{TOT_INS}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(TOT_CYC, stats) do cycles
        print(io, " # $(ratio(value, cycles)) insn per cycle")
    end

    has_event(RES_STL, stats) do stalled_cycles
        print(io, " # $(ratio(stalled_cycles, value)) stalled cycles per insn")
    end
end

function print_shadow(::Val{TOT_CYC}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    print(io, " # $(ratio(value, stats.time)) Ghz")

    has_event(TOT_INS, stats) do cycles
        print(io, " # $(ratio(value, cycles)) cycles per insn")
    end
end

function print_shadow(::Val{BR_MSP}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(BR_INS, stats) do branches
        pct = percentage(value, branches)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all branches")
    end
end

function print_shadow(::Union{Val{L1_LDM}, Val{L2_LDM}, Val{L3_LDM}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(LD_INS, stats) do loads
        pct = percentage(value, loads)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all loads")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Union{Val{L1_STM}, Val{L2_STM}, Val{L3_STM}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(SR_INS, stats) do stores
        pct = percentage(value, stores)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all stores")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Union{Val{L1_TCM}, Val{L1_TCH}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L1_TCA, stats) do accesses
        pct = percentage(value, accesses)
        color = pct_color(evt == L1_TCM ? pct : 1.0 - pct)
        print(io, " # $color$pct%$COLOR_RESET of all L1 cache refs")
    end
end

function print_shadow(::Union{Val{L1_DCA}, Val{L1_DCW}, Val{L1_DCR}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L1_TCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $pct% of all L1 cache refs")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Val{L1_DCM}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L1_TCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $pct% of all L1 cache refs")
    end

    has_event(L1_DCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of data L1 cache refs")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Val{L2_TCM}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L2_TCA, stats) do accesses
        pct = percentage(value, accesses)
        color = pct_color(pct)
        print(io, " # $color$pct%$COLOR_RESET of all L2 cache refs")
    end
end

function print_shadow(::Val{L2_TCH}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L2_TCA, stats) do accesses
        pct = percentage(value, accesses)
        color = pct_color(1.0 - pct)
        print(io, " # $color$pct%$COLOR_RESET of all L2 cache refs")
    end
end

function print_shadow(::Union{Val{L2_DCA}, Val{L2_DCW}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L2_TCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $pct% of all L2 cache refs")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Val{L2_DCM}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L2_TCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $pct% of all L2 cache refs")
    end

    has_event(L2_DCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of data L2 cache refs")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Val{L3_TCM}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L3_TCA, stats) do accesses
        pct = percentage(value, accesses)
        color = pct_color(pct)
        print(io, " # $color$pct%$COLOR_RESET of all L3 cache refs")
    end
end

function print_shadow(:: Val{L3_TCH}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L3_TCA, stats) do accesses
        pct = percentage(value, accesses)
        color = pct_color(1.0 - pct)
        print(io, " # $color$pct%$COLOR_RESET of all L3 cache refs")
    end
end

function print_shadow(::Union{Val{L3_DCA}, Val{L3_DCW}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L3_TCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $pct% of all L3 cache refs")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Val{L3_DCM}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(L3_TCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $pct% of all L3 cache refs")
    end

    has_event(L3_DCA, stats) do accesses
        pct = percentage(value, accesses)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of data L3 cache refs")
    end

    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $pct of all load/stores")
    end
end

function print_shadow(::Val{TLB_DM}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(LST_INS, stats) do lst
        pct = percentage(value, lst)
        print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all load/stores")
    end
end

const INS_UNION = Union{Val{FMA_INS}, Val{FP_INS}, Val{BR_INS}, Val{VEC_INS}, Val{FAD_INS},
            Val{SR_INS}, Val{LD_INS}, Val{INT_INS}, Val{LST_INS}, Val{SYC_INS},
            Val{FML_INS}, Val{FDV_INS}, Val{FSQ_INS}, Val{FNV_INS}}
function print_shadow(::INS_UNION, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(TOT_INS, stats) do insn
        pct = percentage(value, insn)
        print(io, " # $pct% of all instructions")
    end

    unit = 'G'
    r = ratio(value, stats.time)
    if r < 1.
        unit = 'M'
        r *= 1e3
    elseif r < 1e-6
        unit = 'K'
        r *= 1e6
    end
    print(io, " # $r $unit/sec ")
end

function print_shadow(::Union{Val{STL_ICY}, Val{FUL_ICY}, Val{STL_CCY}, Val{FUL_CCY}, Val{MEM_SCY}, Val{MEM_RCY}, Val{MEM_WCY}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(TOT_CYC, stats) do cycles
        pct = percentage(value, cycles)
        print(io, " # $pct% of all cycles")
    end
end

function print_shadow(evt::Union{Val{SP_OPS}, Val{DP_OPS}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(FP_INS, stats) do insn
        pct = percentage(value, insn)
        print(io, " # $pct% of all fp instructions")
    end

    has_event(TOT_INS, stats) do insn
        pct = percentage(value, insn)
        print(io, " # $pct% of all instructions")
    end

    has_event(evt == Val(SP_OPS) ? VEC_SP : VEC_DP, stats) do vec
        x = ratio(value, vec)
        print(io, " # $(x)x vectorized")
    end
end

function print_shadow(::Union{Val{VEC_SP}, Val{VEC_DP}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(VEC_INS, stats) do insn
        pct = percentage(value, insn)
        print(io, " # $pct% of all vec instructions")
    end

    has_event(TOT_INS, stats) do insn
        pct = percentage(value, insn)
        print(io, " # $pct% of all instructions")
    end
end

function print_shadow(::Union{Val{MEM_RCY}, Val{MEM_SCY}, Val{MEM_WCY}, Val{RES_STL}}, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    has_event(TOT_CYC, stats) do cycles
        pct = percentage(value, cycles)
        color = if pct > 50
            COLOR_RED
        elseif pct > 30
            COLOR_MAGENTA
        elseif pct > 10
            COLOR_YELLOW
        else
            COLOR_NONE
        end
        print(io, " # $color$pct%$COLOR_RESET of all cycles")
    end
end

function print_shadow(::Val, io::IO, value::Union{Counts, AbstractVector{Counts}}, stats::Union{EventStats, EventValues})
    unit = 'G'
    r = ratio(value, stats.time)
    if r < 1.
        unit = 'M'
        r *= 1e3
    elseif r < 1e-6
        unit = 'K'
        r *= 1e6
    end

    print(io, " # $r $unit/sec ")
end
