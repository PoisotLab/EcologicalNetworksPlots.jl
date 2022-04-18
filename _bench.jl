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
Opt = SpringElectric(1.0; gravity=0.12)
Opt.δ = 0.2

steps = 10000
p = ProgressMeter.Progress(steps; showspeed=true)
for step in 1:steps
    position!(Opt, I, N)
    next!(p)
end

plot(I, N, aspectratio=1, dpi=400, linewidthrange=(0.2, 6.0))
scatter!(I, N, bipartite=true, nodefill=degree(N), c=:viridis, cbar=true, nodesize=degree(N), frame=:box, nodesizerange=(4.0, 9.0))
