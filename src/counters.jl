const Counts = Clonglong

"""
	start_counters(events)

Start counting hardware events.  This function cannot be called if the counters have already been started.
"""
function start_counters(evtset::EventSet)
    nevts = length(evtset)
    if nevts == 0
        throw(ArgumentError("one or more PAPI.Events required"))
	end

    ncounters = num_counters()
    if nevts > ncounters
        throw(ArgumentError("number of PAPI.Events must be ≤ PAPI.num_counters(), got $nevts"))
	end

    @papichk ccall((:PAPI_start, :libpapi), Cint, (Cint, ), evtset)
    evtset
end

start_counters(evts::Vector{Event}) = start_counters(EventSet(evts))
start_counters(evts::Event...) = start_counters(collect(Event, evts))

"""
	reset_counters!(evtset::EventSet)

Reset counters and leaves them running after the call.
"""
function reset_counters!(evtset::EventSet)
	@papichk ccall((:PAPI_reset, :libpapi), Cint, (Cint,), evtset)
	evtset
end

"""
	read_counters!(evtset::EventSet, values::Vector{Counts})

Read and reset counters.
`read_counters!` copies the event counters into values. The counters are reset and left running after the call.

The user must provide a vector of the correct size (equal to the number of events)
"""
function read_counters!(evtset::EventSet, values::Vector{Counts})
	@assert length(evtset) == length(values)
	@papichk ccall((:PAPI_read, :libpapi), Cint, (Cint, Ptr{Counts}), evtset, values)
	@papichk ccall((:PAPI_reset, :libpapi), Cint, (Cint,), evtset)
	values
end

"""
	accum_counters!(evtset::EventSet, values::Vector{Counts})

Accumulate and reset counters.
`accum_counters!` accumulates the event counters into values. The counters are reset and left running after the call.

The user must provide a vector of the correct size (equal to the number of events)
"""
function accum_counters!(evtset::EventSet, values::Vector{Counts})
	@assert length(evtset) == length(values)
    @papichk ccall((:PAPI_accum, :libpapi), Cint, (Cint, Ptr{Counts}), evtset, values)
end

"""
	stop_counters!(evtset::EventSet, values::Vector{Counts})

Stop counters and return current counts.
The counters must have been started by a previous call to `start_counters`

The user must provide a vector of the correct size (equal to the number of events)
"""
function stop_counters!(evtset::EventSet, values::Vector{Counts})
	@assert length(evtset) == length(values)
	@papichk ccall((:PAPI_stop, :libpapi), Cint, (Cint, Ptr{Counts}), evtset, values)
	values
end

"""
	stop_counters(evtset::EventSet)

Stop counters and returns counts
The counters must have been started by a previous call to `start_counters`
"""
function stop_counters(evtset::EventSet)
	values = Vector{Counts}(undef, length(evtset))
	stop_counters!(evtset, values)
end

