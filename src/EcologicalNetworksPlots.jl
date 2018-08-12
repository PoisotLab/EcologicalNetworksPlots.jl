module EcologicalNetworksPlots

using EcologicalNetworks
using Plots
using RecipesBase

# Various layout manipulation functions
include(joinpath(".", "utilities.jl"))

# Types for layout positioning
include(joinpath(".", "types.jl"))
export NodePosition

# Force-directed layout
include(joinpath(".", "forcedirected.jl"))

# Recipes
include(joinpath(".", "recipes.jl"))

end # module
