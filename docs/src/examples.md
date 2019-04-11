```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

## Static layouts

### Nested

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true)
```

### Circular

```@example default
Umod = web_of_life("M_PA_003")
I = initial(CircularInitialLayout, Umod)
position!(CircularLayout(), I, Umod)
plot(I, Umod, aspectratio=1)
scatter!(I, Umod, bipartite=true)
```

## Dynamic layouts

### Force directed

```@example default
Umod = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, Umod)
for step in 1:2000
  position!(ForceDirectedLayout(2.5), I, Umod)
end
plot(I, Umod, aspectratio=1)
scatter!(I, Umod, bipartite=true)
```
