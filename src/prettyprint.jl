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
