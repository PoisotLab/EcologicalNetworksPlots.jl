struct CircularLayout
    radius::Float64
end

CircularLayout() = CircularLayout(1.0)

function angle(n::NodePosition)
    hyp = sqrt(n.x*n.x + n.y*n.y)
    θ = n.x < 0.0 ? π - asin(hyp) : asin(hyp) + 2π
    return θ
end

position!(LA::CircularLayout, L::Dict{K,NodePosition}, N::T) where {T <: AbstractEcologicalNetwork} where {K}
    S = richness(N)
    for (i, n1) in enumerate(species(N))
        if i < S
            n = L[n1]
            θ = n.r*2π/S
            sx, sy = cos(θ), sin(θ)
            nei = Set{last(eltype(N))}[]
            if n1 ∈ species(N; dims=2)
                nei = union(nei, N[:,n1])
            end
            if n1 ∈ species(N; dims=1)
                nei = union(nei, N[n1,:])
            end
        end
    end
end
