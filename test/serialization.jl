using PAPI, Test

mk_eventstats(events::Vector{Event}, n=10) = PAPI.EventStats(events, rand(Counts, (n, length(events))), rand(Counts, n))
mk_eventvalues(events::Vector{Event}) = PAPI.EventValues(events, rand(Counts, length(events)), rand(Counts))

function equals(x::T, y::T) where {T<:PAPI.SUPPORTED_TYPES}
    all(i->equals(getfield(x, i), getfield(y, i)), 1:fieldcount(T))
end
equals(x::Vector{Event}, y::Vector{Event}) = ==(x, y)
equals(x, y) = isapprox(x, y)


@testset "serialization" begin
    events = Event[PAPI.BR_INS, PAPI.BR_MSP, PAPI.TOT_INS, PAPI.TOT_CYC]
    stats = mk_eventstats(events)
    values = mk_eventvalues(events)

    let io = IOBuffer()
        save(io, stats, values)
        seekstart(io)
        x = load(io)
        @test length(x) == 2
        @test equals(x[1], stats)
        @test equals(x[2], values)
    end
end
