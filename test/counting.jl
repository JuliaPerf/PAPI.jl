using PAPI, Test

function computation(n::Int64)
    tmp = 0.
    for i = 1:n
        tmp += i
    end
    tmp
end

@testset "counting" begin
    events = Event[PAPI.DP_OPS, PAPI.TOT_INS]
    values = Vector{Counts}(undef, length(events))

    evtset = start_counters(events)
    computation(100) # perform 100 double precision operations
    read_counters!(evtset, values)
    @test_skip values[1] ≈ 100

    computation(100) # perform 100 double precision operations
    accum_counters!(evtset, values)
    @test_skip values[1] ≈ 200

    values[1] = -100
    computation(100) # perform 100 double precision operations
    accum_counters!(evtset, values)
    @test_skip values[1] ≈ 0

    stop_counters(evtset)
end
