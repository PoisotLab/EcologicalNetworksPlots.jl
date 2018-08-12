# Force directed layout -- attempt 1

using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
using RecipesBase

U = web_of_life("A_HP_010")
K = convert(BinaryNetwork, U)
P = null2(K)
I0 = EcologicalNetworksPlots.initial_forcedirectedlayout(U)
[EcologicalNetworksPlots.forcedirectedlayout!(U, I0) for i in 1:600]

Npart = N |> lp |> (x) -> brim(x...)

plot(U, I0; nodesize=degree(K), nodefill=Npart[2], markercolor=:isolum, size=(500,500), frame=:origin)
L = copy(I0)
finish_layout!(L, link=true)
plot(U, L; nodesize=degree(K), nodefill=Npart[2], markercolor=:isolum, size=(500,500), frame=:none)
savefig("network.png")
plot(U, I0; nodesize=degree(K), markercolor=:isolum)
plot(U, I0)



plot(U, I0, degree, msc=:teal, mc=:white, lc=:teal)
plot(N, I0, degree, msc=:teal, mc=:white, lc=:teal)
plot(P, I0, degree, msc=:teal, mc=:white, lc=:teal)
