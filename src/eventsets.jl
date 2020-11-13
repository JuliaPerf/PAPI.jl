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

add_event(evtset::EventSet, evt::Event) = ccall((:PAPI_add_event, :libpapi), Cint, (Cint, Cuint), evtset[], evt) == PAPI_OK
remove_event(evtset::EventSet, evt::Event) = @papichk ccall((:PAPI_remove_event, :libpapi), Cint, (Cint, Cuint), evtset[], evt)

function find_group(evt::Event, groups::Vector{EventSet})
    for (j, g) in enumerate(groups)
        if add_event(g, evt)
            return j
        end
    end

    push!(groups, create_eventset())
    return length(groups)
end

function measurement_groups(events::Vector{Event})
    groups = EventSet[]
    assignment = zeros(Int64, size(events))

    @inbounds for (i, evt) in enumerate(events)
        j = find_group(evt, groups)
        assignment[i] = j
    end

    @inbounds for j in 1:length(groups)
        destroy_eventset(groups[j])
    end

    assignment
end
