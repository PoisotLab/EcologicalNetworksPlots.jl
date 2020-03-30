using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
using Test

using Random
Random.seed!(42);

# Prepare the output
figpath = joinpath(pwd(), "gallery")
ispath(figpath) || mkdir(figpath)

Umod = web_of_life("M_PA_003")
Unes = web_of_life("M_SD_033")

@info "Bipartite -- nested"
for al in [true, false], re in [true, false]
    I = initial(BipartiteInitialLayout, Unes)
    position!(NestedBipartiteLayout(al, re, 0.4), I, Unes)
    plot(I, Unes, aspectratio=1)
    scatter!(I, Unes, bipartite=true)
    savefig(joinpath(figpath, "bip_nest_al_$(al)_re_$(re).png"))
end

@info "Bipartite -- circular"
I = initial(CircularInitialLayout, Unes)
position!(CircularLayout(), I, Unes)
plot(I, Unes, aspectratio=1, framestyle=:grid, legend=true)
scatter!(I, Unes, bipartite=true)
savefig(joinpath(figpath, "bip_circular.png"))
