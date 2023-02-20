using PAPI, Test

if !PAPI.is_available()
    @info "PAPI is not available on this Platform use PAPI.set_library"
    exit()
end

include("eventset.jl")
#include("counting.jl")
include("serialization.jl")
