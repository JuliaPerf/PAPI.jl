using PAPI, Test

@testset "eventset" begin
    native = PAPI.Native(PAPI.PAPI_NATIVE_MASK)

    @testset "add/remove" begin
        evtset = EventSet()

        # add a preset
        push!(evtset, PAPI.TOT_INS)

        # add "native"
        push!(evtset, native)

        @test length(evtset) == 2
        @test PAPI.TOT_INS in evtset
        @test native in evtset

        delete!(evtset, native)
        @test ! (native in evtset)

        empty!(evtset)
        @test isempty(evtset)
    end

    @testset "add multiple Events" begin
        evtset = EventSet()

        append!(evtset, [PAPI.TOT_INS, native])
        @test length(evtset) == 2
        @test PAPI.TOT_INS in evtset
        @test native in evtset

        q = collect(evtset)
        @test eltype(q) == Event
        @test length(q) == 2
    end

    @testset "add multiple Presets" begin
        evtset = EventSet()

        append!(evtset, [PAPI.TOT_INS, PAPI.TOT_CYC])
        @test length(evtset) == 2
        @test PAPI.TOT_INS in evtset
        @test PAPI.TOT_CYC in evtset

        q = collect(evtset)
        @test eltype(q) == Event
        @test length(q) == 2
    end
end
