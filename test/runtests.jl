using EcologicalNetworks
using EcologicalNetworksPlots
using Plots

using Random
Random.seed!(42);

U = web_of_life("M_PL_003")
I = initial(RandomInitialLayout, U)
for i in 1:1000
    position!(ForceDirectedLayout(2.0), I, U)
end
plot(I, U, aspectratio=1)
scatter!(I, U)
savefig(joinpath("..", "gallery", "fd-$(rpad(k,5,'0')).png"))

U = web_of_life("A_HP_010")
for al in [true, false], re in [true, false]
    I = initial(BipartiteInitialLayout, U)
    position!(NestedBipartiteLayout(al, re, 0.45), I, U)
    plot(I, U, aspectratio=1)
    scatter!(I, U)
    savefig(joinpath("..", "gallery", "t-align-$(al)-relative-$(re).png"))
end
