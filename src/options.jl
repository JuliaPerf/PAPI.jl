const PAPI_LIB_VERSION = Cint(21)

get_option(opt, ptr) = ccall((:PAPI_get_opt, libpapi), Cint, (Cint, Ptr{Cvoid}), opt, ptr)

function version()
    ver = get_option(PAPI_LIB_VERSION, C_NULL)
    major = ver >> 24
    minor = ver >> 16 & (1 << 8 - 1)
    patch = ver & (1 << 8 - 1)
    VersionNumber(major, minor, patch)
end