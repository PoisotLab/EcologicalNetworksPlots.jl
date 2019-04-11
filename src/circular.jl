struct CircularLayout
    radius::Float64
end

CircularLayout() = CircularLayout(1.0)

function angle(n::NodePosition)
    hyp = sqrt(n.x*n.x + n.y*n.y)
    θ = n.x < 0.0 ? π - asin(hyp) : asin(hyp) + 2π
    return θ
end

position!(LA::CircularLayout, L::Dict{K,NodePosition}, N::T) where {T <: AbstractBipartiteNetwork} where {K}
    
end
