## Node color

```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodefill=degree(Unes), c=:cividis)
```

## Node size

The size of the nodes can be changed using the `nodesize` argument, which is a
dictionary mapping species to values. These values are scaled when making the
figures. Note that in this example we also label the number of the node.

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodesize=degree(Unes))
```

## Node annotations

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, series_annotations = string.(1:richness(Unes)))
```
