### EcologicalNetworksPlots

This package provides plotting abilities for `EcologicalNetworks.jl`. It uses
`Plots.jl` and `RecipesBase.jl` to do the plotting. The package currently
generates force-directed layouts, with planned support for circular layouts.

It is currently not registered, and works with *Julia* `0.7` and `1.0` **only**.

#### Overview

Plotting a network is done in four steps: creating a random initial layout,
refining this layout, cleaning up, and plotting.

##### Initial layout

- `initial_random_layout` (for the standard graph layout)
- `initial_bipartite_layout` (for bipartite networks)
- `initial_foodweb_layout` (for unipartite networks, the *y* position is the trophic level)

All these functions take a network as input, and return a layout. A layout is a
dictionary of network nodes to `NodePosition` objects (but you don't really need
to care about this).

##### Layout refinement

- `graph_layout!` (standard force directed)
- `bipartite_layout!`, `foodweb_layout!` (same thing but the *y*-axis position is fixed)

These function take a network and a layout as input, and modify the layout.

Optional arguments: `k=0.2` (strength of node attraction), `center=true` (nodes
are attracted to the *(0,0)* coordinate).

##### Cleaning up

- `EcologicalNetworksPlots.finish_layout!` (normalizes the dimensions)
- `EcologicalNetworksPlots.spread_levels!` (changes the aspect ratio of the plot)

##### Plotting

`plot(N, layout)`

There are a few additional arguments (everything accepted by `Plots.jl` can be used):

- `nodefill` is a node=>value dictionary for the color of nodes
- `nodesize` is a node=>value dictionary for the size of nodes
- `bipartite` is a Boolean to differentiate nodes in bipartite networks

##### Example

``` julia
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots

U = web_of_life("A_HP_001")
I0 = initial_random_layout(U)
[graph_layout!(U, I0) for i in 1:600]
EcologicalNetworksPlots.finish_layout!(I0)
p1 = plot(U, I0)
```

#### Example output

![Example output](https://raw.githubusercontent.com/PoisotLab/EcologicalNetworksPlots.jl/master/gallery/overlays.png)
