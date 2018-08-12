### EcologicalNetworksPlots

This package provides plotting abilities for `EcologicalNetworks.jl`. It uses
`Plots.jl` and `RecipesBase.jl` to do the plotting.

#### Overview

``` julia
using EcologicalNetworks
using EcologicalNetworksPlots

U = web_of_life("A_HP_010")
K = convert(BinaryNetwork, U)
P = null2(K)

# Generate the initial objects for the layout
I0 = EcologicalNetworksPlots.initial_forcedirectedlayout(U)

# 600 passes of force directed layout
[EcologicalNetworksPlots.forcedirectedlayout!(U, I0) for i in 1:600]

# Finish the layout and preserve aspect ratio
finish_layout!(I0, link=true)

# Default plot
plot(U, I0)

# Measure modularity
Npart = N |> lp |> (x) -> brim(x...)

# The nodefill argument is a dictionary with values for the color of nodes
plot(U, L; nodefill=Npart[2], markercolor=:isolum)

# Same with nodesize
plot(U, L; nodesize=degree(K), nodefill=Npart[2], markercolor=:isolum)
```

#### Example output

![Example output](https://raw.githubusercontent.com/PoisotLab/EcologicalNetworksPlots.jl/master/network.png)
