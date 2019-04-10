using EcologicalNetworks
using EcologicalNetworksPlots
using Plots

using Random
Random.seed!(42);

U = web_of_life("A_HP_010")

for al in [true, false], re in [true, false]
    I = initial(BipartiteInitialLayout, U)
    position!(NestedBipartiteLayout(al, re, 1.25), I, U)
    plot(I, U, aspectratio=1)
    scatter!(I, U)
    savefig(joinpath("..", "gallery", "t-align-$(al)-relative-$(re).png"))
end
