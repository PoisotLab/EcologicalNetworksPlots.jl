module EcologicalNetworksPlots

using EcologicalNetworks
using RecipesBase
using StatsBase

# Various layout manipulation functions
include(joinpath(".", "utilities.jl"))
export finish_layout!, distribute_layout!

# Types for layout positioning
include(joinpath(".", "types.jl"))
export NodePosition
export RandomInitialLayout, BipartiteInitialLayout, FoodwebInitialLayout

# Starting points
include(joinpath(".", "initial_layouts.jl"))
export initial

# Force-directed layout
include(joinpath(".", "forcedirected.jl"))
export graph_layout!, bipartite_layout!, foodweb_layout!

# Static layouts
include(joinpath(".", "static.jl"))
export NestedBipartiteLayout
export position!

# Recipes
include(joinpath(".", "recipes.jl"))

end # module
