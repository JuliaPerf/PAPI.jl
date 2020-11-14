using PAPI, Test

function computation(n::Int64)
    tmp = 0.
    for i = 1:n
        tmp += i
    end
    tmp
end

@testset "counting" begin
    events = Event[PAPI.TOT_INS, PAPI.TOT_CYC]
    values = Vector{Counts}(undef, length(events))
    start_counters(events)
    computation(10_000)
    stop_counters!(values)
end
