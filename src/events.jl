# adapted from papiStdEventDefs.h
@enum(Preset::Cuint,
    L1_DCM = PAPI_PRESET_MASK,  # Level 1 data cache misses
    L1_ICM,  # Level 1 instruction cache misses
    L2_DCM,  # Level 2 data cache misses
    L2_ICM,  # Level 2 instruction cache misses
    L3_DCM,  # Level 3 data cache misses
    L3_ICM,  # Level 3 instruction cache misses
    L1_TCM,  # Level 1 total cache misses
    L2_TCM,  # Level 2 total cache misses
    L3_TCM,  # Level 3 total cache misses
    CA_SNP,  # Snoops
    CA_SHR,  # Request for shared cache line (SMP)
    CA_CLN,  # Request for clean cache line (SMP)
    CA_INV,  # Request for cache line Invalidation (SMP)
    CA_ITV,  # Request for cache line Intervention (SMP)
    L3_LDM,  # Level 3 load misses
    L3_STM,  # Level 3 store misses
    BRU_IDL, # Cycles branch units are idle
    FXU_IDL, # Cycles integer units are idle
    FPU_IDL, # Cycles floating point units are idle
    LSU_IDL, # Cycles load/store units are idle
    TLB_DM,  # Data translation lookaside buffer misses
    TLB_IM,  # Instr translation lookaside buffer misses
    TLB_TL,  # Total translation lookaside buffer misses
    L1_LDM,  # Level 1 load misses
    L1_STM,  # Level 1 store misses
    L2_LDM,  # Level 2 load misses
    L2_STM,  # Level 2 store misses
    BTAC_M,  # BTAC miss
    PRF_DM,  # Prefetch data instruction caused a miss
    L3_DCH,  # Level 3 Data Cache Hit
    TLB_SD,  # Xlation lookaside buffer shootdowns (SMP)
    CSR_FAL, # Failed store conditional instructions
    CSR_SUC, # Successful store conditional instructions
    CSR_TOT, # Total store conditional instructions
    MEM_SCY, # Cycles Stalled Waiting for Memory Access
    MEM_RCY, # Cycles Stalled Waiting for Memory Read
    MEM_WCY, # Cycles Stalled Waiting for Memory Write
    STL_ICY, # Cycles with No Instruction Issue
    FUL_ICY, # Cycles with Maximum Instruction Issue
    STL_CCY, # Cycles with No Instruction Completion
    FUL_CCY, # Cycles with Maximum Instruction Completion
    HW_INT,  # Hardware interrupts
    BR_UCN,  # Unconditional branch instructions executed
    BR_CN,   # Conditional branch instructions executed
    BR_TKN,  # Conditional branch instructions taken
    BR_NTK,  # Conditional branch instructions not taken
    BR_MSP,  # Conditional branch instructions mispred
    BR_PRC,  # Conditional branch instructions corr. pred
    FMA_INS, # FMA instructions completed
    TOT_IIS, # Total instructions issued
    TOT_INS, # Total instructions executed
    INT_INS, # Integer instructions executed executed
    FP_INS,  # Floating point instructions executed
    LD_INS,  # Load instructions executed
    SR_INS,  # Store instructions executed
    BR_INS,  # Total branch instructions executed
    VEC_INS, # Vector/SIMD instructions executed (could include integer)
    RES_STL, # Cycles processor is stalled on resource
    FP_STAL, # Cycles any FP units are stalled
    TOT_CYC, # Total cycles executed
    LST_INS, # Total load/store inst. executed
    SYC_INS, # Sync. inst. executed
    L1_DCH,  # L1 D Cache Hit
    L2_DCH,  # L2 D Cache Hit
    L1_DCA,  # L1 D Cache Access
    L2_DCA,  # L2 D Cache Access
    L3_DCA,  # L3 D Cache Access
    L1_DCR,  # L1 D Cache Read
    L2_DCR,  # L2 D Cache Read
    L3_DCR,  # L3 D Cachee Read
    L1_DCW,  # L1 D Cache Write
    L2_DCW,  # L2 D Cache Write
    L3_DCW,  # L3 D Cache Write
    L1_ICH,  # L1 instruction cache hits
    L2_ICH,  # L2 instruction cache hits
    L3_ICH,  # L3 instruction cache hits
    L1_ICA,  # L1 instruction cache accesses
    L2_ICA,  # L2 instruction cache accesses
    L3_ICA,  # L3 instruction cache accesses
    L1_ICR,  # L1 instruction cache reads
    L2_ICR,  # L2 instruction cache reads
    L3_ICR,  # L3 instruction cache reads
    L1_ICW,  # L1 instruction cache writes
    L2_ICW,  # L2 instruction cache writes
    L3_ICW,  # L3 instruction cache writes
    L1_TCH,  # L1 total cache hits
    L2_TCH,  # L2 total cache hits
    L3_TCH,  # L3 total cache hits
    L1_TCA,  # L1 total cache accesses
    L2_TCA,  # L2 total cache accesses
    L3_TCA,  # L3 total cache accesses
    L1_TCR,  # L1 total cache reads
    L2_TCR,  # L2 total cache reads
    L3_TCR,  # L3 total cache reads
    L1_TCW,  # L1 total cachee writes
    L2_TCW,  # L2 total cache writes
    L3_TCW,  # L3 total cache writes
    FML_INS, # FM ins
    FAD_INS, # FA ins
    FDV_INS, # FD ins
    FSQ_INS, # FSq ins
    FNV_INS, # Finv ins
    FP_OPS,  # Floating point operations executed
    SP_OPS,  # Floating point operations executed; optimized to count scaled single precision vector operations
    DP_OPS,  # Floating point operations executed; optimized to count scaled double precision vector operations
    VEC_SP,  # Single precision vector/SIMD instructions
    VEC_DP,  # Double precision vector/SIMD instructions
    REF_CYC, # Reference clock cycles
    END      # This should always be last!
)

primitive type Native sizeof(Cuint)*8 end
Native(x::Integer) = Base.bitcast(Native, convert(Cuint, x))
Base.cconvert(::Type{T}, x::Native) where {T<:Integer} = Base.bitcast(T, x)::T

const Event = Union{Preset, Native}

Base.promote_rule(::Type{Native}, ::Type{Preset}) = Event

function exists(evt::Event)
	errcode = ccall((:PAPI_query_event, :libpapi), Cint, (Cuint,), evt)
	if errcode != PAPI_OK && errcode != PAPI_ENOEVNT
		throw(PAPIError(errcode))
	end

    return errcode == PAPI_OK
end

function event_to_name(evt::Event)
	str_buf = Vector{UInt8}(undef,PAPI_MAX_STR_LEN)
	@papichk ccall((:PAPI_event_code_to_name, :libpapi), Cint, (Cuint, Ptr{UInt8}), evt, str_buf)
	unsafe_string(pointer(str_buf))
end

function name_to_event(name::AbstractString)
    evt = Ref{Cuint}()
    @papichk ccall((:PAPI_event_name_to_code, :libpapi), Cint, (Cstring, Ptr{Cuint}), name, evt)
    Native(evt[])
end

function Base.show(io::IO, evt::Native)
  name = event_to_name(evt)
  print(io, name)
end

available_presets() = filter(exists, instances(Preset))
