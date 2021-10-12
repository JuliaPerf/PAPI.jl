struct Component
    cid::Cint
end

import Base: iterate, IteratorSize, SizeUnknown, eltype
IteratorSize(::Type{Component}) = SizeUnknown()
eltype(::Type{Component}) = Native

function iterate(comp::Component)
    id = Ref{Cuint}(PAPI_NATIVE_MASK)
    ret = ccall((:PAPI_enum_cmp_event, libpapi), Cint, (Ptr{Cuint}, Cint, Cint), id, PAPI_ENUM_FIRST, getfield(comp, :cid))
    if ret == PAPI_OK
        (Event(id[]), id)
    else
        nothing
    end
end

function iterate(comp::Component, id::Ref{Cuint})
    ret = ccall((:PAPI_enum_cmp_event, libpapi), Cint, (Ptr{Cuint}, Cint, Cint), id, PAPI_ENUM_EVENTS, getfield(comp, :cid))
    if ret == PAPI_OK
        (Event(id[]), id)
    else
        nothing
    end
end

function find_component(name::AbstractString; throw_on_error::Bool=true)
    cid = ccall((:PAPI_get_component_index, libpapi), Cint, (Cstring,), name)
    if cid >= 0
        Component(cid)
    else
        throw_on_error && throw(PAPIError("find_component failed to locate component $name"))
        nothing
    end
end

Component(name::AbstractString) = find_component(name)

function cleanup_name(evt::Event)
    name = event_to_name(evt)
    idx = findfirst("::", name)
    replace(idx === nothing ? name : name[last(idx)+1:end], "-" => "_")
end

import Base: propertynames, getproperty, keys, getindex
propertynames(c::Component) = map(Symbol ∘ cleanup_name, c)
keys(c::Component) = map(cleanup_name, c)

function getproperty(c::Component, prop::Symbol)
    name = String(prop)
    getindex(c, name)
end

function getindex(c::Component, name::AbstractString)
    # Try to find it using name_to_event
    evt = try_name_to_event(name)
    if evt !== nothing && get_event_component_id(evt) == getfield(c, :cid)
        return evt
    end

    # Convert from _ to - and try again
    evt = try_name_to_event( replace(name, "_" => "-") )
    if evt !== nothing && get_event_component_id(evt) == getfield(c, :cid)
        return evt
    end

    # Fall-back
    str_buf = Vector{UInt8}(undef,PAPI_MAX_STR_LEN)
    for evt in c
        @papichk ccall((:PAPI_event_code_to_name, libpapi), Cint, (Cuint, Ptr{UInt8}), evt, str_buf)
        if name == unsafe_string(pointer(str_buf))
            return evt
        end
    end

    nothing
end

function list_components()
    numcmp = ccall((:PAPI_num_components, libpapi), Cint, ())

    map(0:numcmp-1) do cid
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

function get_event_component_id(evt::Native)
    cidx = ccall((:PAPI_get_event_component, libpapi), Cint, (Cint,), evt)
    cidx < 0 && throw(PAPIError(cidx))
    cidx
end

function get_event_component(evt::Native)
    cidx = get_event_component_id(evt)
    Component(cidx)
end
