"""
Random disposition of nodes
"""
function initial(::Type{RandomInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  return Dict([s => NodePosition() for s in species(N)])
end

"""
Random disposition of nodes on two levels for bipartite networks
"""
function initial(::Type{BipartiteInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractBipartiteNetwork}
  level = NodePosition[]
  for (i, s) in enumerate(species(N))
    this_level = s ∈ species(N; dims=1) ? 1.0 : 0.0
    push!(level, NodePosition(rand(), this_level, 0.0, 0.0))
  end
  return Dict(zip(species(N), level))
end

"""
Random disposition of nodes on trophic levels for food webs
"""
function initial(::Type{FoodwebInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractUnipartiteNetwork}
  level = NodePosition[]
  tl = fractional_trophic_level(N)
  for (i, s) in enumerate(species(N))
    push!(level, NodePosition(rand(), tl[s], 0.0, 0.0))
  end
  return Dict(zip(species(N), level))
end

"""
Random disposition of nodes on a circle
"""
function initial(::Type{CircularInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  level = NodePosition[]
  n = richness(N)
  for (i, s) in enumerate(species(N))
    θ = 2i * π/n
    x, y = cos(θ), sin(θ)
    push!(level, NodePosition(x, y, i))
  end
  return Dict(zip(species(N), level))
end
