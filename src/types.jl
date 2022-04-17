"""
    NodePosition

Represents the position and velocity of a node during force directed layouts. The
fields are `x` and `y` for position, and `vx` and `vy` for their relative
velocity.
"""
Base.@kwdef mutable struct NodePosition
    x::Float64 = 0.0
    y::Float64 = 0.0
    vx::Float64 = 0.0
    vy::Float64 = 0.0
    r::Number = 0.0
    k::Number = 0.0
end

"""
    BipartiteInitialLayout

This type is used to generate an initial bipartite layout, where the nodes are
placed on two levels, but their horizontal position is random.
"""
struct BipartiteInitialLayout end

"""
    FoodwebInitialLayout

This type is used to generate an initial layout, where the nodes are
placed on their trophic levels, but their horizontal position is random.
"""
struct FoodwebInitialLayout end


"""
    RandomInitialLayout

This type is used to generate an initial layout, where the nodes are
placed at random within the unit circle.
"""
struct RandomInitialLayout end

"""
    CircularInitialLayout

This type is used to generate an initial layout, where the nodes are
placed at random along a circle.
"""
struct CircularInitialLayout end

"""
    UnravelledInitialLayout

This type is used to generate an initial unravelled layout, where the nodes are
sorted vertically by trophic level, and horizontally by omnivory index. Credit
for this approach goes to @gvdr -- https://github.com/gvdr/unravel#unravel
"""
struct UnravelledInitialLayout end
