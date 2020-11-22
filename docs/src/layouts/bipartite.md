## Bipartite layouts

### Layouts

```@docs
BipartiteInitialLayout
NestedBipartiteLayout
```

```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

### Example

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true)
```