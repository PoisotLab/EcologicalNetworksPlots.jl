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
for step in 1:2000
  position!(ForceDirectedLayout(1.5), I, Umod)
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

The size of the nodes can be changed using the `nodesize` argument, which is a
dictionary mapping species to values. These values are scaled when making the
figures. Note that in this example we also label the number of the node.

```@example default
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodesize=degree(Unes), series_annotations = string.(1:richness(Unes)))
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

The unravelled layout is essentially a scatterplot of network properties with
interactions drawn as well. This is inspired by [the work of Giulio Valentina
Dalla Riva on this visualisation][gvdr]. By default, it will compare the
omnivory index and the trophic level:

[gvdr]: https://github.com/gvdr/unravel

```@example default
N = nz_stream_foodweb()[10]
I = initial(UnravelledInitialLayout, N)
plot(I, N, lab="", framestyle=:box)
scatter!(I, N, nodefill=degree(N), colorbar=true, framestyle=:box)
```

Because a lot of species will have the same omnivory index, we might want to use
a slightly different function, which adds some randomness to the omnivory:

```@example default
N = nz_stream_foodweb()[10]
I = initial(UnravelledInitialLayout, N)

function random_omnivory(N::T) where {T <: UnipartiteNetwork}
  o = omnivory(N)
  for s in species(N)
    o[s] += (rand()-0.5)*0.08
  end
  return o
end

UL = UnravelledLayout(x=random_omnivory, y=trophic_level)
position!(UL, I, N)

plot(I, N, lab="", framestyle=:box)
scatter!(I, N, nodefill=degree(N), colorbar=true, framestyle=:box, c=:viridis)
```
