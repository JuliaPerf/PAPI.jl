struct PAPIError <: Exception
	msg::String
end

function PAPIError(code::Cint)
	str = ccall((:PAPI_strerror, :libpapi), Cstring, (Cint,), code)
	msg = if str == C_NULL
		"Unknown error code $code"
	else
		Base.unsafe_string(str)
	end
	PAPIError(msg)
end

macro papichk(expr)
    :((errcode = $(esc(expr))) == PAPI_OK || throw(PAPIError(errcode)))
end
