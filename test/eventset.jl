using PAPI, Test

@testset "eventset" begin
    @testset "add/remove" begin
        evtset = EventSet()

        # add a preset
        push!(evtset, PAPI.TOT_INS)

        # add "native"
        native = event"PAPI_TOT_CYC"
        push!(evtset, native)

        @test length(evtset) == 2
        @test PAPI.TOT_INS in evtset
        @test native in evtset

        delete!(evtset, native)
        @test ! (native in evtset)

        empty!(evtset)
        @test isempty(evtset)

        append!(evtset, [PAPI.TOT_INS, native])
        @test length(evtset) == 2
        @test PAPI.TOT_INS in evtset
        @test native in evtset

        q = collect(evtset)
        @test eltype(q) == Event
        @test length(q) == 2
    end
end
