using EcologicalNetworks
using EcologicalNetworksPlots
using Plots

using Random
Random.seed!(42);

U = web_of_life("A_HP_001")
I = initial(BipartiteInitialLayout, U)

plot(I, U)
scatter!(I, U)
savefig(joinpath("..", "gallery", "t1.png"))

position!(NestedBipartiteLayout(false, true), I, U)
plot(I, U)
scatter!(I, U)
savefig(joinpath("..", "gallery", "t2.png"))

position!(NestedBipartiteLayout(false, false), I, U)
plot(I, U)
scatter!(I, U)
savefig(joinpath("..", "gallery", "t3.png"))

position!(NestedBipartiteLayout(true, true), I, U)
plot(I, U)
scatter!(I, U)
savefig(joinpath("..", "gallery", "t4.png"))

position!(NestedBipartiteLayout(true, false), I, U)
plot(I, U)
scatter!(I, U)
savefig(joinpath("..", "gallery", "t5.png"))
