module EcologicalNetworksPlots

using EcologicalNetworks
using Plots
using RecipesBase

include(joinpath(".", "types.jl"))
export NodePosition

include(joinpath(".", "forcedirected.jl"))

include(joinpath(".", "recipes.jl"))

end # module
