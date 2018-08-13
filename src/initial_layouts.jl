"""
Random disposition of nodes
"""
function initial_random_layout(N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  return Dict([s => NodePosition(rand(), rand(), 0.0, 0.0) for s in species(N)])
end

"""
Random disposition of nodes on two levels for bipartite networks
"""
function initial_bipartite_layout(N::T) where {T <: EcologicalNetworks.AbstractBipartiteNetwork}
  level = NodePosition[]
  for (i, s) in enumerate(species(N))
    this_level = s ∈ species(N; dims=1) ? 1.0 : 0.0
    push!(level, NodePosition(rand(), this_level, 0.0, 0.0))
  end
  return Dict(zip(species(N), level))
end
