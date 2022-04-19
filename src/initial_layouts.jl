"""
    initial(::Type{RandomInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}

Random disposition of nodes in a circle. This is a good starting point for any
force-directed layout. The circle is scaled so that its radius is twice the
square root of the network richness, which helps most layouts converge faster.
"""
function initial(::Type{RandomInitialLayout}, N::T) where {T<:EcologicalNetworks.AbstractEcologicalNetwork}
    k = degree(N)
    L = Dict([s => NodePosition(x=rand(), y=rand(), degree=float(k[s])) for s in species(N)])
    _adj = 2sqrt(richness(N))
    for s in species(N)
        L[s].x *= _adj
        L[s].y *= _adj
    end
    return L
end

"""
    initial(::Type{BipartiteInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractBipartiteNetwork}

Random disposition of nodes on two levels for bipartite networks.
"""
function initial(::Type{BipartiteInitialLayout}, N::T) where {T<:EcologicalNetworks.AbstractBipartiteNetwork}
    level = NodePosition[]
    k = degree(N)
    for s in species(N)
        this_level = s ∈ species(N; dims=1) ? 1.0 : 0.0
        push!(level, NodePosition(x=rand(), y=this_level, degree=k[s]))
    end
    return Dict(zip(species(N), level))
end

"""
    initial(::Type{FoodwebInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractUnipartiteNetwork}

Random disposition of nodes on trophic levels for food webs. Note that the
continuous trophic level is used, but the layout can be modified afterwards to
use another measure of trophic rank.
"""
function initial(::Type{FoodwebInitialLayout}, N::T) where {T<:EcologicalNetworks.AbstractUnipartiteNetwork}
    L = initial(RandomInitialLayout, N)
    tl = trophic_level(N)
    for s in species(N)
        L[s].y = tl[s]
    end
    return L
end

"""
    initial(::Type{CircularInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}

Random disposition of nodes on a circle. This is the starting point for
circle-based layouts.
"""
function initial(::Type{CircularInitialLayout}, N::T) where {T<:EcologicalNetworks.AbstractEcologicalNetwork}
    level = NodePosition[]
    k = degree(N)
    n = richness(N)
    for (i, s) in enumerate(species(N))
        θ = 2i * π / n
        x, y = cos(θ), sin(θ)
        push!(level, NodePosition(x=x, y=y, r=i, degree=k[s]))
    end
    return Dict(zip(species(N), level))
end

"""
    initial(::Type{UnravelledInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractUnipartiteNetwork}

Unravelled disposition of nodes on trophic levels for food webs, where the x
axis is the omnivory index. Note that the *fractional* trophic level is used,
but the layout can be modified afterwards to use the continuous levels. See the
documentation for `UnravelledLayout` to see how.
"""
function initial(::Type{UnravelledInitialLayout}, N::T) where {T<:EcologicalNetworks.AbstractUnipartiteNetwork}
    layout = Dict([s => NodePosition() for s in species(N)])
    tl = fractional_trophic_level(N)
    oi = omnivory(N)
    for s in species(N)
        layout[s].x = float(oi[s])
        layout[s].y = float(tl[s])
    end
    return layout
end
