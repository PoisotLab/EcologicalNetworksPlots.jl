using EcologicalNetworks
using EcologicalNetworksPlots
using Plots

using Random
Random.seed!(42);

U = web_of_life("A_HP_010")

for al in [true, false], re in [true, false]
    I = initial(BipartiteInitialLayout, U)
    position!(NestedBipartiteLayout(al, re, 0.45), I, U)
    plot(I, U, aspectratio=1)
    scatter!(I, U)
    savefig(joinpath("..", "gallery", "t-align-$(al)-relative-$(re).png"))
end

U = web_of_life("A_HP_010")
I = initial(RandomInitialLayout, U)
for i in 1:50
    position!(ForceDirectedLayout(), I, U)
end
plot(I, U, aspectratio=1)
scatter!(I, U)
savefig(joinpath("..", "gallery", "fd.png"))
