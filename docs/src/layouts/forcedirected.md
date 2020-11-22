## Force-directed layout

```@docs
FoodwebInitialLayout
RandomInitialLayout
ForceDirectedLayout
```


```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

### Bipartite example

```@example default
Umod = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, Umod)
for step in 1:2000
  position!(ForceDirectedLayout(1.5), I, Umod)
end
plot(I, Umod, aspectratio=1)
scatter!(I, Umod, bipartite=true)
```

## Food web example

```@example default
Fweb = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, Fweb)
for step in 1:4000
  position!(ForceDirectedLayout((true, false), 2.5), I, Fweb)
end
plot(I, Fweb)
scatter!(I, Fweb)
```