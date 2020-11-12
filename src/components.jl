struct Component
    cid::Cint
end

import Base: iterate
function iterate(comp::Component)
    id = Ref{Cuint}(PAPI_NATIVE_MASK)
    ret = ccall((:PAPI_enum_cmp_event, :libpapi), Cint, (Ptr{Cuint}, Cint, Cint), id, PAPI_ENUM_FIRST, comp.cid)
    if ret == PAPI_OK
        (id[], id[])
    else
        nothing
    end
end

function iterate(comp::Component, state::Cuint)
    id = Ref{Cuint}(state)
    ret = ccall((:PAPI_enum_cmp_event, :libpapi), Cint, (Ptr{Cuint}, Cint, Cint), id, PAPI_ENUM_EVENTS, comp.cid)
    if ret == PAPI_OK
        (id[], id[])
    else
        nothing
    end
end

function find_component(name::AbstractString)
    numcmp = ccall((:PAPI_num_components, :libpapi), Cint, ())

    for cid in 0:numcmp-1
        info = ccall((:PAPI_get_component_info, :libpapi), Ptr{UInt8}, (Cint,), cid)
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
    numcmp = ccall((:PAPI_num_components, :libpapi), Cint, ())

    map(0:numcmp-1) do cid
        info = ccall((:PAPI_get_component_info, :libpapi), Ptr{UInt8}, (Cint,), cid)
        if info == C_NULL
            throw(PAPIError("PAPI_get_component_info returned NULL"))
        end

        name = unsafe_string(info)
        shortname = unsafe_string(info + PAPI_MAX_STR_LEN)
        description = unsafe_string(info + PAPI_MAX_STR_LEN + PAPI_MIN_STR_LEN)
        name, shortname, description
    end
end

