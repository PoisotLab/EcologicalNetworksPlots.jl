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
for step in 1:2000
  position!(FruchtermanRheingold(0.3; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

Force Atlas 2 gives usually very good results, and is in particular really good
at showing the modules and long paths in a network.

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:2000
  position!(ForceAtlas2(1.2; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

For the sake of exhaustivity, we have included the spring electric layout:

```@example default
I = initial(RandomInitialLayout, N)
for step in 1:2000
  position!(SpringElectric(1.2; gravity=0.2), I, N)
end
plot(I, N, aspectratio=1)
scatter!(I, N, bipartite=true)
```

## Food web example

One convenient way to plot food webs is to prevent them from moving on the *y*
axis, so that every species remains at its trophic level. This can be done by
changing the `move` field (as `ForceDirectedLayout` is a mutable type). Note
that in this example, we *update* the layout after plotting, by replacing the
fractional trophic level by the actual trophic level (and we color the nodes by
their omnivory, which is covered more in-depth in the next section of this
documentation).

```@example default
Fweb = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, Fweb)
L = SpringElectric(1.2; gravity=0.05)
L.move = (true, false)
for step in 1:2000
  position!(L, I, Fweb)
end
tl = trophic_level(Fweb)
for s in species(Fweb)
  I[s].y = tl[s]
end
plot(I, Fweb)
scatter!(I, Fweb, nodefill=omnivory(Fweb), c=:YlGn)
```