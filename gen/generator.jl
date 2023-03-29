using Clang.Generators
using PAPI_jll

@assert PAPI_jll.is_available()

cd(@__DIR__)

include_dir = normpath(PAPI_jll.artifact_dir, "include")

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()  # Note you must call this function firstly and then append your own flags
push!(args, "-I$include_dir")

# there is also an experimental `detect_headers` function for auto-detecting top-level headers in the directory
headers = [joinpath(include_dir, "papi.h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)