```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

## 3-core plot

One important feature of the package is that the layout can contain *more* nodes
than the network. For example, we can use this to our advantage, to represent
species with a degree larger than 3 in red:

```@example default
Umod = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, Umod)
for step in 1:4000
  position!(ForceDirectedLayout(2.5, 0.4), I, Umod)
end
plot(I, Umod, aspectratio=1)
scatter!(I, Umod)
N = convert(AbstractUnipartiteNetwork, convert(BinaryNetwork, Umod))
core3 = collect(keys(filter(p -> p.second == 3, degree(N))))
plot!(I, N[core3], lc=:red)
scatter!(I, N[core3], mc=:red)
```

## Modularity

We can also use this ability to show the modular structure of a network:

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:2000
  position!(ForceAtlas2(1.2; gravity=0.2), I, N)
end

# Modularity
_, P = brim(lp(N)...)
plot(I, N, aspectratio=1)
scatter!(I, N, msw=0.0, nodefill=P)
```