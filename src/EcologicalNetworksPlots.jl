module EcologicalNetworksPlots

using EcologicalNetworks
using RecipesBase
using StatsBase
using Statistics
using SparseArrays

# Various layout manipulation functions
include(joinpath(".", "utilities.jl"))
export finish_layout!, distribute_layout!

# Types for layout positioning
include(joinpath(".", "types.jl"))
export NodePosition
export RandomInitialLayout, FoodwebInitialLayout
export BipartiteInitialLayout, CircularInitialLayout
export UnravelledInitialLayout

# Starting points
include(joinpath(".", "initial_layouts.jl"))
export initial

# Force-directed layout
include(joinpath(".", "forcedirected.jl"))
export ForceDirectedLayout
export FruchtermanRheingold, ForceAtlas2, SpringElectric

# Static layouts
include(joinpath(".", "static.jl"))
export NestedBipartiteLayout
export UnravelledLayout

# Circular layouts
include(joinpath(".", "circular.jl"))
export CircularLayout

# Recipes
include(joinpath(".", "recipes.jl"))

# Position function
export position!

end # module
