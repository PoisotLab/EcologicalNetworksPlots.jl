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

## A basic example

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
for step in 1:(100richness(N))
  position!(ForceDirectedLayout(0.3, 0.3; gravity=0.0), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

We can turn gravity on just a little bit:

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:(100richness(N))
  position!(ForceDirectedLayout(0.3, 0.3; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

We can also make links attract more strongly than nodes repel (and turn gravity
on some more):

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:(100richness(N))
  position!(ForceDirectedLayout(0.3, 0.75; gravity=0.4), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

## Standard layouts

The force-directed code uses a series of *exponents* in addition to the values,
to change the conformation of the resulting diagram.

```@docs
FruchtermanRheingold
ForceAtlas2
SpringElectric
```

The Fruchterman-Rheingold method is the default:

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:(100richness(N))
  position!(FruchtermanRheingold(0.3; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

Force Atlas 2 usually gives very good results, and is in particular really good
at showing the modules and long paths in a network.

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:(100richness(N))
  position!(ForceAtlas2(0.8; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

For the sake of exhaustivity, we have included the spring electric layout. This
can give good results too, and is worth investigating as a possible
visualisation:

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:(100richness(N))
  position!(SpringElectric(1.2; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

## Degree and edge-based forces

By default, *all edges* have the same attraction, and nodes repel one another
according to the product of their degree. In this section, we will explore the
differences these choices can have.

All nodes repel at the same force, no impact of edge weight:

```@example default
I = initial(RandomInitialLayout, N)
L = SpringElectric(1.2; gravity=0.2)
L.degree = false
for step in 1:(100richness(N))
  position!(L, I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

All nodes repel at the same force, weak impact of edge weight:

```@example default
I = initial(RandomInitialLayout, N)
L = SpringElectric(1.2; gravity=0.2)
L.degree = false
L.δ = 0.1
for step in 1:(100richness(N))
  position!(L, I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

All nodes repel at the same force, strong impact of edge weight:

```@example default
I = initial(RandomInitialLayout, N)
L = SpringElectric(1.2; gravity=0.2)
L.degree = false
L.δ = 2.0
for step in 1:(100richness(N))
  position!(L, I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

Nodes repel according to their degree, strong impact of edge weight:

```@example default
I = initial(RandomInitialLayout, N)
L = SpringElectric(1.2; gravity=0.2)
L.degree = true
L.δ = 2.0
for step in 1:(100richness(N))
  position!(L, I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

Nodes repel according to their degree, some impact of edge weight:

```@example default
I = initial(RandomInitialLayout, N)
L = SpringElectric(1.2; gravity=0.2)
L.degree = true
L.δ = 0.2
for step in 1:(100richness(N))
  position!(L, I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

## Food webs

One convenient way to plot food webs is to prevent them from moving on the *y*
axis, so that every species remains at its trophic level. This can be done by
changing the `move` field (as `ForceDirectedLayout` is a mutable type).

```@example default
N = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, N)
L = SpringElectric(1.2; gravity=0.05)
L.move = (true, false)
for step in 1:(100richness(N))
  position!(L, I, N)
end
plot(I, N)
scatter!(I, N, nodefill=omnivory(N), nodesize=degree(N), c=:YlGn)
```