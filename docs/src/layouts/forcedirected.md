## Layouts

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

## Bipartite example

In this example, we have a quantitative bipartite network, and we will set no
gravity (nodes can move as far away as they want from the center). Note that our
initial layout is a `CircularInitialLayout`, which is not a problem! We can use
any starting position we want.

```@example default
N = web_of_life("M_PA_003")
I = initial(CircularInitialLayout, N)
for step in 1:2000
  position!(ForceDirectedLayout(0.3, 0.3; gravity=0.0), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

We can turn gravity on:

```@example default
for step in 1:2000
  position!(ForceDirectedLayout(0.3, 0.3; gravity=0.6), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

We can also make links attract more strongly than nodes repel:

```@example default
for step in 1:2000
  position!(ForceDirectedLayout(0.6, 0.3; gravity=0.5), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
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