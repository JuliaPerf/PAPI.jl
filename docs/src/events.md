# Events

Events are occurrences of specific signals related to a processor’s function. Hardware performance counters exist as a small
set of registers that count events, such as cache misses and floating point operations while the program executes on the processor.
Other performance counters might exist on the operating system level for events such as page faults and context switches.

Monitoring these events facilitates correlation between the structure of source/object code and the efficiency of the mapping of that code to the underlying architecture. Each processor/architecture/system has a number of events that are native to it.
PAPI provides a software abstraction of these architecture-dependent `native` events into a collection of `preset` events that are accessible through the PAPI interface.

`PAPI.jl` uses the `Event` type to represent both `native` events (`PAPI.Native`) and `preset` events (`PAPI.Preset`).

## Native events

Native events comprise the set of all events that are countable by the system. In many cases, these events will be available through a matching [preset](#presets) PAPI event. These native events can also be access directly, however this usage is intended for people who are very familiar with the particular platform in use.
PAPI provides access to native events on all supported platforms through the low-level interface.

## Presets

The PAPI library provides approximately 100 presets (predefined events) that are a common set of events relevant for application performance tuning.
These events are typically found in many processors that provide performance counters and give access to the memory hierarchy, cache coherence protocol events, cycle and instruction counts, functional unit, and pipeline status.

Preset events map symbolic names to specific native events on the particular architecture in use. For example, `Total Cycles` is represented as `PAPI.TOT_CYC`.
A preset can be either directly available as a single counter, derived using a combination of counters, or unavailable on any particular platform.

A full list of the presets and their job description can be found [here](http://icl.cs.utk.edu/projects/papi/files/documentation/PAPI_USER_GUIDE_23.htm#APPENDIX_A).

`PAPI.jl` includes the same set of presets represented as `PAPI.TOT_CYC` instead of `PAPI_TOT_CYC`.

The exact semantics of an event counter are platform dependent. PAPI preset names are mapped onto available events in a way, so it can count as many similar types of events as possible on different platforms. Due to hardware implementation differences, it is not necessarily feasible to directly compare the counts of a particular PAPI event obtained on different hardware platforms.

To determine which preset events are available on your specific platform, the `available_presets` function can be used:

```@example
using PAPI # hide
available_presets()
```

The `exists` function tests whether a single native or preset event is available:
```@example
using PAPI # hide
exists(PAPI.TOT_INS)
```

## Accessing events

Preset events can be accessed using the predefined constants `PAPI.TOT_CYC`. All events can be accessed by name using the function `name_to_event` and converted
back to their name with `event_to_name`

```julia
using PAPI #hide
tot_ins = name_to_event("PAPI_TOT_INS") # Total Instructions preset same as PAPI.TOT_INS
page_faults = name_to_event("PAGE-FAULTS") # Page-fault counter provided by perf, if available
tot_cyc = event"PAPI_TOT_CYC" # same, but with macro
```

`Base.show` automatically converts the event back to its corresponding name.

## Available events

A full list of available events is provided by `available_presets` and `available_native` for presets and native events respectively.

```@docs
available_presets
available_native
```
