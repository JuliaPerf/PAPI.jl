module API

import ..PAPI: libpapi
PAPI_VERSION_NUMBER(maj,min,rev,inc) = (((maj)<<24) | ((min)<<16) | ((rev)<<8) | (inc))


function PAPI_get_event_component(EventCode)
    ccall((:PAPI_get_event_component, libpapi), Cint, (Cint,), EventCode)
end

function PAPI_strerror(arg1)
    ccall((:PAPI_strerror, libpapi), Ptr{Cchar}, (Cint,), arg1)
end

const var"##Ctag#304" = UInt32
const PAPI_L1_DCM_idx = 0 % UInt32
const PAPI_L1_ICM_idx = 1 % UInt32
const PAPI_L2_DCM_idx = 2 % UInt32
const PAPI_L2_ICM_idx = 3 % UInt32
const PAPI_L3_DCM_idx = 4 % UInt32
const PAPI_L3_ICM_idx = 5 % UInt32
const PAPI_L1_TCM_idx = 6 % UInt32
const PAPI_L2_TCM_idx = 7 % UInt32
const PAPI_L3_TCM_idx = 8 % UInt32
const PAPI_CA_SNP_idx = 9 % UInt32
const PAPI_CA_SHR_idx = 10 % UInt32
const PAPI_CA_CLN_idx = 11 % UInt32
const PAPI_CA_INV_idx = 12 % UInt32
const PAPI_CA_ITV_idx = 13 % UInt32
const PAPI_L3_LDM_idx = 14 % UInt32
const PAPI_L3_STM_idx = 15 % UInt32
const PAPI_BRU_IDL_idx = 16 % UInt32
const PAPI_FXU_IDL_idx = 17 % UInt32
const PAPI_FPU_IDL_idx = 18 % UInt32
const PAPI_LSU_IDL_idx = 19 % UInt32
const PAPI_TLB_DM_idx = 20 % UInt32
const PAPI_TLB_IM_idx = 21 % UInt32
const PAPI_TLB_TL_idx = 22 % UInt32
const PAPI_L1_LDM_idx = 23 % UInt32
const PAPI_L1_STM_idx = 24 % UInt32
const PAPI_L2_LDM_idx = 25 % UInt32
const PAPI_L2_STM_idx = 26 % UInt32
const PAPI_BTAC_M_idx = 27 % UInt32
const PAPI_PRF_DM_idx = 28 % UInt32
const PAPI_L3_DCH_idx = 29 % UInt32
const PAPI_TLB_SD_idx = 30 % UInt32
const PAPI_CSR_FAL_idx = 31 % UInt32
const PAPI_CSR_SUC_idx = 32 % UInt32
const PAPI_CSR_TOT_idx = 33 % UInt32
const PAPI_MEM_SCY_idx = 34 % UInt32
const PAPI_MEM_RCY_idx = 35 % UInt32
const PAPI_MEM_WCY_idx = 36 % UInt32
const PAPI_STL_ICY_idx = 37 % UInt32
const PAPI_FUL_ICY_idx = 38 % UInt32
const PAPI_STL_CCY_idx = 39 % UInt32
const PAPI_FUL_CCY_idx = 40 % UInt32
const PAPI_HW_INT_idx = 41 % UInt32
const PAPI_BR_UCN_idx = 42 % UInt32
const PAPI_BR_CN_idx = 43 % UInt32
const PAPI_BR_TKN_idx = 44 % UInt32
const PAPI_BR_NTK_idx = 45 % UInt32
const PAPI_BR_MSP_idx = 46 % UInt32
const PAPI_BR_PRC_idx = 47 % UInt32
const PAPI_FMA_INS_idx = 48 % UInt32
const PAPI_TOT_IIS_idx = 49 % UInt32
const PAPI_TOT_INS_idx = 50 % UInt32
const PAPI_INT_INS_idx = 51 % UInt32
const PAPI_FP_INS_idx = 52 % UInt32
const PAPI_LD_INS_idx = 53 % UInt32
const PAPI_SR_INS_idx = 54 % UInt32
const PAPI_BR_INS_idx = 55 % UInt32
const PAPI_VEC_INS_idx = 56 % UInt32
const PAPI_RES_STL_idx = 57 % UInt32
const PAPI_FP_STAL_idx = 58 % UInt32
const PAPI_TOT_CYC_idx = 59 % UInt32
const PAPI_LST_INS_idx = 60 % UInt32
const PAPI_SYC_INS_idx = 61 % UInt32
const PAPI_L1_DCH_idx = 62 % UInt32
const PAPI_L2_DCH_idx = 63 % UInt32
const PAPI_L1_DCA_idx = 64 % UInt32
const PAPI_L2_DCA_idx = 65 % UInt32
const PAPI_L3_DCA_idx = 66 % UInt32
const PAPI_L1_DCR_idx = 67 % UInt32
const PAPI_L2_DCR_idx = 68 % UInt32
const PAPI_L3_DCR_idx = 69 % UInt32
const PAPI_L1_DCW_idx = 70 % UInt32
const PAPI_L2_DCW_idx = 71 % UInt32
const PAPI_L3_DCW_idx = 72 % UInt32
const PAPI_L1_ICH_idx = 73 % UInt32
const PAPI_L2_ICH_idx = 74 % UInt32
const PAPI_L3_ICH_idx = 75 % UInt32
const PAPI_L1_ICA_idx = 76 % UInt32
const PAPI_L2_ICA_idx = 77 % UInt32
const PAPI_L3_ICA_idx = 78 % UInt32
const PAPI_L1_ICR_idx = 79 % UInt32
const PAPI_L2_ICR_idx = 80 % UInt32
const PAPI_L3_ICR_idx = 81 % UInt32
const PAPI_L1_ICW_idx = 82 % UInt32
const PAPI_L2_ICW_idx = 83 % UInt32
const PAPI_L3_ICW_idx = 84 % UInt32
const PAPI_L1_TCH_idx = 85 % UInt32
const PAPI_L2_TCH_idx = 86 % UInt32
const PAPI_L3_TCH_idx = 87 % UInt32
const PAPI_L1_TCA_idx = 88 % UInt32
const PAPI_L2_TCA_idx = 89 % UInt32
const PAPI_L3_TCA_idx = 90 % UInt32
const PAPI_L1_TCR_idx = 91 % UInt32
const PAPI_L2_TCR_idx = 92 % UInt32
const PAPI_L3_TCR_idx = 93 % UInt32
const PAPI_L1_TCW_idx = 94 % UInt32
const PAPI_L2_TCW_idx = 95 % UInt32
const PAPI_L3_TCW_idx = 96 % UInt32
const PAPI_FML_INS_idx = 97 % UInt32
const PAPI_FAD_INS_idx = 98 % UInt32
const PAPI_FDV_INS_idx = 99 % UInt32
const PAPI_FSQ_INS_idx = 100 % UInt32
const PAPI_FNV_INS_idx = 101 % UInt32
const PAPI_FP_OPS_idx = 102 % UInt32
const PAPI_SP_OPS_idx = 103 % UInt32
const PAPI_DP_OPS_idx = 104 % UInt32
const PAPI_VEC_SP_idx = 105 % UInt32
const PAPI_VEC_DP_idx = 106 % UInt32
const PAPI_REF_CYC_idx = 107 % UInt32
const PAPI_END_idx = 108 % UInt32

const var"##Ctag#305" = UInt32
const PAPI_ENUM_EVENTS = 0 % UInt32
const PAPI_ENUM_FIRST = 1 % UInt32
const PAPI_PRESET_ENUM_AVAIL = 2 % UInt32
const PAPI_PRESET_ENUM_MSC = 3 % UInt32
const PAPI_PRESET_ENUM_INS = 4 % UInt32
const PAPI_PRESET_ENUM_IDL = 5 % UInt32
const PAPI_PRESET_ENUM_BR = 6 % UInt32
const PAPI_PRESET_ENUM_CND = 7 % UInt32
const PAPI_PRESET_ENUM_MEM = 8 % UInt32
const PAPI_PRESET_ENUM_CACH = 9 % UInt32
const PAPI_PRESET_ENUM_L1 = 10 % UInt32
const PAPI_PRESET_ENUM_L2 = 11 % UInt32
const PAPI_PRESET_ENUM_L3 = 12 % UInt32
const PAPI_PRESET_ENUM_TLB = 13 % UInt32
const PAPI_PRESET_ENUM_FP = 14 % UInt32
const PAPI_NTV_ENUM_UMASKS = 15 % UInt32
const PAPI_NTV_ENUM_UMASK_COMBOS = 16 % UInt32
const PAPI_NTV_ENUM_IARR = 17 % UInt32
const PAPI_NTV_ENUM_DARR = 18 % UInt32
const PAPI_NTV_ENUM_OPCM = 19 % UInt32
const PAPI_NTV_ENUM_IEAR = 20 % UInt32
const PAPI_NTV_ENUM_DEAR = 21 % UInt32
const PAPI_NTV_ENUM_GROUPS = 22 % UInt32

const PAPI_thread_id_t = Culong

struct _papi_all_thr_spec
    data::NTuple{24, UInt8}
end

function Base.getproperty(x::Ptr{_papi_all_thr_spec}, f::Symbol)
    f === :num && return Ptr{Cint}(x + 0)
    f === :id && return Ptr{Ptr{PAPI_thread_id_t}}(x + 8)
    f === :data && return Ptr{Ptr{Ptr{Cvoid}}}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_all_thr_spec, f::Symbol)
    r = Ref{_papi_all_thr_spec}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_all_thr_spec}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_all_thr_spec}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_all_thr_spec_t = _papi_all_thr_spec

# typedef void ( * PAPI_overflow_handler_t ) ( int EventSet , void * address , long long overflow_vector , void * context )
const PAPI_overflow_handler_t = Ptr{Cvoid}

const vptr_t = Ptr{Cvoid}

struct _papi_sprofil
    data::NTuple{32, UInt8}
end

function Base.getproperty(x::Ptr{_papi_sprofil}, f::Symbol)
    f === :pr_base && return Ptr{Ptr{Cvoid}}(x + 0)
    f === :pr_size && return Ptr{Cuint}(x + 8)
    f === :pr_off && return Ptr{vptr_t}(x + 16)
    f === :pr_scale && return Ptr{Cuint}(x + 24)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_sprofil, f::Symbol)
    r = Ref{_papi_sprofil}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_sprofil}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_sprofil}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_sprofil_t = _papi_sprofil

struct _papi_itimer_option
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{_papi_itimer_option}, f::Symbol)
    f === :itimer_num && return Ptr{Cint}(x + 0)
    f === :itimer_sig && return Ptr{Cint}(x + 4)
    f === :ns && return Ptr{Cint}(x + 8)
    f === :flags && return Ptr{Cint}(x + 12)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_itimer_option, f::Symbol)
    r = Ref{_papi_itimer_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_itimer_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_itimer_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_itimer_option_t = _papi_itimer_option

struct _papi_inherit_option
    data::NTuple{8, UInt8}
end

function Base.getproperty(x::Ptr{_papi_inherit_option}, f::Symbol)
    f === :eventset && return Ptr{Cint}(x + 0)
    f === :inherit && return Ptr{Cint}(x + 4)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_inherit_option, f::Symbol)
    r = Ref{_papi_inherit_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_inherit_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_inherit_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_inherit_option_t = _papi_inherit_option

struct _papi_domain_option
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{_papi_domain_option}, f::Symbol)
    f === :def_cidx && return Ptr{Cint}(x + 0)
    f === :eventset && return Ptr{Cint}(x + 4)
    f === :domain && return Ptr{Cint}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_domain_option, f::Symbol)
    r = Ref{_papi_domain_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_domain_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_domain_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_domain_option_t = _papi_domain_option

struct _papi_granularity_option
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{_papi_granularity_option}, f::Symbol)
    f === :def_cidx && return Ptr{Cint}(x + 0)
    f === :eventset && return Ptr{Cint}(x + 4)
    f === :granularity && return Ptr{Cint}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_granularity_option, f::Symbol)
    r = Ref{_papi_granularity_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_granularity_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_granularity_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_granularity_option_t = _papi_granularity_option

struct _papi_preload_option
    data::NTuple{258, UInt8}
end

function Base.getproperty(x::Ptr{_papi_preload_option}, f::Symbol)
    f === :lib_preload_env && return Ptr{NTuple{128, Cchar}}(x + 0)
    f === :lib_preload_sep && return Ptr{Cchar}(x + 128)
    f === :lib_dir_env && return Ptr{NTuple{128, Cchar}}(x + 129)
    f === :lib_dir_sep && return Ptr{Cchar}(x + 257)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_preload_option, f::Symbol)
    r = Ref{_papi_preload_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_preload_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_preload_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_preload_info_t = _papi_preload_option

struct _papi_component_option
    data::NTuple{2272, UInt8}
end

function Base.getproperty(x::Ptr{_papi_component_option}, f::Symbol)
    f === :name && return Ptr{NTuple{128, Cchar}}(x + 0)
    f === :short_name && return Ptr{NTuple{64, Cchar}}(x + 128)
    f === :description && return Ptr{NTuple{128, Cchar}}(x + 192)
    f === :version && return Ptr{NTuple{64, Cchar}}(x + 320)
    f === :support_version && return Ptr{NTuple{64, Cchar}}(x + 384)
    f === :kernel_version && return Ptr{NTuple{64, Cchar}}(x + 448)
    f === :disabled_reason && return Ptr{NTuple{1024, Cchar}}(x + 512)
    f === :disabled && return Ptr{Cint}(x + 1536)
    f === :initialized && return Ptr{Cint}(x + 1540)
    f === :CmpIdx && return Ptr{Cint}(x + 1544)
    f === :num_cntrs && return Ptr{Cint}(x + 1548)
    f === :num_mpx_cntrs && return Ptr{Cint}(x + 1552)
    f === :num_preset_events && return Ptr{Cint}(x + 1556)
    f === :num_native_events && return Ptr{Cint}(x + 1560)
    f === :default_domain && return Ptr{Cint}(x + 1564)
    f === :available_domains && return Ptr{Cint}(x + 1568)
    f === :default_granularity && return Ptr{Cint}(x + 1572)
    f === :available_granularities && return Ptr{Cint}(x + 1576)
    f === :hardware_intr_sig && return Ptr{Cint}(x + 1580)
    f === :component_type && return Ptr{Cint}(x + 1584)
    f === :pmu_names && return Ptr{NTuple{80, Ptr{Cchar}}}(x + 1592)
    f === :reserved && return Ptr{NTuple{8, Cint}}(x + 2232)
    f === :hardware_intr && return (Ptr{Cuint}(x + 2264), 0, 1)
    f === :precise_intr && return (Ptr{Cuint}(x + 2264), 1, 1)
    f === :posix1b_timers && return (Ptr{Cuint}(x + 2264), 2, 1)
    f === :kernel_profile && return (Ptr{Cuint}(x + 2264), 3, 1)
    f === :kernel_multiplex && return (Ptr{Cuint}(x + 2264), 4, 1)
    f === :fast_counter_read && return (Ptr{Cuint}(x + 2264), 5, 1)
    f === :fast_real_timer && return (Ptr{Cuint}(x + 2264), 6, 1)
    f === :fast_virtual_timer && return (Ptr{Cuint}(x + 2264), 7, 1)
    f === :attach && return (Ptr{Cuint}(x + 2264), 8, 1)
    f === :attach_must_ptrace && return (Ptr{Cuint}(x + 2264), 9, 1)
    f === :cntr_umasks && return (Ptr{Cuint}(x + 2264), 10, 1)
    f === :cpu && return (Ptr{Cuint}(x + 2264), 11, 1)
    f === :inherit && return (Ptr{Cuint}(x + 2264), 12, 1)
    f === :reserved_bits && return (Ptr{Cuint}(x + 2264), 13, 19)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_component_option, f::Symbol)
    r = Ref{_papi_component_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_component_option}, r)
    fptr = getproperty(ptr, f)
    begin
        if fptr isa Ptr
            return GC.@preserve(r, unsafe_load(fptr))
        else
            (baseptr, offset, width) = fptr
            ty = eltype(baseptr)
            baseptr32 = convert(Ptr{UInt32}, baseptr)
            u64 = GC.@preserve(r, unsafe_load(baseptr32))
            if offset + width > 32
                u64 |= GC.@preserve(r, unsafe_load(baseptr32 + 4)) << 32
            end
            u64 = u64 >> offset & (1 << width - 1)
            return u64 % ty
        end
    end
end

function Base.setproperty!(x::Ptr{_papi_component_option}, f::Symbol, v)
    fptr = getproperty(x, f)
    if fptr isa Ptr
        unsafe_store!(getproperty(x, f), v)
    else
        (baseptr, offset, width) = fptr
        baseptr32 = convert(Ptr{UInt32}, baseptr)
        u64 = unsafe_load(baseptr32)
        straddle = offset + width > 32
        if straddle
            u64 |= unsafe_load(baseptr32 + 4) << 32
        end
        mask = 1 << width - 1
        u64 &= ~(mask << offset)
        u64 |= (unsigned(v) & mask) << offset
        unsafe_store!(baseptr32, u64 & typemax(UInt32))
        if straddle
            unsafe_store!(baseptr32 + 4, u64 >> 32)
        end
    end
end

const PAPI_component_info_t = _papi_component_option

struct _papi_mpx_info
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{_papi_mpx_info}, f::Symbol)
    f === :timer_sig && return Ptr{Cint}(x + 0)
    f === :timer_num && return Ptr{Cint}(x + 4)
    f === :timer_us && return Ptr{Cint}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_mpx_info, f::Symbol)
    r = Ref{_papi_mpx_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_mpx_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_mpx_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_mpx_info_t = _papi_mpx_info

# typedef int ( * PAPI_debug_handler_t ) ( int code )
const PAPI_debug_handler_t = Ptr{Cvoid}

struct _papi_debug_option
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{_papi_debug_option}, f::Symbol)
    f === :level && return Ptr{Cint}(x + 0)
    f === :handler && return Ptr{PAPI_debug_handler_t}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_debug_option, f::Symbol)
    r = Ref{_papi_debug_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_debug_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_debug_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_debug_option_t = _papi_debug_option

struct _papi_address_map
    data::NTuple{1072, UInt8}
end

function Base.getproperty(x::Ptr{_papi_address_map}, f::Symbol)
    f === :name && return Ptr{NTuple{1024, Cchar}}(x + 0)
    f === :text_start && return Ptr{vptr_t}(x + 1024)
    f === :text_end && return Ptr{vptr_t}(x + 1032)
    f === :data_start && return Ptr{vptr_t}(x + 1040)
    f === :data_end && return Ptr{vptr_t}(x + 1048)
    f === :bss_start && return Ptr{vptr_t}(x + 1056)
    f === :bss_end && return Ptr{vptr_t}(x + 1064)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_address_map, f::Symbol)
    r = Ref{_papi_address_map}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_address_map}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_address_map}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_address_map_t = _papi_address_map

struct _papi_program_info
    data::NTuple{2096, UInt8}
end

function Base.getproperty(x::Ptr{_papi_program_info}, f::Symbol)
    f === :fullname && return Ptr{NTuple{1024, Cchar}}(x + 0)
    f === :address_info && return Ptr{PAPI_address_map_t}(x + 1024)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_program_info, f::Symbol)
    r = Ref{_papi_program_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_program_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_program_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_exe_info_t = _papi_program_info

struct _papi_shared_lib_info
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{_papi_shared_lib_info}, f::Symbol)
    f === :map && return Ptr{Ptr{PAPI_address_map_t}}(x + 0)
    f === :count && return Ptr{Cint}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_shared_lib_info, f::Symbol)
    r = Ref{_papi_shared_lib_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_shared_lib_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_shared_lib_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_shlib_info_t = _papi_shared_lib_info

const PAPI_user_defined_events_file_t = Ptr{Cchar}

struct _papi_mh_tlb_info
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{_papi_mh_tlb_info}, f::Symbol)
    f === :type && return Ptr{Cint}(x + 0)
    f === :num_entries && return Ptr{Cint}(x + 4)
    f === :page_size && return Ptr{Cint}(x + 8)
    f === :associativity && return Ptr{Cint}(x + 12)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_mh_tlb_info, f::Symbol)
    r = Ref{_papi_mh_tlb_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_mh_tlb_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_mh_tlb_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_mh_tlb_info_t = _papi_mh_tlb_info

struct _papi_mh_cache_info
    data::NTuple{20, UInt8}
end

function Base.getproperty(x::Ptr{_papi_mh_cache_info}, f::Symbol)
    f === :type && return Ptr{Cint}(x + 0)
    f === :size && return Ptr{Cint}(x + 4)
    f === :line_size && return Ptr{Cint}(x + 8)
    f === :num_lines && return Ptr{Cint}(x + 12)
    f === :associativity && return Ptr{Cint}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_mh_cache_info, f::Symbol)
    r = Ref{_papi_mh_cache_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_mh_cache_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_mh_cache_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_mh_cache_info_t = _papi_mh_cache_info

struct _papi_mh_level_info
    data::NTuple{216, UInt8}
end

function Base.getproperty(x::Ptr{_papi_mh_level_info}, f::Symbol)
    f === :tlb && return Ptr{NTuple{6, PAPI_mh_tlb_info_t}}(x + 0)
    f === :cache && return Ptr{NTuple{6, PAPI_mh_cache_info_t}}(x + 96)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_mh_level_info, f::Symbol)
    r = Ref{_papi_mh_level_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_mh_level_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_mh_level_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_mh_level_t = _papi_mh_level_info

struct _papi_mh_info
    data::NTuple{868, UInt8}
end

function Base.getproperty(x::Ptr{_papi_mh_info}, f::Symbol)
    f === :levels && return Ptr{Cint}(x + 0)
    f === :level && return Ptr{NTuple{4, PAPI_mh_level_t}}(x + 4)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_mh_info, f::Symbol)
    r = Ref{_papi_mh_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_mh_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_mh_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_mh_info_t = _papi_mh_info

struct _papi_hw_info
    data::NTuple{1480, UInt8}
end

function Base.getproperty(x::Ptr{_papi_hw_info}, f::Symbol)
    f === :ncpu && return Ptr{Cint}(x + 0)
    f === :threads && return Ptr{Cint}(x + 4)
    f === :cores && return Ptr{Cint}(x + 8)
    f === :sockets && return Ptr{Cint}(x + 12)
    f === :nnodes && return Ptr{Cint}(x + 16)
    f === :totalcpus && return Ptr{Cint}(x + 20)
    f === :vendor && return Ptr{Cint}(x + 24)
    f === :vendor_string && return Ptr{NTuple{128, Cchar}}(x + 28)
    f === :model && return Ptr{Cint}(x + 156)
    f === :model_string && return Ptr{NTuple{128, Cchar}}(x + 160)
    f === :revision && return Ptr{Cfloat}(x + 288)
    f === :cpuid_family && return Ptr{Cint}(x + 292)
    f === :cpuid_model && return Ptr{Cint}(x + 296)
    f === :cpuid_stepping && return Ptr{Cint}(x + 300)
    f === :cpu_max_mhz && return Ptr{Cint}(x + 304)
    f === :cpu_min_mhz && return Ptr{Cint}(x + 308)
    f === :mem_hierarchy && return Ptr{PAPI_mh_info_t}(x + 312)
    f === :virtualized && return Ptr{Cint}(x + 1180)
    f === :virtual_vendor_string && return Ptr{NTuple{128, Cchar}}(x + 1184)
    f === :virtual_vendor_version && return Ptr{NTuple{128, Cchar}}(x + 1312)
    f === :mhz && return Ptr{Cfloat}(x + 1440)
    f === :clock_mhz && return Ptr{Cint}(x + 1444)
    f === :reserved && return Ptr{NTuple{8, Cint}}(x + 1448)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_hw_info, f::Symbol)
    r = Ref{_papi_hw_info}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_hw_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_hw_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_hw_info_t = _papi_hw_info

struct _papi_attach_option
    data::NTuple{16, UInt8}
end

function Base.getproperty(x::Ptr{_papi_attach_option}, f::Symbol)
    f === :eventset && return Ptr{Cint}(x + 0)
    f === :tid && return Ptr{Culong}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_attach_option, f::Symbol)
    r = Ref{_papi_attach_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_attach_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_attach_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_attach_option_t = _papi_attach_option

struct _papi_cpu_option
    data::NTuple{8, UInt8}
end

function Base.getproperty(x::Ptr{_papi_cpu_option}, f::Symbol)
    f === :eventset && return Ptr{Cint}(x + 0)
    f === :cpu_num && return Ptr{Cuint}(x + 4)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_cpu_option, f::Symbol)
    r = Ref{_papi_cpu_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_cpu_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_cpu_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_cpu_option_t = _papi_cpu_option

struct _papi_multiplex_option
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{_papi_multiplex_option}, f::Symbol)
    f === :eventset && return Ptr{Cint}(x + 0)
    f === :ns && return Ptr{Cint}(x + 4)
    f === :flags && return Ptr{Cint}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_multiplex_option, f::Symbol)
    r = Ref{_papi_multiplex_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_multiplex_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_multiplex_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_multiplex_option_t = _papi_multiplex_option

struct _papi_addr_range_option
    data::NTuple{32, UInt8}
end

function Base.getproperty(x::Ptr{_papi_addr_range_option}, f::Symbol)
    f === :eventset && return Ptr{Cint}(x + 0)
    f === :start && return Ptr{vptr_t}(x + 8)
    f === :_end && return Ptr{vptr_t}(x + 16)
    f === :start_off && return Ptr{Cint}(x + 24)
    f === :end_off && return Ptr{Cint}(x + 28)
    return getfield(x, f)
end

function Base.getproperty(x::_papi_addr_range_option, f::Symbol)
    r = Ref{_papi_addr_range_option}(x)
    ptr = Base.unsafe_convert(Ptr{_papi_addr_range_option}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_papi_addr_range_option}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_addr_range_option_t = _papi_addr_range_option

struct PAPI_option_t
    data::NTuple{264, UInt8}
end

function Base.getproperty(x::Ptr{PAPI_option_t}, f::Symbol)
    f === :preload && return Ptr{PAPI_preload_info_t}(x + 0)
    f === :debug && return Ptr{PAPI_debug_option_t}(x + 0)
    f === :inherit && return Ptr{PAPI_inherit_option_t}(x + 0)
    f === :granularity && return Ptr{PAPI_granularity_option_t}(x + 0)
    f === :defgranularity && return Ptr{PAPI_granularity_option_t}(x + 0)
    f === :domain && return Ptr{PAPI_domain_option_t}(x + 0)
    f === :defdomain && return Ptr{PAPI_domain_option_t}(x + 0)
    f === :attach && return Ptr{PAPI_attach_option_t}(x + 0)
    f === :cpu && return Ptr{PAPI_cpu_option_t}(x + 0)
    f === :multiplex && return Ptr{PAPI_multiplex_option_t}(x + 0)
    f === :itimer && return Ptr{PAPI_itimer_option_t}(x + 0)
    f === :hw_info && return Ptr{Ptr{PAPI_hw_info_t}}(x + 0)
    f === :shlib_info && return Ptr{Ptr{PAPI_shlib_info_t}}(x + 0)
    f === :exe_info && return Ptr{Ptr{PAPI_exe_info_t}}(x + 0)
    f === :cmp_info && return Ptr{Ptr{PAPI_component_info_t}}(x + 0)
    f === :addr && return Ptr{PAPI_addr_range_option_t}(x + 0)
    f === :events_file && return Ptr{PAPI_user_defined_events_file_t}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::PAPI_option_t, f::Symbol)
    r = Ref{PAPI_option_t}(x)
    ptr = Base.unsafe_convert(Ptr{PAPI_option_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{PAPI_option_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct _dmem_t
    data::NTuple{96, UInt8}
end

function Base.getproperty(x::Ptr{_dmem_t}, f::Symbol)
    f === :peak && return Ptr{Clonglong}(x + 0)
    f === :size && return Ptr{Clonglong}(x + 8)
    f === :resident && return Ptr{Clonglong}(x + 16)
    f === :high_water_mark && return Ptr{Clonglong}(x + 24)
    f === :shared && return Ptr{Clonglong}(x + 32)
    f === :text && return Ptr{Clonglong}(x + 40)
    f === :library && return Ptr{Clonglong}(x + 48)
    f === :heap && return Ptr{Clonglong}(x + 56)
    f === :locked && return Ptr{Clonglong}(x + 64)
    f === :stack && return Ptr{Clonglong}(x + 72)
    f === :pagesize && return Ptr{Clonglong}(x + 80)
    f === :pte && return Ptr{Clonglong}(x + 88)
    return getfield(x, f)
end

function Base.getproperty(x::_dmem_t, f::Symbol)
    r = Ref{_dmem_t}(x)
    ptr = Base.unsafe_convert(Ptr{_dmem_t}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_dmem_t}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_dmem_info_t = _dmem_t

const var"##Ctag#318" = UInt32
const PAPI_LOCATION_CORE = 0 % UInt32
const PAPI_LOCATION_CPU = 1 % UInt32
const PAPI_LOCATION_PACKAGE = 2 % UInt32
const PAPI_LOCATION_UNCORE = 3 % UInt32

const var"##Ctag#319" = UInt32
const PAPI_DATATYPE_INT64 = 0 % UInt32
const PAPI_DATATYPE_UINT64 = 1 % UInt32
const PAPI_DATATYPE_FP64 = 2 % UInt32
const PAPI_DATATYPE_BIT64 = 3 % UInt32

const var"##Ctag#320" = UInt32
const PAPI_VALUETYPE_RUNNING_SUM = 0 % UInt32
const PAPI_VALUETYPE_ABSOLUTE = 1 % UInt32

const var"##Ctag#321" = UInt32
const PAPI_TIMESCOPE_SINCE_START = 0 % UInt32
const PAPI_TIMESCOPE_SINCE_LAST = 1 % UInt32
const PAPI_TIMESCOPE_UNTIL_NEXT = 2 % UInt32
const PAPI_TIMESCOPE_POINT = 3 % UInt32

const var"##Ctag#322" = UInt32
const PAPI_UPDATETYPE_ARBITRARY = 0 % UInt32
const PAPI_UPDATETYPE_PUSH = 1 % UInt32
const PAPI_UPDATETYPE_PULL = 2 % UInt32
const PAPI_UPDATETYPE_FIXEDFREQ = 3 % UInt32

struct event_info
    data::NTuple{6680, UInt8}
end

function Base.getproperty(x::Ptr{event_info}, f::Symbol)
    f === :event_code && return Ptr{Cuint}(x + 0)
    f === :symbol && return Ptr{NTuple{1024, Cchar}}(x + 4)
    f === :short_descr && return Ptr{NTuple{64, Cchar}}(x + 1028)
    f === :long_descr && return Ptr{NTuple{1024, Cchar}}(x + 1092)
    f === :component_index && return Ptr{Cint}(x + 2116)
    f === :units && return Ptr{NTuple{64, Cchar}}(x + 2120)
    f === :location && return Ptr{Cint}(x + 2184)
    f === :data_type && return Ptr{Cint}(x + 2188)
    f === :value_type && return Ptr{Cint}(x + 2192)
    f === :timescope && return Ptr{Cint}(x + 2196)
    f === :update_type && return Ptr{Cint}(x + 2200)
    f === :update_freq && return Ptr{Cint}(x + 2204)
    f === :count && return Ptr{Cuint}(x + 2208)
    f === :event_type && return Ptr{Cuint}(x + 2212)
    f === :derived && return Ptr{NTuple{64, Cchar}}(x + 2216)
    f === :postfix && return Ptr{NTuple{256, Cchar}}(x + 2280)
    f === :code && return Ptr{NTuple{12, Cuint}}(x + 2536)
    f === :name && return Ptr{NTuple{12, NTuple{256, Cchar}}}(x + 2584)
    f === :note && return Ptr{NTuple{1024, Cchar}}(x + 5656)
    return getfield(x, f)
end

function Base.getproperty(x::event_info, f::Symbol)
    r = Ref{event_info}(x)
    ptr = Base.unsafe_convert(Ptr{event_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{event_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const PAPI_event_info_t = event_info

const PAPI_dev_type_id_e = UInt32
const PAPI_DEV_TYPE_ID__CPU = 0 % UInt32
const PAPI_DEV_TYPE_ID__CUDA = 1 % UInt32
const PAPI_DEV_TYPE_ID__ROCM = 2 % UInt32
const PAPI_DEV_TYPE_ID__MAX_NUM = 3 % UInt32

const var"##Ctag#324" = UInt32
const PAPI_DEV_TYPE_ENUM__FIRST = 0 % UInt32
const PAPI_DEV_TYPE_ENUM__CPU = 1 % UInt32
const PAPI_DEV_TYPE_ENUM__CUDA = 2 % UInt32
const PAPI_DEV_TYPE_ENUM__ROCM = 4 % UInt32
const PAPI_DEV_TYPE_ENUM__ALL = 7 % UInt32

const PAPI_dev_type_attr_e = UInt32
const PAPI_DEV_TYPE_ATTR__INT_PAPI_ID = 0 % UInt32
const PAPI_DEV_TYPE_ATTR__INT_VENDOR_ID = 1 % UInt32
const PAPI_DEV_TYPE_ATTR__CHAR_NAME = 2 % UInt32
const PAPI_DEV_TYPE_ATTR__INT_COUNT = 3 % UInt32
const PAPI_DEV_TYPE_ATTR__CHAR_STATUS = 4 % UInt32

const PAPI_dev_attr_e = UInt32
const PAPI_DEV_ATTR__CPU_CHAR_NAME = 0 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1I_CACHE_SIZE = 1 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1D_CACHE_SIZE = 2 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L2U_CACHE_SIZE = 3 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L3U_CACHE_SIZE = 4 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1I_CACHE_LINE_SIZE = 5 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1D_CACHE_LINE_SIZE = 6 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L2U_CACHE_LINE_SIZE = 7 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L3U_CACHE_LINE_SIZE = 8 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1I_CACHE_LINE_COUNT = 9 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1D_CACHE_LINE_COUNT = 10 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L2U_CACHE_LINE_COUNT = 11 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L3U_CACHE_LINE_COUNT = 12 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1I_CACHE_ASSOC = 13 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L1D_CACHE_ASSOC = 14 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L2U_CACHE_ASSOC = 15 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_L3U_CACHE_ASSOC = 16 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_SOCKET_COUNT = 17 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_NUMA_COUNT = 18 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_CORE_COUNT = 19 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_THREAD_COUNT = 20 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_FAMILY = 21 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_MODEL = 22 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_STEPPING = 23 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_NUMA_MEM_SIZE = 24 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_THR_NUMA_AFFINITY = 25 % UInt32
const PAPI_DEV_ATTR__CPU_UINT_THR_PER_NUMA = 26 % UInt32
const PAPI_DEV_ATTR__CUDA_ULONG_UID = 27 % UInt32
const PAPI_DEV_ATTR__CUDA_CHAR_DEVICE_NAME = 28 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_WARP_SIZE = 29 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_SHM_PER_BLK = 30 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_SHM_PER_SM = 31 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_BLK_DIM_X = 32 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_BLK_DIM_Y = 33 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_BLK_DIM_Z = 34 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_GRD_DIM_X = 35 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_GRD_DIM_Y = 36 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_GRD_DIM_Z = 37 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_THR_PER_BLK = 38 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_SM_COUNT = 39 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_MULTI_KERNEL = 40 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_MAP_HOST_MEM = 41 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_MEMCPY_OVERLAP = 42 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_UNIFIED_ADDR = 43 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_MANAGED_MEM = 44 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_COMP_CAP_MAJOR = 45 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_COMP_CAP_MINOR = 46 % UInt32
const PAPI_DEV_ATTR__CUDA_UINT_BLK_PER_SM = 47 % UInt32
const PAPI_DEV_ATTR__ROCM_ULONG_UID = 48 % UInt32
const PAPI_DEV_ATTR__ROCM_CHAR_DEVICE_NAME = 49 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_WAVEFRONT_SIZE = 50 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_WORKGROUP_SIZE = 51 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_WAVE_PER_CU = 52 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_SHM_PER_WG = 53 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_WG_DIM_X = 54 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_WG_DIM_Y = 55 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_WG_DIM_Z = 56 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_GRD_DIM_X = 57 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_GRD_DIM_Y = 58 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_GRD_DIM_Z = 59 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_CU_COUNT = 60 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_SIMD_PER_CU = 61 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_COMP_CAP_MAJOR = 62 % UInt32
const PAPI_DEV_ATTR__ROCM_UINT_COMP_CAP_MINOR = 63 % UInt32

function PAPI_accum(EventSet, values)
    ccall((:PAPI_accum, libpapi), Cint, (Cint, Ptr{Clonglong}), EventSet, values)
end

function PAPI_add_event(EventSet, Event)
    ccall((:PAPI_add_event, libpapi), Cint, (Cint, Cint), EventSet, Event)
end

function PAPI_add_named_event(EventSet, EventName)
    ccall((:PAPI_add_named_event, libpapi), Cint, (Cint, Ptr{Cchar}), EventSet, EventName)
end

function PAPI_add_events(EventSet, Events, number)
    ccall((:PAPI_add_events, libpapi), Cint, (Cint, Ptr{Cint}, Cint), EventSet, Events, number)
end

function PAPI_assign_eventset_component(EventSet, cidx)
    ccall((:PAPI_assign_eventset_component, libpapi), Cint, (Cint, Cint), EventSet, cidx)
end

function PAPI_attach(EventSet, tid)
    ccall((:PAPI_attach, libpapi), Cint, (Cint, Culong), EventSet, tid)
end

function PAPI_cleanup_eventset(EventSet)
    ccall((:PAPI_cleanup_eventset, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_create_eventset(EventSet)
    ccall((:PAPI_create_eventset, libpapi), Cint, (Ptr{Cint},), EventSet)
end

function PAPI_detach(EventSet)
    ccall((:PAPI_detach, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_destroy_eventset(EventSet)
    ccall((:PAPI_destroy_eventset, libpapi), Cint, (Ptr{Cint},), EventSet)
end

function PAPI_enum_event(EventCode, modifier)
    ccall((:PAPI_enum_event, libpapi), Cint, (Ptr{Cint}, Cint), EventCode, modifier)
end

function PAPI_enum_cmp_event(EventCode, modifier, cidx)
    ccall((:PAPI_enum_cmp_event, libpapi), Cint, (Ptr{Cint}, Cint, Cint), EventCode, modifier, cidx)
end

function PAPI_event_code_to_name(EventCode, out)
    ccall((:PAPI_event_code_to_name, libpapi), Cint, (Cint, Ptr{Cchar}), EventCode, out)
end

function PAPI_event_name_to_code(in, out)
    ccall((:PAPI_event_name_to_code, libpapi), Cint, (Ptr{Cchar}, Ptr{Cint}), in, out)
end

function PAPI_get_dmem_info(dest)
    ccall((:PAPI_get_dmem_info, libpapi), Cint, (Ptr{PAPI_dmem_info_t},), dest)
end

function PAPI_get_event_info(EventCode, info)
    ccall((:PAPI_get_event_info, libpapi), Cint, (Cint, Ptr{PAPI_event_info_t}), EventCode, info)
end

function PAPI_get_executable_info()
    ccall((:PAPI_get_executable_info, libpapi), Ptr{PAPI_exe_info_t}, ())
end

function PAPI_get_hardware_info()
    ccall((:PAPI_get_hardware_info, libpapi), Ptr{PAPI_hw_info_t}, ())
end

function PAPI_get_component_info(cidx)
    ccall((:PAPI_get_component_info, libpapi), Ptr{PAPI_component_info_t}, (Cint,), cidx)
end

function PAPI_get_multiplex(EventSet)
    ccall((:PAPI_get_multiplex, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_get_opt(option, ptr)
    ccall((:PAPI_get_opt, libpapi), Cint, (Cint, Ptr{PAPI_option_t}), option, ptr)
end

function PAPI_get_cmp_opt(option, ptr, cidx)
    ccall((:PAPI_get_cmp_opt, libpapi), Cint, (Cint, Ptr{PAPI_option_t}, Cint), option, ptr, cidx)
end

function PAPI_get_real_cyc()
    ccall((:PAPI_get_real_cyc, libpapi), Clonglong, ())
end

function PAPI_get_real_nsec()
    ccall((:PAPI_get_real_nsec, libpapi), Clonglong, ())
end

function PAPI_get_real_usec()
    ccall((:PAPI_get_real_usec, libpapi), Clonglong, ())
end

function PAPI_get_shared_lib_info()
    ccall((:PAPI_get_shared_lib_info, libpapi), Ptr{PAPI_shlib_info_t}, ())
end

function PAPI_get_thr_specific(tag, ptr)
    ccall((:PAPI_get_thr_specific, libpapi), Cint, (Cint, Ptr{Ptr{Cvoid}}), tag, ptr)
end

function PAPI_get_overflow_event_index(Eventset, overflow_vector, array, number)
    ccall((:PAPI_get_overflow_event_index, libpapi), Cint, (Cint, Clonglong, Ptr{Cint}, Ptr{Cint}), Eventset, overflow_vector, array, number)
end

function PAPI_get_virt_cyc()
    ccall((:PAPI_get_virt_cyc, libpapi), Clonglong, ())
end

function PAPI_get_virt_nsec()
    ccall((:PAPI_get_virt_nsec, libpapi), Clonglong, ())
end

function PAPI_get_virt_usec()
    ccall((:PAPI_get_virt_usec, libpapi), Clonglong, ())
end

function PAPI_is_initialized()
    ccall((:PAPI_is_initialized, libpapi), Cint, ())
end

function PAPI_library_init(version)
    ccall((:PAPI_library_init, libpapi), Cint, (Cint,), version)
end

function PAPI_list_events(EventSet, Events, number)
    ccall((:PAPI_list_events, libpapi), Cint, (Cint, Ptr{Cint}, Ptr{Cint}), EventSet, Events, number)
end

function PAPI_list_threads(tids, number)
    ccall((:PAPI_list_threads, libpapi), Cint, (Ptr{Culong}, Ptr{Cint}), tids, number)
end

function PAPI_lock(arg1)
    ccall((:PAPI_lock, libpapi), Cint, (Cint,), arg1)
end

function PAPI_multiplex_init()
    ccall((:PAPI_multiplex_init, libpapi), Cint, ())
end

function PAPI_num_cmp_hwctrs(cidx)
    ccall((:PAPI_num_cmp_hwctrs, libpapi), Cint, (Cint,), cidx)
end

function PAPI_num_events(EventSet)
    ccall((:PAPI_num_events, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_overflow(EventSet, EventCode, threshold, flags, handler)
    ccall((:PAPI_overflow, libpapi), Cint, (Cint, Cint, Cint, Cint, PAPI_overflow_handler_t), EventSet, EventCode, threshold, flags, handler)
end

function PAPI_perror(msg)
    ccall((:PAPI_perror, libpapi), Cvoid, (Ptr{Cchar},), msg)
end

function PAPI_profil(buf, bufsiz, offset, scale, EventSet, EventCode, threshold, flags)
    ccall((:PAPI_profil, libpapi), Cint, (Ptr{Cvoid}, Cuint, vptr_t, Cuint, Cint, Cint, Cint, Cint), buf, bufsiz, offset, scale, EventSet, EventCode, threshold, flags)
end

function PAPI_query_event(EventCode)
    ccall((:PAPI_query_event, libpapi), Cint, (Cint,), EventCode)
end

function PAPI_query_named_event(EventName)
    ccall((:PAPI_query_named_event, libpapi), Cint, (Ptr{Cchar},), EventName)
end

function PAPI_read(EventSet, values)
    ccall((:PAPI_read, libpapi), Cint, (Cint, Ptr{Clonglong}), EventSet, values)
end

function PAPI_read_ts(EventSet, values, cyc)
    ccall((:PAPI_read_ts, libpapi), Cint, (Cint, Ptr{Clonglong}, Ptr{Clonglong}), EventSet, values, cyc)
end

function PAPI_register_thread()
    ccall((:PAPI_register_thread, libpapi), Cint, ())
end

function PAPI_remove_event(EventSet, EventCode)
    ccall((:PAPI_remove_event, libpapi), Cint, (Cint, Cint), EventSet, EventCode)
end

function PAPI_remove_named_event(EventSet, EventName)
    ccall((:PAPI_remove_named_event, libpapi), Cint, (Cint, Ptr{Cchar}), EventSet, EventName)
end

function PAPI_remove_events(EventSet, Events, number)
    ccall((:PAPI_remove_events, libpapi), Cint, (Cint, Ptr{Cint}, Cint), EventSet, Events, number)
end

function PAPI_reset(EventSet)
    ccall((:PAPI_reset, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_set_debug(level)
    ccall((:PAPI_set_debug, libpapi), Cint, (Cint,), level)
end

function PAPI_set_cmp_domain(domain, cidx)
    ccall((:PAPI_set_cmp_domain, libpapi), Cint, (Cint, Cint), domain, cidx)
end

function PAPI_set_domain(domain)
    ccall((:PAPI_set_domain, libpapi), Cint, (Cint,), domain)
end

function PAPI_set_cmp_granularity(granularity, cidx)
    ccall((:PAPI_set_cmp_granularity, libpapi), Cint, (Cint, Cint), granularity, cidx)
end

function PAPI_set_granularity(granularity)
    ccall((:PAPI_set_granularity, libpapi), Cint, (Cint,), granularity)
end

function PAPI_set_multiplex(EventSet)
    ccall((:PAPI_set_multiplex, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_set_opt(option, ptr)
    ccall((:PAPI_set_opt, libpapi), Cint, (Cint, Ptr{PAPI_option_t}), option, ptr)
end

function PAPI_set_thr_specific(tag, ptr)
    ccall((:PAPI_set_thr_specific, libpapi), Cint, (Cint, Ptr{Cvoid}), tag, ptr)
end

function PAPI_shutdown()
    ccall((:PAPI_shutdown, libpapi), Cvoid, ())
end

function PAPI_sprofil(prof, profcnt, EventSet, EventCode, threshold, flags)
    ccall((:PAPI_sprofil, libpapi), Cint, (Ptr{PAPI_sprofil_t}, Cint, Cint, Cint, Cint, Cint), prof, profcnt, EventSet, EventCode, threshold, flags)
end

function PAPI_start(EventSet)
    ccall((:PAPI_start, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_state(EventSet, status)
    ccall((:PAPI_state, libpapi), Cint, (Cint, Ptr{Cint}), EventSet, status)
end

function PAPI_stop(EventSet, values)
    ccall((:PAPI_stop, libpapi), Cint, (Cint, Ptr{Clonglong}), EventSet, values)
end

function PAPI_thread_id()
    ccall((:PAPI_thread_id, libpapi), Culong, ())
end

function PAPI_thread_init(id_fn)
    ccall((:PAPI_thread_init, libpapi), Cint, (Ptr{Cvoid},), id_fn)
end

function PAPI_unlock(arg1)
    ccall((:PAPI_unlock, libpapi), Cint, (Cint,), arg1)
end

function PAPI_unregister_thread()
    ccall((:PAPI_unregister_thread, libpapi), Cint, ())
end

function PAPI_write(EventSet, values)
    ccall((:PAPI_write, libpapi), Cint, (Cint, Ptr{Clonglong}), EventSet, values)
end

function PAPI_get_eventset_component(EventSet)
    ccall((:PAPI_get_eventset_component, libpapi), Cint, (Cint,), EventSet)
end

function PAPI_get_component_index(name)
    ccall((:PAPI_get_component_index, libpapi), Cint, (Ptr{Cchar},), name)
end

function PAPI_disable_component(cidx)
    ccall((:PAPI_disable_component, libpapi), Cint, (Cint,), cidx)
end

function PAPI_disable_component_by_name(name)
    ccall((:PAPI_disable_component_by_name, libpapi), Cint, (Ptr{Cchar},), name)
end

function PAPI_num_components()
    ccall((:PAPI_num_components, libpapi), Cint, ())
end

function PAPI_flips_rate(event, rtime, ptime, flpins, mflips)
    ccall((:PAPI_flips_rate, libpapi), Cint, (Cint, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Clonglong}, Ptr{Cfloat}), event, rtime, ptime, flpins, mflips)
end

function PAPI_flops_rate(event, rtime, ptime, flpops, mflops)
    ccall((:PAPI_flops_rate, libpapi), Cint, (Cint, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Clonglong}, Ptr{Cfloat}), event, rtime, ptime, flpops, mflops)
end

function PAPI_ipc(rtime, ptime, ins, ipc)
    ccall((:PAPI_ipc, libpapi), Cint, (Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Clonglong}, Ptr{Cfloat}), rtime, ptime, ins, ipc)
end

function PAPI_epc(event, rtime, ptime, ref, core, evt, epc)
    ccall((:PAPI_epc, libpapi), Cint, (Cint, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Clonglong}, Ptr{Clonglong}, Ptr{Clonglong}, Ptr{Cfloat}), event, rtime, ptime, ref, core, evt, epc)
end

# no prototype is found for this function at papi.h:1224:8, please use with caution
function PAPI_rate_stop()
    ccall((:PAPI_rate_stop, libpapi), Cint, ())
end

function PAPI_enum_dev_type(enum_modifier, handle)
    ccall((:PAPI_enum_dev_type, libpapi), Cint, (Cint, Ptr{Ptr{Cvoid}}), enum_modifier, handle)
end

function PAPI_get_dev_type_attr(handle, attr, value)
    ccall((:PAPI_get_dev_type_attr, libpapi), Cint, (Ptr{Cvoid}, PAPI_dev_type_attr_e, Ptr{Cvoid}), handle, attr, value)
end

function PAPI_get_dev_attr(handle, id, attr, value)
    ccall((:PAPI_get_dev_attr, libpapi), Cint, (Ptr{Cvoid}, Cint, PAPI_dev_attr_e, Ptr{Cvoid}), handle, id, attr, value)
end

function PAPI_hl_region_begin(region)
    ccall((:PAPI_hl_region_begin, libpapi), Cint, (Ptr{Cchar},), region)
end

function PAPI_hl_read(region)
    ccall((:PAPI_hl_read, libpapi), Cint, (Ptr{Cchar},), region)
end

function PAPI_hl_region_end(region)
    ccall((:PAPI_hl_region_end, libpapi), Cint, (Ptr{Cchar},), region)
end

# no prototype is found for this function at papi.h:1241:8, please use with caution
function PAPI_hl_stop()
    ccall((:PAPI_hl_stop, libpapi), Cint, ())
end

function PAPI_num_hwctrs()
    ccall((:PAPI_num_hwctrs, libpapi), Cint, ())
end

const PAPI_VERSION = PAPI_VERSION_NUMBER(7, 0, 0, 0)

const PAPI_VER_CURRENT = PAPI_VERSION & 0xffff0000

const PAPI_NATIVE_MASK = 0x40000000

const PAPI_PRESET_MASK = 0x80000000

const PAPI_UE_MASK = 0xc0000000

const PAPI_PRESET_AND_MASK = 0x7fffffff

const PAPI_NATIVE_AND_MASK = 0xbfffffff

const PAPI_UE_AND_MASK = 0x3fffffff

const PAPI_MAX_PRESET_EVENTS = 128

const PAPI_MAX_USER_EVENTS = 50

const USER_EVENT_OPERATION_LEN = 512

const PAPI_L1_DCM = PAPI_L1_DCM_idx | PAPI_PRESET_MASK

const PAPI_L1_ICM = PAPI_L1_ICM_idx | PAPI_PRESET_MASK

const PAPI_L2_DCM = PAPI_L2_DCM_idx | PAPI_PRESET_MASK

const PAPI_L2_ICM = PAPI_L2_ICM_idx | PAPI_PRESET_MASK

const PAPI_L3_DCM = PAPI_L3_DCM_idx | PAPI_PRESET_MASK

const PAPI_L3_ICM = PAPI_L3_ICM_idx | PAPI_PRESET_MASK

const PAPI_L1_TCM = PAPI_L1_TCM_idx | PAPI_PRESET_MASK

const PAPI_L2_TCM = PAPI_L2_TCM_idx | PAPI_PRESET_MASK

const PAPI_L3_TCM = PAPI_L3_TCM_idx | PAPI_PRESET_MASK

const PAPI_CA_SNP = PAPI_CA_SNP_idx | PAPI_PRESET_MASK

const PAPI_CA_SHR = PAPI_CA_SHR_idx | PAPI_PRESET_MASK

const PAPI_CA_CLN = PAPI_CA_CLN_idx | PAPI_PRESET_MASK

const PAPI_CA_INV = PAPI_CA_INV_idx | PAPI_PRESET_MASK

const PAPI_CA_ITV = PAPI_CA_ITV_idx | PAPI_PRESET_MASK

const PAPI_L3_LDM = PAPI_L3_LDM_idx | PAPI_PRESET_MASK

const PAPI_L3_STM = PAPI_L3_STM_idx | PAPI_PRESET_MASK

const PAPI_BRU_IDL = PAPI_BRU_IDL_idx | PAPI_PRESET_MASK

const PAPI_FXU_IDL = PAPI_FXU_IDL_idx | PAPI_PRESET_MASK

const PAPI_FPU_IDL = PAPI_FPU_IDL_idx | PAPI_PRESET_MASK

const PAPI_LSU_IDL = PAPI_LSU_IDL_idx | PAPI_PRESET_MASK

const PAPI_TLB_DM = PAPI_TLB_DM_idx | PAPI_PRESET_MASK

const PAPI_TLB_IM = PAPI_TLB_IM_idx | PAPI_PRESET_MASK

const PAPI_TLB_TL = PAPI_TLB_TL_idx | PAPI_PRESET_MASK

const PAPI_L1_LDM = PAPI_L1_LDM_idx | PAPI_PRESET_MASK

const PAPI_L1_STM = PAPI_L1_STM_idx | PAPI_PRESET_MASK

const PAPI_L2_LDM = PAPI_L2_LDM_idx | PAPI_PRESET_MASK

const PAPI_L2_STM = PAPI_L2_STM_idx | PAPI_PRESET_MASK

const PAPI_BTAC_M = PAPI_BTAC_M_idx | PAPI_PRESET_MASK

const PAPI_PRF_DM = PAPI_PRF_DM_idx | PAPI_PRESET_MASK

const PAPI_L3_DCH = PAPI_L3_DCH_idx | PAPI_PRESET_MASK

const PAPI_TLB_SD = PAPI_TLB_SD_idx | PAPI_PRESET_MASK

const PAPI_CSR_FAL = PAPI_CSR_FAL_idx | PAPI_PRESET_MASK

const PAPI_CSR_SUC = PAPI_CSR_SUC_idx | PAPI_PRESET_MASK

const PAPI_CSR_TOT = PAPI_CSR_TOT_idx | PAPI_PRESET_MASK

const PAPI_MEM_SCY = PAPI_MEM_SCY_idx | PAPI_PRESET_MASK

const PAPI_MEM_RCY = PAPI_MEM_RCY_idx | PAPI_PRESET_MASK

const PAPI_MEM_WCY = PAPI_MEM_WCY_idx | PAPI_PRESET_MASK

const PAPI_STL_ICY = PAPI_STL_ICY_idx | PAPI_PRESET_MASK

const PAPI_FUL_ICY = PAPI_FUL_ICY_idx | PAPI_PRESET_MASK

const PAPI_STL_CCY = PAPI_STL_CCY_idx | PAPI_PRESET_MASK

const PAPI_FUL_CCY = PAPI_FUL_CCY_idx | PAPI_PRESET_MASK

const PAPI_HW_INT = PAPI_HW_INT_idx | PAPI_PRESET_MASK

const PAPI_BR_UCN = PAPI_BR_UCN_idx | PAPI_PRESET_MASK

const PAPI_BR_CN = PAPI_BR_CN_idx | PAPI_PRESET_MASK

const PAPI_BR_TKN = PAPI_BR_TKN_idx | PAPI_PRESET_MASK

const PAPI_BR_NTK = PAPI_BR_NTK_idx | PAPI_PRESET_MASK

const PAPI_BR_MSP = PAPI_BR_MSP_idx | PAPI_PRESET_MASK

const PAPI_BR_PRC = PAPI_BR_PRC_idx | PAPI_PRESET_MASK

const PAPI_FMA_INS = PAPI_FMA_INS_idx | PAPI_PRESET_MASK

const PAPI_TOT_IIS = PAPI_TOT_IIS_idx | PAPI_PRESET_MASK

const PAPI_TOT_INS = PAPI_TOT_INS_idx | PAPI_PRESET_MASK

const PAPI_INT_INS = PAPI_INT_INS_idx | PAPI_PRESET_MASK

const PAPI_FP_INS = PAPI_FP_INS_idx | PAPI_PRESET_MASK

const PAPI_LD_INS = PAPI_LD_INS_idx | PAPI_PRESET_MASK

const PAPI_SR_INS = PAPI_SR_INS_idx | PAPI_PRESET_MASK

const PAPI_BR_INS = PAPI_BR_INS_idx | PAPI_PRESET_MASK

const PAPI_VEC_INS = PAPI_VEC_INS_idx | PAPI_PRESET_MASK

const PAPI_RES_STL = PAPI_RES_STL_idx | PAPI_PRESET_MASK

const PAPI_FP_STAL = PAPI_FP_STAL_idx | PAPI_PRESET_MASK

const PAPI_TOT_CYC = PAPI_TOT_CYC_idx | PAPI_PRESET_MASK

const PAPI_LST_INS = PAPI_LST_INS_idx | PAPI_PRESET_MASK

const PAPI_SYC_INS = PAPI_SYC_INS_idx | PAPI_PRESET_MASK

const PAPI_L1_DCH = PAPI_L1_DCH_idx | PAPI_PRESET_MASK

const PAPI_L2_DCH = PAPI_L2_DCH_idx | PAPI_PRESET_MASK

const PAPI_L1_DCA = PAPI_L1_DCA_idx | PAPI_PRESET_MASK

const PAPI_L2_DCA = PAPI_L2_DCA_idx | PAPI_PRESET_MASK

const PAPI_L3_DCA = PAPI_L3_DCA_idx | PAPI_PRESET_MASK

const PAPI_L1_DCR = PAPI_L1_DCR_idx | PAPI_PRESET_MASK

const PAPI_L2_DCR = PAPI_L2_DCR_idx | PAPI_PRESET_MASK

const PAPI_L3_DCR = PAPI_L3_DCR_idx | PAPI_PRESET_MASK

const PAPI_L1_DCW = PAPI_L1_DCW_idx | PAPI_PRESET_MASK

const PAPI_L2_DCW = PAPI_L2_DCW_idx | PAPI_PRESET_MASK

const PAPI_L3_DCW = PAPI_L3_DCW_idx | PAPI_PRESET_MASK

const PAPI_L1_ICH = PAPI_L1_ICH_idx | PAPI_PRESET_MASK

const PAPI_L2_ICH = PAPI_L2_ICH_idx | PAPI_PRESET_MASK

const PAPI_L3_ICH = PAPI_L3_ICH_idx | PAPI_PRESET_MASK

const PAPI_L1_ICA = PAPI_L1_ICA_idx | PAPI_PRESET_MASK

const PAPI_L2_ICA = PAPI_L2_ICA_idx | PAPI_PRESET_MASK

const PAPI_L3_ICA = PAPI_L3_ICA_idx | PAPI_PRESET_MASK

const PAPI_L1_ICR = PAPI_L1_ICR_idx | PAPI_PRESET_MASK

const PAPI_L2_ICR = PAPI_L2_ICR_idx | PAPI_PRESET_MASK

const PAPI_L3_ICR = PAPI_L3_ICR_idx | PAPI_PRESET_MASK

const PAPI_L1_ICW = PAPI_L1_ICW_idx | PAPI_PRESET_MASK

const PAPI_L2_ICW = PAPI_L2_ICW_idx | PAPI_PRESET_MASK

const PAPI_L3_ICW = PAPI_L3_ICW_idx | PAPI_PRESET_MASK

const PAPI_L1_TCH = PAPI_L1_TCH_idx | PAPI_PRESET_MASK

const PAPI_L2_TCH = PAPI_L2_TCH_idx | PAPI_PRESET_MASK

const PAPI_L3_TCH = PAPI_L3_TCH_idx | PAPI_PRESET_MASK

const PAPI_L1_TCA = PAPI_L1_TCA_idx | PAPI_PRESET_MASK

const PAPI_L2_TCA = PAPI_L2_TCA_idx | PAPI_PRESET_MASK

const PAPI_L3_TCA = PAPI_L3_TCA_idx | PAPI_PRESET_MASK

const PAPI_L1_TCR = PAPI_L1_TCR_idx | PAPI_PRESET_MASK

const PAPI_L2_TCR = PAPI_L2_TCR_idx | PAPI_PRESET_MASK

const PAPI_L3_TCR = PAPI_L3_TCR_idx | PAPI_PRESET_MASK

const PAPI_L1_TCW = PAPI_L1_TCW_idx | PAPI_PRESET_MASK

const PAPI_L2_TCW = PAPI_L2_TCW_idx | PAPI_PRESET_MASK

const PAPI_L3_TCW = PAPI_L3_TCW_idx | PAPI_PRESET_MASK

const PAPI_FML_INS = PAPI_FML_INS_idx | PAPI_PRESET_MASK

const PAPI_FAD_INS = PAPI_FAD_INS_idx | PAPI_PRESET_MASK

const PAPI_FDV_INS = PAPI_FDV_INS_idx | PAPI_PRESET_MASK

const PAPI_FSQ_INS = PAPI_FSQ_INS_idx | PAPI_PRESET_MASK

const PAPI_FNV_INS = PAPI_FNV_INS_idx | PAPI_PRESET_MASK

const PAPI_FP_OPS = PAPI_FP_OPS_idx | PAPI_PRESET_MASK

const PAPI_SP_OPS = PAPI_SP_OPS_idx | PAPI_PRESET_MASK

const PAPI_DP_OPS = PAPI_DP_OPS_idx | PAPI_PRESET_MASK

const PAPI_VEC_SP = PAPI_VEC_SP_idx | PAPI_PRESET_MASK

const PAPI_VEC_DP = PAPI_VEC_DP_idx | PAPI_PRESET_MASK

const PAPI_REF_CYC = PAPI_REF_CYC_idx | PAPI_PRESET_MASK

const PAPI_END = PAPI_END_idx | PAPI_PRESET_MASK

const PAPI_OK = 0

const PAPI_EINVAL = -1

const PAPI_ENOMEM = -2

const PAPI_ESYS = -3

const PAPI_ECMP = -4

const PAPI_ESBSTR = -4

const PAPI_ECLOST = -5

const PAPI_EBUG = -6

const PAPI_ENOEVNT = -7

const PAPI_ECNFLCT = -8

const PAPI_ENOTRUN = -9

const PAPI_EISRUN = -10

const PAPI_ENOEVST = -11

const PAPI_ENOTPRESET = -12

const PAPI_ENOCNTR = -13

const PAPI_EMISC = -14

const PAPI_EPERM = -15

const PAPI_ENOINIT = -16

const PAPI_ENOCMP = -17

const PAPI_ENOSUPP = -18

const PAPI_ENOIMPL = -19

const PAPI_EBUF = -20

const PAPI_EINVAL_DOM = -21

const PAPI_EATTR = -22

const PAPI_ECOUNT = -23

const PAPI_ECOMBO = -24

const PAPI_ECMP_DISABLED = -25

const PAPI_EDELAY_INIT = -26

const PAPI_EMULPASS = -27

const PAPI_NUM_ERRORS = 28

const PAPI_NOT_INITED = 0

const PAPI_LOW_LEVEL_INITED = 1

const PAPI_HIGH_LEVEL_INITED = 2

const PAPI_THREAD_LEVEL_INITED = 4

const PAPI_NULL = -1

const PAPI_DOM_USER = 0x01

const PAPI_DOM_MIN = PAPI_DOM_USER

const PAPI_DOM_KERNEL = 0x02

const PAPI_DOM_OTHER = 0x04

const PAPI_DOM_SUPERVISOR = 0x08

const PAPI_DOM_ALL = ((PAPI_DOM_USER | PAPI_DOM_KERNEL) | PAPI_DOM_OTHER) | PAPI_DOM_SUPERVISOR

const PAPI_DOM_MAX = PAPI_DOM_ALL

const PAPI_DOM_HWSPEC = 0x80000000

const PAPI_USR1_TLS = 0x00

const PAPI_USR2_TLS = 0x01

const PAPI_TLS_HIGH_LEVEL = 0x02

const PAPI_NUM_TLS = 0x03

const PAPI_TLS_USR1 = PAPI_USR1_TLS

const PAPI_TLS_USR2 = PAPI_USR2_TLS

const PAPI_TLS_NUM = PAPI_NUM_TLS

const PAPI_TLS_ALL_THREADS = 0x10

const PAPI_USR1_LOCK = 0x00

const PAPI_USR2_LOCK = 0x01

const PAPI_NUM_LOCK = 0x02

const PAPI_LOCK_USR1 = PAPI_USR1_LOCK

const PAPI_LOCK_USR2 = PAPI_USR2_LOCK

const PAPI_LOCK_NUM = PAPI_NUM_LOCK

const PAPI_VENDOR_UNKNOWN = 0

const PAPI_VENDOR_INTEL = 1

const PAPI_VENDOR_AMD = 2

const PAPI_VENDOR_IBM = 3

const PAPI_VENDOR_CRAY = 4

const PAPI_VENDOR_SUN = 5

const PAPI_VENDOR_FREESCALE = 6

const PAPI_VENDOR_ARM = 7

const PAPI_VENDOR_MIPS = 8

const PAPI_VENDOR_ARM_ARM = 0x41

const PAPI_VENDOR_ARM_BROADCOM = 0x42

const PAPI_VENDOR_ARM_CAVIUM = 0x43

const PAPI_VENDOR_ARM_FUJITSU = 0x46

const PAPI_VENDOR_ARM_HISILICON = 0x48

const PAPI_VENDOR_ARM_APM = 0x50

const PAPI_VENDOR_ARM_QUALCOMM = 0x51

const PAPI_GRN_THR = 0x01

const PAPI_GRN_MIN = PAPI_GRN_THR

const PAPI_GRN_PROC = 0x02

const PAPI_GRN_PROCG = 0x04

const PAPI_GRN_SYS = 0x08

const PAPI_GRN_SYS_CPU = 0x10

const PAPI_GRN_MAX = PAPI_GRN_SYS_CPU

const PAPI_STOPPED = 0x01

const PAPI_RUNNING = 0x02

const PAPI_PAUSED = 0x04

const PAPI_NOT_INIT = 0x08

const PAPI_OVERFLOWING = 0x10

const PAPI_PROFILING = 0x20

const PAPI_MULTIPLEXING = 0x40

const PAPI_ATTACHED = 0x80

const PAPI_CPU_ATTACHED = 0x0100

const PAPI_QUIET = 0

const PAPI_VERB_ECONT = 1

const PAPI_VERB_ESTOP = 2

const PAPI_PROFIL_POSIX = 0x00

const PAPI_PROFIL_RANDOM = 0x01

const PAPI_PROFIL_WEIGHTED = 0x02

const PAPI_PROFIL_COMPRESS = 0x04

const PAPI_PROFIL_BUCKET_16 = 0x08

const PAPI_PROFIL_BUCKET_32 = 0x10

const PAPI_PROFIL_BUCKET_64 = 0x20

const PAPI_PROFIL_FORCE_SW = 0x40

const PAPI_PROFIL_DATA_EAR = 0x80

const PAPI_PROFIL_INST_EAR = 0x0100

const PAPI_PROFIL_BUCKETS = (PAPI_PROFIL_BUCKET_16 | PAPI_PROFIL_BUCKET_32) | PAPI_PROFIL_BUCKET_64

const PAPI_OVERFLOW_FORCE_SW = 0x40

const PAPI_OVERFLOW_HARDWARE = 0x80

const PAPI_MULTIPLEX_DEFAULT = 0x00

const PAPI_MULTIPLEX_FORCE_SW = 0x01

const PAPI_INHERIT_ALL = 1

const PAPI_INHERIT_NONE = 0

const PAPI_DETACH = 1

const PAPI_DEBUG = 2

const PAPI_MULTIPLEX = 3

const PAPI_DEFDOM = 4

const PAPI_DOMAIN = 5

const PAPI_DEFGRN = 6

const PAPI_GRANUL = 7

const PAPI_DEF_MPX_NS = 8

const PAPI_MAX_MPX_CTRS = 11

const PAPI_PROFIL = 12

const PAPI_PRELOAD = 13

const PAPI_CLOCKRATE = 14

const PAPI_MAX_HWCTRS = 15

const PAPI_HWINFO = 16

const PAPI_EXEINFO = 17

const PAPI_MAX_CPUS = 18

const PAPI_ATTACH = 19

const PAPI_SHLIBINFO = 20

const PAPI_LIB_VERSION = 21

const PAPI_COMPONENTINFO = 22

const PAPI_DATA_ADDRESS = 23

const PAPI_INSTR_ADDRESS = 24

const PAPI_DEF_ITIMER = 25

const PAPI_DEF_ITIMER_NS = 26

const PAPI_CPU_ATTACH = 27

const PAPI_INHERIT = 28

const PAPI_USER_EVENTS_FILE = 29

const PAPI_INIT_SLOTS = 64

const PAPI_MIN_STR_LEN = 64

const PAPI_MAX_STR_LEN = 128

const PAPI_2MAX_STR_LEN = 256

const PAPI_HUGE_STR_LEN = 1024

const PAPI_PMU_MAX = 80

const PAPI_DERIVED = 0x01

const PAPI_ENUM_ALL = PAPI_ENUM_EVENTS

const PAPI_PRESET_BIT_MSC = 1 << PAPI_PRESET_ENUM_MSC

const PAPI_PRESET_BIT_INS = 1 << PAPI_PRESET_ENUM_INS

const PAPI_PRESET_BIT_IDL = 1 << PAPI_PRESET_ENUM_IDL

const PAPI_PRESET_BIT_BR = 1 << PAPI_PRESET_ENUM_BR

const PAPI_PRESET_BIT_CND = 1 << PAPI_PRESET_ENUM_CND

const PAPI_PRESET_BIT_MEM = 1 << PAPI_PRESET_ENUM_MEM

const PAPI_PRESET_BIT_CACH = 1 << PAPI_PRESET_ENUM_CACH

const PAPI_PRESET_BIT_L1 = 1 << PAPI_PRESET_ENUM_L1

const PAPI_PRESET_BIT_L2 = 1 << PAPI_PRESET_ENUM_L2

const PAPI_PRESET_BIT_L3 = 1 << PAPI_PRESET_ENUM_L3

const PAPI_PRESET_BIT_TLB = 1 << PAPI_PRESET_ENUM_TLB

const PAPI_PRESET_BIT_FP = 1 << PAPI_PRESET_ENUM_FP

const PAPI_NTV_GROUP_AND_MASK = 0x00ff0000

const PAPI_NTV_GROUP_SHIFT = 16

const long_long = Clonglong

const u_long_long = Culonglong

const PAPI_MH_TYPE_EMPTY = 0x00

const PAPI_MH_TYPE_INST = 0x01

const PAPI_MH_TYPE_DATA = 0x02

const PAPI_MH_TYPE_VECTOR = 0x04

const PAPI_MH_TYPE_TRACE = 0x08

const PAPI_MH_TYPE_UNIFIED = PAPI_MH_TYPE_INST | PAPI_MH_TYPE_DATA

const PAPI_MH_TYPE_WT = 0x00

const PAPI_MH_TYPE_WB = 0x10

const PAPI_MH_TYPE_UNKNOWN = 0x0000

const PAPI_MH_TYPE_LRU = 0x0100

const PAPI_MH_TYPE_PSEUDO_LRU = 0x0200

const PAPI_MH_TYPE_FIFO = 0x0400

const PAPI_MH_TYPE_TLB = 0x1000

const PAPI_MH_TYPE_PREF = 0x2000

const PAPI_MH_TYPE_RD_ALLOC = 0x00010000

const PAPI_MH_TYPE_WR_ALLOC = 0x00020000

const PAPI_MH_TYPE_RW_ALLOC = 0x00040000

const PAPI_MH_MAX_LEVELS = 6

const PAPI_MAX_MEM_HIERARCHY_LEVELS = 4

const PAPIF_DMEM_VMPEAK = 1

const PAPIF_DMEM_VMSIZE = 2

const PAPIF_DMEM_RESIDENT = 3

const PAPIF_DMEM_HIGH_WATER = 4

const PAPIF_DMEM_SHARED = 5

const PAPIF_DMEM_TEXT = 6

const PAPIF_DMEM_LIBRARY = 7

const PAPIF_DMEM_HEAP = 8

const PAPIF_DMEM_LOCKED = 9

const PAPIF_DMEM_STACK = 10

const PAPIF_DMEM_PAGESIZE = 11

const PAPIF_DMEM_PTE = 12

const PAPIF_DMEM_MAXVAL = 12

const PAPI_MAX_INFO_TERMS = 12

end # module
