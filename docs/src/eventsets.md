# Event Sets

Event Sets are user-defined groups of events (preset or native).
The user is free to allocate and use any number of them provided the required resources can be provided.

Multiple event sets can be used simultaneously and can even share counter values.

## Adding and removing events

Events can be added to event set using `push!` and `append!`. Removal of events is done using `empty!` and `delete!`

```@docs
push!(::EventSet, ::Event)
append!(::EventSet, ::Vector{Event})
empty!(::EventSet)
delete!(::EventSet, ::Event)
```
