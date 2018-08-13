module EcologicalNetworksPlots

using EcologicalNetworks
using Plots
using RecipesBase

# Various layout manipulation functions
include(joinpath(".", "utilities.jl"))

# Types for layout positioning
include(joinpath(".", "types.jl"))
export NodePosition

# Starting points
include(joinpath(".", "initial_layouts.jl"))
export initial_random_layout, initial_bipartite_layout

# Force-directed layout
include(joinpath(".", "forcedirected.jl"))
export graph_layout!, bipartite_layout!

# Recipes
include(joinpath(".", "recipes.jl"))

end # module
