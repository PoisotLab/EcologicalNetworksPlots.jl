"""
Stops the movement of a node position.
"""
function stop!(p::NodePosition)
  p.vx = 0.0
  p.vy = 0.0
end

"""
Repel two nodes
"""
function repel!(pos::Dict{T,NodePosition}, s1::T, s2::T, fr) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  δx = pos[s1].x - pos[s2].x
  δy = pos[s1].y - pos[s2].y
  Δ = sqrt(δx^2.0+δy^2.0)
  pos[s1].vx = pos[s1].vx + δx/Δ*fr(Δ)
  pos[s1].vy = pos[s1].vy + δy/Δ*fr(Δ)
end

"""
Attract two connected nodes
"""
function attract!(pos::Dict{T,NodePosition}, s1::T, s2::T, fa) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  δx = pos[s1].x - pos[s2].x
  δy = pos[s1].y - pos[s2].y
  Δ = sqrt(δx^2.0+δy^2.0)
  pos[s1].vx = pos[s1].vx - δx/Δ*fa(Δ)
  pos[s1].vy = pos[s1].vy - δy/Δ*fa(Δ)
  pos[s2].vx = pos[s2].vx + δx/Δ*fa(Δ)
  pos[s2].vy = pos[s2].vy + δy/Δ*fa(Δ)
end

"""
Update the position of a node
"""
function update!(pos::Dict{T,NodePosition}, s::T) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  Δ = sqrt(pos[s].vx^2.0+pos[s].vy^2.0)
  pos[s].x += pos[s].vx/Δ*min(Δ, 0.01)
  pos[s].y += pos[s].vy/Δ*min(Δ, 0.01)
  stop!(pos[s])
end

"""
One iteration of the force-directed layout routine
"""
function forcedirectedlayout!(N::T, pos::Dict{K,NodePosition}; k::Float64=0.2) where {T <: EcologicalNetworks.AbstractEcologicalNetwork, K <:EcologicalNetworks.AllowedSpeciesTypes}
  fa(x) = (x*x)/k # Default attraction function
  fr(x) = (k*k)/x # Default repulsion function
  for (i, s1) in enumerate(species(N))
    stop!(pos[s1])
    for (j, s2) in enumerate(species(N))
      if j != i
        repel!(pos, s1, s2, fr)
      end
    end
  end

  for int in interactions(N)
    s1, s2 = int.from, int.to
    attract!(pos, s1, s2, fa)
  end

  for (i,s) in enumerate(species(N))
    update!(pos, s)
  end
end

"""
Random disposition of nodes
"""
function initial_forcedirectedlayout(N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  return Dict([s => NodePosition(rand(), rand(), 0.0, 0.0) for s in species(N)])
end
