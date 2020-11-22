## Circular layout

### Layouts

```@docs
CircularInitialLayout
CircularLayout
```

```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

### Example

```@example default
Unes = web_of_life("M_SD_033")
I = initial(CircularInitialLayout, Unes)
position!(CircularLayout(), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true)
```