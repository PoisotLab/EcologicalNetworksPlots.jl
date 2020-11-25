```@setup default
using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
```

```@example default
N = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, N)
@gif for i in 1:2000
    position!(ForceAtlas2(1.2; gravity=0.2), I, N)
    plot(I, N, aspectratio=1)
    scatter!(I, N, bipartite=true, nodesize=degree(N), nodefill=degree(N), c=:YlGnBu)
end
```