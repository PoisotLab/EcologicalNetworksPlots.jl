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
initial layout is a `RandomInitialLayout`, but we can use *any* layout we see
fit when starting.

```@example default
N = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, N)
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

The next step is to actually position the nodes relative to one another. Because
this network has disconnected components, and we have no gravity, we expect that
they will be quite far from one another:

```@example default
for step in 1:2000
  position!(ForceDirectedLayout(0.3, 0.3; gravity=0.0), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

We can turn gravity on just a little bit:

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:2000
  position!(ForceDirectedLayout(0.3, 0.3; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

We can also make links attract more strongly than nodes repel (and turn gravity
on some more):

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:2000
  position!(ForceDirectedLayout(0.6, 0.15; gravity=0.4), I, N)
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