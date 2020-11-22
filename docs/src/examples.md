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

