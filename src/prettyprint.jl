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

function has_event(f::Function, evt::Event, stats::EventValues)
    idx = findfirst(isequal(evt), stats.events)
    if idx !== nothing
        f(stats.vals[idx])
    end
end

function has_event(f::Function, evt::Event, stats::EventStats)
    idx = findfirst(isequal(evt), stats.events)
    if idx !== nothing
        f(stats.samples[:, idx])
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
    if evt == TOT_INS
        has_event(TOT_CYC, stats) do cycles
            print(io, " # $(ratio(value, cycles)) insn per cycle")
        end

        has_event(RES_STL, stats) do stalled_cycles
            print(io, " # $(ratio(stalled_cycles, value)) stalled cycles per insn")
        end
    elseif evt == TOT_CYC
        print(io, " # $(ratio(value, stats.time)) Ghz")

        has_event(TOT_INS, stats) do cycles
            print(io, " # $(ratio(value, cycles)) cycles per insn")
        end
    elseif evt == BR_MSP
        has_event(BR_INS, stats) do branches
            pct = percentage(value, branches)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all branches")
        end
    elseif evt == L1_LDM || evt == L2_LDM || evt == L3_LDM
        has_event(LD_INS, stats) do loads
            pct = percentage(value, loads)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all loads")
        end
    elseif evt == L1_STM || evt == L2_STM || evt == L3_STM
        has_event(SR_INS, stats) do stores
            pct = percentage(value, stores)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all stores")
        end
    elseif evt == L1_TCM || evt == L1_TCH
        has_event(L1_TCA, stats) do accesses
            pct = percentage(value, accesses)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L1 cache refs")
        end

        has_event(LST_INS, stats) do lst
            pct = percentage(value, lst)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all load/stores")
        end
    elseif evt == L2_TCM || evt == L2_TCH
        has_event(L2_TCA, stats) do accesses
            pct = percentage(value, accesses)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L2 cache refs")
        end

        has_event(LST_INS, stats) do lst
            pct = percentage(value, lst)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all load/stores")
        end
    elseif evt == L3_TCM || evt == L3_TCH
        has_event(L3_TCA, stats) do accesses
            pct = percentage(value, accesses)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L3 cache refs")
        end

        has_event(LST_INS, stats) do lst
            pct = percentage(value, lst)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all load/stores")
        end
    elseif evt == TLB_DM
        has_event(LST_INS, stats) do lst
            pct = percentage(value, lst)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all load/stores")
        end
    elseif evt in (FMA_INS, FP_INS, BR_INS, VEC_INS, FAD_INS, SR_INS, LD_INS, INT_INS, LST_INS, SYC_INS, FML_INS, FDV_INS, FSQ_INS, FNV_INS)
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
    elseif evt in (STL_ICY, FUL_ICY, STL_CCY, FUL_CCY, MEM_SCY, MEM_RCY, MEM_WCY)
        has_event(TOT_CYC, stats) do cycles
            pct = percentage(value, cycles)
            print(io, " # $pct% of all cycles")
        end
    elseif evt == SP_OPS || evt == DP_OPS
        has_event(FP_INS, stats) do insn
            pct = percentage(value, insn)
            print(io, " # $pct% of all fp instructions")
        end

        has_event(TOT_INS, stats) do insn
            pct = percentage(value, insn)
            print(io, " # $pct% of all instructions")
        end

        has_event(evt == SP_OPS ? VEC_SP : VEC_DP, stats) do vec
            x = ratio(value, vec)
            print(io, " # $(x)x vectorized")
        end
    elseif evt == VEC_SP || evt == VEC_DP
        has_event(VEC_INS, stats) do insn
            pct = percentage(value, insn)
            print(io, " # $pct% of all vec instructions")
        end

        has_event(TOT_INS, stats) do insn
            pct = percentage(value, insn)
            print(io, " # $pct% of all instructions")
        end
    elseif evt in (MEM_RCY, MEM_SCY, MEM_WCY, RES_STL)
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
    else
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
end
