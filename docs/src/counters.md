# Counting Events

`PAPI` provides the ability to start, stop, read and accumulate the counters for a specified list of events.
`PAPI.jl` exposes this functionality (See [counting](#papi-interface)), but builds more user-friendly primitives on top of this.

`PAPI.jl` stores count values using the `Counts` type.

## Measuring Performance

`PAPI,jl` provides two ways of measuring performance counters:

- Quick, one shot `profile`
- Extensive `sample` based

### Profile

`profile` and `@profile` can be used to quickly measure some performance counts on a function or expression.
Since the function is only executed once, these counts should be taken with a grain of salt as they can be riddled
with noise especially for short running functions.

```@docs
profile
@profile
```

The resulting `EventValues` contain the events and counts collected and when printed a nice summary is generated with additional information.

### Sample

Contrary to `profile`, `sample` and `@sample` perform multiple executions. The resulting samples can be used to investigate
the distributions of the counts and to perform various statistical tests.

!!! note
    You should be careful when making decisions on performance based on single or aggregate values (such as `mean`, `minimum`, `median`)
    as well as "eyeball" statistics. Statistical tests such as a [t-test](https://en.wikipedia.org/wiki/Student%27s_t-test),
    [wilcoxon](https://en.wikipedia.org/wiki/Wilcoxon_signed-rank_test) can be used.

    Personally, I'm also wary towards any asymptotical tests putting strong assumptions on the distributions. For example,
    performance numbers (even runtime) are not always normal distributed: the process is usually skewed towards one side.
    I tend to use the samples themselves as well as their quantiles.

```@docs
sample
@sample
```

The resulting `EventStats` contain the events and all counts collected and when printed a nice summary is generated with additional statistics.
The additional statistics are computed using the `mean` and are mostly intended as information to guide the optimization process.

### Example

As an example consider the following function

```@example mysum
using PAPI #hide

function mysum(X::AbstractArray)
    s = zero(eltype(X))
    for x in X
        s += x
    end
    s
end
nothing #hide
```

Next, we'll create an array of double precision values and produce a profile using the default events

!!! note
    `warmup` is set to 1, to force compilation prior to measurement

```@example mysum
X = rand(10000)
@profile mysum(X) warmup=1
```

Since the number of elements added was 10000, you can note it take roughly 4 instructions per element. Out of which one is a branch instruction,
corresponding to the termination test of the loop. We also expect the data needs to be loaded in every iteration, something we can verify by
additionally measuring the number of loads using the preset `PAPI.LD_INS`.

```@example mysum
@profile [PAPI.TOT_INS, PAPI.TOT_CYC, PAPI.LD_INS, PAPI.BR_INS] mysum(X)
```

Indeed, in addition to the branch instruction there is a load in every iteration as well. Generally, you would expect a load,
a branch, an addition and a counter increment in every iteration, and this data seems to confirm this. However modern processors are capable
of loading and multiplying multiple data items at the same time. The `@simd` macro might be useful here.

!!! note
    `@simd` instructs the compiler that it is safe to execute the iterations in arbitrary and overlapping order.
    This also means that we are fine with any floating-point errors introduced by this reordering of operations.

```@example mysum
function mysum2(X::AbstractArray)
    s = zero(eltype(X))
    @simd for x in X
        s += x
    end
    s
end

@profile [PAPI.TOT_INS, PAPI.TOT_CYC, PAPI.LD_INS, PAPI.BR_INS] mysum2(X) warmup=1
```

Note the reduction in the number of cycles, instructions, branches, loads and runtime. From these measurements, one could
assume the addition of `@simd` has a positive effect. However, it would be better if we compute more samples and perform a statistical test
to confirm that the effect is significant.

Finally, let's look at the number of floating-point operations and vectorized floating-point operations.

```@example mysum
@profile [PAPI.TOT_INS, PAPI.DP_OPS, PAPI.VEC_DP] mysum(X)
```

```@example mysum
@profile [PAPI.TOT_INS, PAPI.DP_OPS, PAPI.VEC_DP] mysum2(X)
```

Both functions perform the same number of additions (``\approx 1`` per element), but `mysum` is able to vectorize those operations (performing almost 4 additions at the same time). Looking back at the earlier comparison, we can also see the number of loads has decreased by a factor of 4, indicating that the loop now loads
roughly four elements simultaneously. The number of branches had decreased even more. Investigation of `@code_native mysum2(X)` indeed also indicated that
the compiler does loop unrolling in addition to vectorization.

Let's now collect multiple samples in order to draw our final conclusion:

```@example mysum
stats = @sample mysum(X) # original version
stats2 = @sample mysum2(X) # optimized version
```

1000 samples were collected for both version for the default events as well as the runtimes. A decision can for example be made using
a `wilcoxon` (or `mann-whitney U`) test. This tests whether the two sets of samples come from the same underlying distribution.

```@example mysum
using HypothesisTests
x = stats.time
y = stats2.time
MannWhitneyUTest(x,y)
```

Rejection of the null-hypothesis indicates the underlying distributions are different and the changes have some significant effect
(in this case a positive effect).

!!! note
    Alternatively, a student t-test could be used to perform a similar test. However, this test assumes normally distributed samples.
    Plotting a histogram of the samples clearly indicates this is not the case.

Using a [Monte-Carlo estimator](https://en.wikipedia.org/wiki/Monte_Carlo_method), the expected speedup can be computed as well as 95% uncertainty intervals.

```@example mysum
using Statistics
println("expected speedup = ", mean(x ./ y'))
println("95% of the time, the speedup lies within ", quantile(vec(x ./ y'), [.025, 0.975]))
```



## PAPI interface

Only a number of events can be counted at the same time, `num_counters` returns the number of hardware counters available on the system.
```@docs
num_counters
```

After selecting a number of events to count, the counting process can be started and stopped using `start_counters` and `stop_counters`.

!!! warning
    It is the user’s responsibility to choose events that can be counted simultaneously by reading the vendor’s documentation.

```@docs
start_counters
stop_counters
stop_counters!
```

```@example counting
using PAPI #hide
computation(n::Int64 = 10_000) = (tmp = 0.; for i = 1:n tmp += i end; tmp) #hide
events = Event[PAPI.TOT_INS, PAPI.DP_OPS]
evtset = start_counters(events)
computation()
values = stop_counters(evtset)
```

During the counting process, the current counts can be queried and accumulated using `read_counters!` and `accum_counters!`.

```@docs
read_counters!
accum_counters!
```

```@example counting
events = Event[PAPI.DP_OPS]
values = Vector{Counts}(undef, length(events))
evtset = start_counters(events)
computation(100) # perform 100 double precision operations
read_counters!(evtset, values)
println(values[1], " roughly equals 100")

computation(100) # perform 100 double precision operations
accum_counters!(evtset, values)
println(values[1], " roughly equals 200")

values[1] = -100
computation(100) # perform 100 double precision operations
accum_counters!(evtset, values)
println(values[1], " roughly equals 0")
stop_counters(evtset); nothing
```
