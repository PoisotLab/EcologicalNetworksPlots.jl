## Creating the initial layout

The first step is to generate a starting position for the nodes in the network.
In a lot of cases, this is a pseudo-random position, which is then refined. The
methods for every layouts have different initial conditions.

```@docs
initial
```

## Applying the layout

The second step is to apply the layout. In most cases, this only needs to be
done once. Force-directed layouts can require a very large number of iterations,
and also tend to scale very poorly with the size of the network.

```@docs
position!
```