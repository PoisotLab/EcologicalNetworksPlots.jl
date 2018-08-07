module EcologicalNetworksPlots

using EcologicalNetworks
using Plots

include(joinpath(".", "types.jl"))
export NodePosition

include(joinpath(".", "forcedirected.jl"))

include(joinpath(".", "plot.jl"))

end # module
