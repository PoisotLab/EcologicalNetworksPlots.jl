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
function repel_on_both!(pos::Dict{T,NodePosition}, s1::T, s2::T, fr) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  δx = pos[s1].x - pos[s2].x
  δy = pos[s1].y - pos[s2].y
  Δ = sqrt(δx^2.0+δy^2.0)
  pos[s1].vx = pos[s1].vx + δx/Δ*fr(Δ)
  pos[s1].vy = pos[s1].vy + δy/Δ*fr(Δ)
end

function repel_on_x!(pos::Dict{T,NodePosition}, s1::T, s2::T, fr) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  δx = pos[s1].x - pos[s2].x
  Δ = sqrt(δx^2.0)
  if pos[s1].y == pos[s2].y
    pos[s1].vx = pos[s1].vx + δx/Δ*fr(Δ)
  end
end

"""
Attract two connected nodes
"""
function attract_on_both!(pos::Dict{T,NodePosition}, s1::T, s2::T, fa) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  δx = pos[s1].x - pos[s2].x
  δy = pos[s1].y - pos[s2].y
  Δ = sqrt(δx^2.0+δy^2.0)
  pos[s1].vx = pos[s1].vx - δx/Δ*fa(Δ)
  pos[s1].vy = pos[s1].vy - δy/Δ*fa(Δ)
  pos[s2].vx = pos[s2].vx + δx/Δ*fa(Δ)
  pos[s2].vy = pos[s2].vy + δy/Δ*fa(Δ)
end

"""
Attract two connected nodes
"""
function attract_on_x!(pos::Dict{T,NodePosition}, s1::T, s2::T, fa) where {T <: EcologicalNetworks.AllowedSpeciesTypes}
  δx = pos[s1].x - pos[s2].x
  δy = 0.0
  Δ = sqrt(δx^2.0+δy^2.0)
  pos[s1].vx = pos[s1].vx - δx/Δ*fa(Δ)
  pos[s2].vx = pos[s2].vx + δx/Δ*fa(Δ)
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
function general_forcedirected_layout!(N::T, pos::Dict{K,NodePosition}; k::Float64=0.2, repel::Function=repel_on_both!, attract::Function=attract_on_both!) where {T <: EcologicalNetworks.AbstractEcologicalNetwork, K <:EcologicalNetworks.AllowedSpeciesTypes}
  fa(x) = (x*x)/k # Default attraction function
  fr(x) = (k*k)/x # Default repulsion function
  for (i, s1) in enumerate(species(N))
    stop!(pos[s1])
    for (j, s2) in enumerate(species(N))
      if j != i
        repel(pos, s1, s2, fr)
      end
    end
  end

  for int in interactions(N)
    s1, s2 = int.from, int.to
    attract(pos, s1, s2, fa)
  end

  for (i,s) in enumerate(species(N))
    update!(pos, s)
  end
end

function graph_layout!(N::T, pos::Dict{K,NodePosition}; k::Float64=0.2) where {T <: EcologicalNetworks.AbstractEcologicalNetwork, K <:EcologicalNetworks.AllowedSpeciesTypes}
  general_forcedirected_layout!(N, pos; k=k, repel=repel_on_both!, attract=attract_on_both!)
end

function bipartite_layout!(N::T, pos::Dict{K,NodePosition}; k::Float64=0.2) where {T <: EcologicalNetworks.AbstractBipartiteNetwork, K <:EcologicalNetworks.AllowedSpeciesTypes}
  general_forcedirected_layout!(N, pos; k=k, repel=repel_on_x!, attract=attract_on_x!)
end
