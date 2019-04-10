"""
    NodePosition

Represents the position and velocity of a node during force directed layouts. The
fields are `x` and `y` for position, and `vx` and `vy` for their relative
velocity.
"""
mutable struct NodePosition
    x::Float64
    y::Float64
    vx::Float64
    vy::Float64
end

struct BipartiteInitialLayout end
struct FoodwebInitialLayout end
struct RandomInitialLayout end
