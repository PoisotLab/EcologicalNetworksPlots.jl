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
Unes = web_of_life("M_SD_033")
I = initial(CircularInitialLayout, Unes)
position!(CircularLayout(), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true)
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
Fweb = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, Fweb)
for step in 1:4000
  position!(ForceDirectedLayout(true, false, 2.5), I, Fweb)
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

## Advanced examples

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
core3 = collect(keys(filter(p -> p.second ≥ 3, degree(N))))
scatter!(I, N[core3], mc=:red)
```
