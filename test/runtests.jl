using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
using Test

using Random
Random.seed!(42);

# Prepare the output
figpath = joinpath(pwd(), "gallery")
ispath(figpath) && rm(figpath)
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
@test isfile(joinpath(figpath, "bip_nest_al_$(al)_re_$(re).png"))

@info "Bipartite -- circular"
I = initial(CircularInitialLayout, Unes)
position!(CircularLayout(), I, Unes)
plot(I, Unes, aspectratio=1, framestyle=:grid, legend=true)
savefig(joinpath(figpath, "bip_circular_plot.png"))
scatter!(I, Unes, bipartite=true)
savefig(joinpath(figpath, "bip_circular_full.png"))
@test isfile(joinpath(figpath, "bip_circular_full.png"))

I = initial(CircularInitialLayout, Umod)
position!(CircularLayout(), I, Umod)
plot(I, Umod, aspectratio=1, framestyle=:grid, legend=false)
savefig(joinpath(figpath, "bip_circular_plot_2.png"))
scatter!(I, Umod, bipartite=true, framestyle=:box, legend=true)
savefig(joinpath(figpath, "bip_circular_full_2.png"))
@test isfile(joinpath(figpath, "bip_circular_full_2.png"))

Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
plot(I, Unes, aspectratio=1)
scatter!(I, Unes, bipartite=true, nodefill=degree(Unes))

Fweb = simplify(nz_stream_foodweb()[5])
I = initial(FoodwebInitialLayout, Fweb)
for step in 1:300
  position!(ForceDirectedLayout(true, false, 2.5), I, Fweb)
end
tl = trophic_level(Fweb)
for s in species(Fweb)
  I[s].y = tl[s]
end
plot(I, Fweb)
scatter!(I, Fweb)
