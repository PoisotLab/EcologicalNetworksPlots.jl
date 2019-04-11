struct CircularLayout
    radius::Float64
end

CircularLayout() = CircularLayout(1.0)

function angle(x, y)
    hyp = sqrt(x*x + y*y)
    θ = x < 0.0 ? π - asin(hyp) : asin(hyp) + 2π
    return θ
end

position!(LA::CircularLayout, L::Dict{K,NodePosition}, N::T) where {T <: AbstractEcologicalNetwork} where {K}
    S = richness(N)
    Θ = Dict([s => angle(L[s]) for s in species(N)])
    for (i, n1) in enumerate(species(N))
        θ = L[n1].r*2π/S
        sx, sy = cos(θ), sin(θ)
        nei = Set{last(eltype(N))}[]
        if n1 ∈ species(N; dims=2)
            nei = union(nei, N[:,n1])
        end
        if n1 ∈ species(N; dims=1)
            nei = union(nei, N[n1,:])
        end
        for (j, n2) in nei
            θ2 = L[n2].r*2π/S
            sx = sx + cos(θ2)
            sy = sy + sin(θ2)
        end
        Θ[n1] = mean(angle(sx, sy))
    end
    @info Θ
end
