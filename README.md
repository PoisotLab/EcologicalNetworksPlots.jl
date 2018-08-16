### EcologicalNetworksPlots

This package provides plotting abilities for `EcologicalNetworks.jl`. It uses
`Plots.jl` and `RecipesBase.jl` to do the plotting.

#### Overview

``` julia
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots


U = web_of_life("A_HP_001")
K = convert(BinaryNetwork, U)
P = null2(K)
I0 = initial_random_layout(U)
[graph_layout!(U, I0) for i in 1:600]
EcologicalNetworksPlots.finish_layout!(I0)
p1 = plot(K, I0)
```

#### Example output

![Example output](https://raw.githubusercontent.com/PoisotLab/EcologicalNetworksPlots.jl/master/gallery/overlays.png)
