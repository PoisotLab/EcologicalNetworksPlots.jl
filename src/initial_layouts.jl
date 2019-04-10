"""
Random disposition of nodes
"""
function initial(::Type{RandomInitialLayout}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  return Dict([s => NodePosition(rand(), rand(), 0.0, 0.0) for s in species(N)])
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
