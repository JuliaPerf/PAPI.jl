struct Component
    cid::Cint
end

# No GC safety needed
Base.cconvert(::Type{Cint}, c::Component) = c.cid

import Base: iterate, IteratorSize, SizeUnknown, eltype
IteratorSize(::Type{Component}) = SizeUnknown()
eltype(::Type{Component}) = Native

function iterate(comp::Component)
    r_id = Ref{Cint}(Cint(0)| API.PAPI_NATIVE_MASK)
    ret = API.PAPI_enum_cmp_event(r_id, API.PAPI_ENUM_FIRST, comp)
    if ret == PAPI_OK
        id = r_id[]
        (Native(id), id)
    else
        nothing
    end
end

function iterate(comp::Component, id::Cint)
    r_id = Ref(id)
    ret = API.PAPI_enum_cmp_event(r_id, API.PAPI_ENUM_EVENTS, comp)
    if ret == PAPI_OK
        id = r_id[]
        (Native(id), id)
    else
        nothing
    end
end

function find_component(name::AbstractString)
    numcmp = ccall((:PAPI_num_components, libpapi), Cint, ())

    for cid in 0:numcmp-1
        info = ccall((:PAPI_get_component_info, libpapi), Ptr{UInt8}, (Cint,), cid)
        if info == C_NULL
            throw(PAPIError("PAPI_get_component_info returned NULL"))
        end

        shortname = unsafe_string(info + PAPI_MAX_STR_LEN)
        if shortname == name
            return Component(cid)
        end
    end

    throw(PAPIError("find_component failed to locate component $name"))
end

function list_components()
    numcmp = ccall((:PAPI_num_components, libpapi), Cint, ())

    map(0:(numcmp-1)) do cid
        info = ccall((:PAPI_get_component_info, libpapi), Ptr{UInt8}, (Cint,), cid)
        if info == C_NULL
            throw(PAPIError("PAPI_get_component_info returned NULL"))
        end

        name = unsafe_string(info)
        shortname = unsafe_string(info + PAPI_MAX_STR_LEN)
        description = unsafe_string(info + PAPI_MAX_STR_LEN + PAPI_MIN_STR_LEN)
        name, shortname, description
    end
end

function eachcomponent()
    numcmp = ccall((:PAPI_num_components, libpapi), Cint, ())
    (Component(i) for i in 0:numcmp-1)
end

"""
    available_native()

Returns a list of the native events available on the current platform.
"""
function available_native()
    evtset = EventSet()
    function test_event(evt::Event)
        if try_add_event(evtset, evt)
            delete!(evtset, evt)
            true
        else
            false
        end
    end

    events = Event[]
    for c in eachcomponent()
        for evt in c
            if test_event(evt)
                push!(events, evt)
            end
        end
    end

    events
end

function EventSet(c::Component)
    ev_set = EventSet()
    API.PAPI_assign_eventset_component(ev_set, c)
    return ev_set
end

function info(c::Component)
    info = API.PAPI_get_component_info(c)
    name = Base.unsafe_string(Base.unsafe_convert(Ptr{Cchar}, info.name))

    initialized = Base.unsafe_load(info.initialized)
    disabled = Base.unsafe_load(info.disabled)

    if disabled == 0
        disabled = false
        disabled_reason = nothing
    else
        disabled = PAPIError(disabled)
        disabled_reason = Base.unsafe_string(Base.unsafe_convert(Ptr{Cchar}, info.disabled_reason))
    end
    return (;name, initialized, disabled, disabled_reason)
end