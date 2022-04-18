#using Revise
using EcologicalNetworksPlots
using EcologicalNetworks
using Plots
using ProgressMeter
using BenchmarkTools

# Example from the documentation
N = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, N)

# All position! routines work the same, so the specific choice of algorithm
# should have no serious impact
Opt = ForceAtlas2(1.0; gravity=1.0)
Opt.δ = 0.2
Opt.degree = true

steps = 5000
p = ProgressMeter.Progress(steps; showspeed=true)
for step in 1:steps
    position!(Opt, I, N)
    next!(p)
end

plot(I, N, aspectratio=1, dpi=400, linewidthrange=(0.2, 4.0))
scatter!(I, N, bipartite=true, nodefill=degree(N), c=:viridis, cbar=true, nodesize=degree(N))