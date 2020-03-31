```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

## Nested layout

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true)
```

## Circular layout

```@example default
Unes = web_of_life("M_SD_033")
I = initial(CircularInitialLayout, Unes)
position!(CircularLayout(), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true)
```

## Force directed layout

```@example default
Umod = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, Umod)
for step in 1:4000
  position!(ForceDirectedLayout(2.5), I, Umod)
end
plot(I, Umod, aspectratio=1)
scatter!(I, Umod, bipartite=true)
```

## Food web layout

```@example default
Fweb = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, Fweb)
for step in 1:4000
  position!(ForceDirectedLayout(true, false, 2.5), I, Fweb)
end
plot(I, Fweb)
scatter!(I, Fweb)
```

Note that we can replace some properties of the nodes in the layout *after* the
positioning algorithm occurred -- so we can, for example, use the actual
(instead of fractional) trophic level:

```@example default
Fweb = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, Fweb)
for step in 1:4000
  position!(ForceDirectedLayout(true, false, 2.5), I, Fweb)
end
tl = trophic_level(Fweb)
for s in species(Fweb)
  I[s].y = tl[s]
end
plot(I, Fweb)
scatter!(I, Fweb)
```

## Node properties

### Color

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodefill=degree(Unes))
```

### Size

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodesize=degree(Unes))
```


## Network subsets

One important feature of the package is that the layout can contain *more* nodes
than the network. For example, we can use this to our advantage, to represent
species with a degree larger than 3 in red:

```@example default
Umod = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, Umod)
for step in 1:4000
  position!(ForceDirectedLayout(2.5), I, Umod)
end
plot(I, Umod, aspectratio=1)
scatter!(I, Umod)
N = convert(AbstractUnipartiteNetwork, convert(BinaryNetwork, Umod))
core3 = collect(keys(filter(p -> p.second == 3, degree(N))))
plot!(I, N[core3], lc=:red)
scatter!(I, N[core3], mc=:red)
```

## Heatmap

```@example default
Umod = web_of_life("M_PA_003")
heatmap(Umod, c=:YlGnBu)
```

```@example default
Umod = convert(BipartiteNetwork, web_of_life("M_PA_003"))
heatmap(convert(UnipartiteNetwork, Umod))
```

## Unravelled layout

```@example default
N = nz_stream_foodweb()[10]
I = initial(UnravelledInitialLayout, N)
position!(UnravelledLayout((n) -> degree(n, dims=1), (n) -> degree(n, dims=2)), I, N)
plot(I, N, lab="", framestyle=:box)
scatter!(I, N, nodefill=degree(N), legend=true, framestyle=:box)
```
