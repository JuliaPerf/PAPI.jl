const EventSet = Ref{Cint}

function create_eventset()
    evtset = EventSet(PAPI_NULL)
    @papichk ccall((:PAPI_create_eventset, :libpapi), Cint, (Ptr{Cint},), evtset)
    evtset
end

function destroy_eventset(evtset::EventSet)
    @papichk ccall((:PAPI_cleanup_eventset, :libpapi), Cint, (Cint,), evtset[])
    @papichk ccall((:PAPI_destroy_eventset, :libpapi), Cint, (Ptr{Cint},), evtset)
end

add_event(evtset::EventSet, evt::Event) = @papichk ccall((:PAPI_add_event, :libpapi), Cint, (Cint, Cuint), evtset[], evt)
remove_event(evtset::EventSet, evt::Event) = @papichk ccall((:PAPI_remove_event, :libpapi), Cint, (Cint, Cuint), evtset[], evt)
