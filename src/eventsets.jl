"""
    EventSet

A set of PAPI native or preset events
"""
mutable struct EventSet
    val::Cint
    events::Vector{Event}

    function EventSet()
        evtset = new(PAPI_NULL, Event[])
        @papichk ccall((:PAPI_create_eventset, libpapi), Cint, (Ptr{Cint},), evtset)
        REFCOUNT[] += 1

        finalizer(evtset) do x
            @papichk ccall((:PAPI_cleanup_eventset, libpapi), Cint, (Cint,), evtset)
            @papichk ccall((:PAPI_destroy_eventset, libpapi), Cint, (Ptr{Cint},), evtset)
            deref_shutdown()
        end
        evtset
    end
end

# allows us to pass EventSet objects directly into ccall signatures
function Base.cconvert(::Type{Cint}, evtset::EventSet)
    evtset.val
end

# allows us to pass EventSet objects directly into Ptr{} ccall signatures
function Base.unsafe_convert(::Type{Ptr{Cint}}, evtset::EventSet)
    convert(Ptr{Cint}, pointer_from_objref(evtset))
end

"""
    try_add_event(evtset::EventSet, evt::Event)

Tries to add the event `evt` to the set. Returns success or not.
"""
function try_add_event(evtset::EventSet, evt::Event)
    success = ccall((:PAPI_add_event, libpapi), Cint, (Cint, Cuint), evtset, evt) == PAPI_OK
    if success
        push!(evtset.events, evt)
    end
    success
end

Base.eltype(::Type{EventSet}) = Event
Base.length(evtset::EventSet) = length(evtset.events)
Base.iterate(evtset::EventSet, i=1) = iterate(evtset.events, i)

"""
    push!(evtset::EventSet, evt::Event)

Adds one PAPI event to the set. The event can be either a native or preset event.
"""
function Base.push!(evtset::EventSet, evt::Event)
    @papichk ccall((:PAPI_add_event, libpapi), Cint, (Cint, Cuint), evtset, evt)
    push!(evtset.events, evt)
    evtset
end

"""
    append!(evtset::EventSet, evt::Vector{<:Event})

Adds multiple PAPI events to the set. The events can be either a native or preset events.
"""
function Base.append!(evtset::EventSet, evts::Vector{<:Event})
    errcode = ccall((:PAPI_add_events, libpapi), Cint, (Cint, Ptr{Cuint}, Cint), evtset, evts, length(evts))
    if errcode < 0
        throw(PAPIError(errcode))
    end

    if errcode != PAPI_OK
        @papichk ccall((:PAPI_remove_events, libpapi), Cint, (Cint, Ptr{Cuint}, Cint), evtset, evts, errcode)
        throw(PAPIError(PAPI_ECNFLCT))
    end

    append!(evtset.events, evts)
    evtset
end
Base.append!(evtset::EventSet, evts::AbstractVector{<:Event}) = append!(evtset, collect(evts))

function remove!(collection::AbstractVector, item)
    index = findfirst(isequal(item), collection)
    if index === nothing
        error("$item is not in $collection")
    else
        deleteat!(collection, index)
    end
end

"""
    delete!(evtset::EventSet, evt::Event)

Remove a PAPI events from the set. The event should have previously been added using `push!` or `append!`.
"""
function Base.delete!(evtset::EventSet, evt::Event)
    @papichk ccall((:PAPI_remove_event, libpapi), Cint, (Cint, Cuint), evtset, evt)
    remove!(evtset.events, evt)
    evtset
end

"""
    empty!(evtset::EventSet)

Remove all PAPI events from the set.
"""
function Base.empty!(evtset::EventSet)
    @papichk ccall((:PAPI_remove_events, libpapi), Cint, (Cint, Ptr{Cuint}, Cint), evtset, evtset.events, length(evtset))
    empty!(evtset.events)
    evtset
end

"""
    EventSet(evts::AbstractVector{<:Events})

Create an eventset containing the specified events. The events can be either native or preset PAPI events.
"""
function EventSet(evts::AbstractVector{<:Event})
    evtset = EventSet()
    append!(evtset, evts)
    evtset
end

"""
    EventSet(evts::Events...)

Create an eventset containing the specified events. The events can be either native or preset PAPI events.
"""
EventSet(evts::Event...) = EventSet(collect(Event, evts))

function find_add_group!(evt::Event, groups::Vector{EventSet})
    for g in groups
        if try_add_event(g, evt)
            return g
        end
    end

    push!(groups, EventSet(evt))
    last(groups)
end

"""
    measurement_groups(events::Vector{Event})

Split the list of events into subsets that can be counted at the same time.
A greedy algorithm is used, so the subsets might not be optimal. The subsets computed depends on the order of the events.
"""
function measurement_groups(events::Vector{Event})
    groups = EventSet[]

    for evt in events
        find_add_group!(evt, groups)
    end

    groups
end

"""
    collect_events(evtsets::Vector{EventSet})

Collect the event in the groups in order
"""
function collect_events(evtsets::Vector{EventSet})
    if length(evtsets) == 1
        evtsets[1].events
    else
        num_events = sum(length, evtsets)
        events = Vector{Event}(undef, num_events)

        last = 0
        for evtset in evtsets
            first = last + 1
            last = last + length(evtset)
            events[first:last] = evtset.events
        end

        events
    end
end
