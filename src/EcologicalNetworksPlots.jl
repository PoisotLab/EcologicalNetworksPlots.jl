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
export ForceDirectedLayout

# Static layouts
include(joinpath(".", "static.jl"))
export NestedBipartiteLayout

# Recipes
include(joinpath(".", "recipes.jl"))

# Position function
export position!

end # module
