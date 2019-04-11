using EcologicalNetworks
using EcologicalNetworksPlots
using Pkg; Pkg.add("Plots")

using Random
Random.seed!(42);

Umod = web_of_life("M_PA_003")
Unes = web_of_life("M_SD_033")

@info "Bipartite -- nested"

for al in [true, false], re in [true, false]
    I = initial(BipartiteInitialLayout, Unes)
    position!(NestedBipartiteLayout(al, re, 0.6), I, U)
    plot(I, U, aspectratio=1)
    scatter!(I, U, bipartite=true)
    isal = al ? "aligned" : "free"
    isre = re ? "relative" : "spread"
    savefig(joinpath("..", "gallery", "bipartite-nested-$(isal)-$(isre).png"))
end

Pkg.rm("Plots")
