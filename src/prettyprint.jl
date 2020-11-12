import Statistics: mean

import Base: show, IO
function show(io::IO, ::MIME"text/plain", stats::EventValues)
    print(io, "EventValues:")
    for (e,v) in zip(stats.events, stats.vals)
        print(io, "\n  ", e, " = ", v)
        print_shadow(io, e, v, stats)
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
        avg = mean(v)
        print_shadow(io, e, avg, stats)
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

function has_event(f::Function, evt::Event, stats::EventValues)
    idx = findfirst(isequal(evt), stats.events)
    if idx !== nothing
        f(stats.vals[idx])
    end
end

function has_event(f::Function, evt::Event, stats::EventStats)
    idx = findfirst(isequal(evt), stats.events)
    if idx !== nothing
        avg = mean(stats.samples[idx])
        f(avg)
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

function print_shadow(io::IO, evt::Event, value::Union{Counts, Float64}, stats::Union{EventStats, EventValues})
    if evt == TOT_INS
        has_event(TOT_CYC, stats) do cycles
            ratio = round(value / cycles, digits=3)
            print(io, " # $ratio insn per cycle")
        end

        has_event(RES_STL, stats) do stalled_cycles
            ratio = round(stalled_cycles / value, digits=3)
            print(io, " # $ratio stalled cycles per insn")
        end
    elseif evt == TOT_CYC
        has_event(TOT_INS, stats) do cycles
            ratio = round(value / cycles, digits=3)
            print(io, " # $ratio cycles per insn")
        end
    elseif evt == BR_MSP
        has_event(BR_INS, stats) do branches
            pct = round((value / branches) * 100.)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all branches")
        end
    elseif evt == L1_LDM || evt == L2_LDM || evt == L3_LDM
        has_event(LD_INS, stats) do loads
            pct = round((value / loads) * 100.)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all loads")
        end
    elseif evt == L1_STM || evt == L2_STM || evt == L3_STM
        has_event(SR_INS, stats) do stores
            pct = round((value / stores) * 100.)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all stores")
        end
    elseif evt == L1_TCM || evt == L1_TCH
        has_event(L1_TCA, stats) do stores
            pct = round((value / stores) * 100.)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L1 cache refs")
        end
    elseif evt == L2_TCM || evt == L2_TCH
        has_event(L2_TCA, stats) do stores
            pct = round((value / stores) * 100.)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L2 cache refs")
        end
    elseif evt == L3_TCM || evt == L3_TCH
        has_event(L3_TCA, stats) do stores
            pct = round((value / stores) * 100.)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all L3 cache refs")
        end
    elseif evt in (FMA_INS, FP_INS, BR_INS, VEC_INS, FAD_INS, SR_INS, LD_INS, INT_INS, LST_INS, SYC_INS, FML_INS, FDV_INS, FSQ_INS, FNV_INS)
        has_event(TOT_INS, stats) do insn
            pct = round((value / insn)*100.)
            print(io, " # $pct% of all instructions")
        end
    elseif evt == SP_OPS || evt == DP_OPS
        has_event(FP_INS, stats) do insn
            pct = round((value / insn)*100.)
            print(io, " # $pct% of all fp instructions")
        end
    elseif evt == VEC_SP || evt == VEC_DP
        has_event(VEC_INS, stats) do insn
            pct = round((value / insn)*100.)
            print(io, " # $pct% of all vec instructions")
        end
    elseif evt in (MEM_RCY, MEM_SCY, MEM_WCY, RES_STL)
        has_event(TOT_CYC, stats) do cycles
            pct = round((value / cycles)*100)
            print(io, " # $(pct_color(pct))$pct%$COLOR_RESET of all cycles")
        end
    end
end
