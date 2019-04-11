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
for step in 1:4000
  position!(ForceDirectedLayout(2.5), I, Umod)
end
plot(I, Umod, aspectratio=1)
scatter!(I, Umod, bipartite=true)
```

### Food web layout

```@example default
Fweb = simplify(nz_stream_foodweb()[1])
I = initial(FoodwebInitialLayout, Fweb)
for step in 1:4000
  position!(ForceDirectedLayout(true, false, 2.5), I, Fweb)
end
plot(I, Fweb, aspectratio=1)
scatter!(I, Fweb)
```

## Node coloring

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodefill=degree(Unes))
```
