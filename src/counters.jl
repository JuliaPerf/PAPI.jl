const Counts = Clonglong

"""
	start_counters(events)

Start counting hardware events.  This function cannot be called if the counters have already been started.
"""
function start_counters(evts::Vector{Event})
    nevts = length(evts)
    if nevts == 0
        throw(ArgumentError("one or more PAPI.Events required"))
	end

    ncounters = num_counters()
    if nevts > ncounters
        throw(ArgumentError("number of PAPI.Events must be ≤ PAPI.num_counters(), got $nevts"))
	end

    @papichk ccall((:PAPI_start_counters, :libpapi), Cint, (Ptr{Cuint}, Cint), evts, nevts)
    return
end

start_counters(evts::Event...) = start_counters(collect(evts))

"""
	read_counters!(values::Vector{Counts})

Read and reset counters.
`read_counters!` copies the event counters into values. The counters are reset and left running after the call.

The user must provide a vector of the correct size (equal to the number of events)
"""
function read_counters!(values::Vector{Counts})
	@papichk ccall((:PAPI_read_counters, :libpapi), Cint, (Ptr{Counts}, Cint), values, length(values))
	values
end

"""
	accum_counters!(values::Vector{Counts})

Accumulate and reset counters.
`accum_counters!` accumulates the event counters into values. The counters are reset and left running after the call.

The user must provide a vector of the correct size (equal to the number of events)
"""
function accum_counters!(values::Vector{Counts})
    @papichk ccall((:PAPI_accum_counters, :libpapi), Cint, (Ptr{Counts}, Cint), values, length(values))
end

"""
	stop_counters!(values::Vector{Counts})

Stop counters and return current counts.
The counters must have been started by a previous call to `start_counters`

The user must provide a vector of the correct size (equal to the number of events)
"""
function stop_counters!(values::Vector{Counts})
	numevents = length(values)
	@papichk ccall((:PAPI_stop_counters, :libpapi), Cint, (Ptr{Counts}, Cint), values, numevents)
	values
end

"""
	stop_counters(evts::Vector{Event})

Stop counters and returns counts
The counters must have been started by a previous call to `start_counters`
"""
function stop_counters(evts::Vector{Event})
	values = Vector{Counts}(undef, length(evts))
	stop_counters!(values)
end

