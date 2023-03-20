using CUDA
import Libdl

CUDA.versioninfo()
# Libdl.dlopen(CUDA.CUDA_Driver_jll.libcuda, Libdl.RTLD_NOW | Libdl.RTLD_GLOBAL)
# Libdl.dlopen(CUDA.CUDA_Runtime_jll.libcudart, Libdl.RTLD_NOW | Libdl.RTLD_GLOBAL)
# Libdl.dlopen(CUDA.CUDA_Runtime_jll.libcupti, Libdl.RTLD_NOW | Libdl.RTLD_GLOBAL)

using PAPI
using Unitful

# module CycleUnits
#     using Unitful
#     @unit    nat    "nat"      Nat                1            false
#     @unit    bit    "bit"      Bit          log(2)*u"nat"      false
#     @unit      B    "B"        Byte              8bit          false
#     Unitful.register(@__MODULE__)
# end

# https://crd.lbl.gov/assets/Uploads/ECP22-Roofline-2-NVIDIA-and-NERSC.pdf
# https://www.exascaleproject.org/wp-content/uploads/2021/01/PAPI_BOF_Presentation-pdf.pdf

# - DRAM: `cuda:::dram__bytes.sum`
# - L2: `cuda:::lts__t_bytes.sum`
# - L1: `cuda:::l1tex__t_bytes.sum`

# - Double precision:
#   - `cuda:::sm__sass_thread_inst_executed_op_dadd_pred_on.sum`
#   - `cuda:::sm__sass_thread_inst_executed_op_dmul_pred_on.sum`
#   - `cuda:::sm__sass_thread_inst_executed_op_dfma_pred_on.sum`

function time_events!(ev_set, dev)
    @assert PAPI.try_add_event(ev_set, PAPI.name_to_event("cuda:::sm__cycles_elapsed.avg:device=$dev"))
    @assert PAPI.try_add_event(ev_set, PAPI.name_to_event("cuda:::sm__cycles_elapsed.avg.per_second:device=$dev"))
end

function memory_events!(ev_set, dev)
    @assert PAPI.try_add_event(ev_set, PAPI.name_to_event("cuda:::dram__bytes.sum.per_second:device=$dev"))
    @assert PAPI.try_add_event(ev_set, PAPI.name_to_event("cuda:::lts__t_bytes.sum.per_second:device=$dev")) # L2
    @assert PAPI.try_add_event(ev_set, PAPI.name_to_event("cuda:::l1tex__t_bytes.sum.per_second:device=$dev"))
end

function float_events!(ev_set, dev, ::Type{T}) where T<:AbstractFloat
    prefix = if T == Float64
        'd'
    elseif T == Float32
        'f'
    elseif T == Float16
        'h'
    else
        error("Unknown $T")
    end
    @assert PAPI.try_add_event(ev_set, 
        PAPI.name_to_event("cuda:::sm__sass_thread_inst_executed_op_$(prefix)add_pred_on.sum:device=$dev"))
    @assert PAPI.try_add_event(ev_set, 
        PAPI.name_to_event("cuda:::sm__sass_thread_inst_executed_op_$(prefix)mul_pred_on.sum:device=$dev"))
    @assert PAPI.try_add_event(ev_set, 
        PAPI.name_to_event("cuda:::sm__sass_thread_inst_executed_op_$(prefix)fma_pred_on.sum:device=$dev"))
end

function measure(f, ::Type{T}) where T
    pcuda = PAPI.find_component("cuda")
    ev_set_mem = PAPI.EventSet(pcuda)
    ev_set_flops = PAPI.EventSet(pcuda)

    dev = CUDA.device().handle
    memory_events!(ev_set_mem, dev)
    time_events!(ev_set_mem, dev)

    float_events!(ev_set_flops, dev, T)

    PAPI.start_counters(ev_set_mem)
    CUDA.@sync f()
    counters = PAPI.stop_counters(ev_set_mem)

    # dram, l2, l1 in bytes.per_second
    dram, l2, l1, cycles, cycles_per_second = counters
    time = cycles/cycles_per_second

    PAPI.start_counters(ev_set_flops)
    CUDA.@sync f()

    counters = PAPI.stop_counters(ev_set_flops)
    add, mul, fma = counters

    flop = add + mul + 2fma
    flops = flop/time

    (;dram, l2, l1, cycles, cycles_per_second, time, add, mul, fma, flop, flops)
end

function square_kernel!(A, B)
    idx = threadIdx().x
    @inbounds b = B[idx]
    @inbounds A[idx] = b^2
    nothing
end

A = CUDA.zeros(1024)
B = CUDA.zeros(1024)

results = measure(eltype(A)) do
    @cuda threads=1024 square_kernel!(A, B)
end

@show results
