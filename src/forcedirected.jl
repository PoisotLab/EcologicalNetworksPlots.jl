"""
Stops the movement of a node position.
"""
function stop!(n::NodePosition)
  n.vx = 0.0
  n.vy = 0.0
end

"""
Repel two nodes
"""
function repel_on_both!(n1::NodePosition, n2::NodePosition, fr)
  δx = n1.x - n2.x
  δy = n1.y - n2.y
  Δ = sqrt(δx^2.0+δy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  n1.vx = n1.vx + δx/Δ*fr(Δ)
  n1.vy = n1.vy + δy/Δ*fr(Δ)
end

function repel_on_x!(n1::NodePosition, n2::NodePosition, fr)
  δx = n1.x - n2.x
  Δ = sqrt(δx^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  if n1.y == n2.y
    n1.vx = n1.vx + δx/Δ*fr(Δ)
  end
end

"""
Attract two connected nodes
"""
function attract_on_both!(n1::NodePosition, n2::NodePosition, fa)
  δx = n1.x - n2.x
  δy = n1.y - n2.y
  Δ = sqrt(δx^2.0+δy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  n1.vx = n1.vx - δx/Δ*fa(Δ)
  n1.vy = n1.vy - δy/Δ*fa(Δ)
  n2.vx = n2.vx + δx/Δ*fa(Δ)
  n2.vy = n2.vy + δy/Δ*fa(Δ)
end

"""
Attract two connected nodes
"""
function attract_on_x!(n1::NodePosition, n2::NodePosition, fa)
  δx = n1.x - n2.x
  δy = 0.0
  Δ = sqrt(δx^2.0+δy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  n1.vx = n1.vx - δx/Δ*fa(Δ)
  n2.vx = n2.vx + δx/Δ*fa(Δ)
end

"""
Update the position of a node
"""
function update!(n::NodePosition)
  Δ = sqrt(n.vx^2.0+n.vy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  n.x += n.vx/Δ*min(Δ, 0.01)
  n.y += n.vy/Δ*min(Δ, 0.01)
  stop!(n)
end

"""
One iteration of the force-directed layout routine
"""
function general_forcedirected_layout!(N::T, pos::Dict{Any,NodePosition}; k::Float64=0.2, repel::Function=repel_on_both!, attract::Function=attract_on_both!, center::Bool=true) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  fa(x) = (x*x)/k # Default attraction function
  fr(x) = (k*k)/x # Default repulsion function
  for (i, s1) in enumerate(species(N))
    n1 = pos[s1]
    stop!(n1)
    for (j, s2) in enumerate(species(N))
      n2 = pos[s2]
      if j != i
        repel(n1, n2, fr)
      end
    end
  end

  for int in interactions(N)
    n1, n2 = pos[int.from], pos[int.to]
    attract(n1, n2, fa)
  end

  if center
    for s in species(N)
      attract(pos[s], NodePosition(0.0, 0.0, 0.0, 0.0), (x) -> 0.8*fa(x))
    end
  end

  for (i,s) in enumerate(species(N))
    update!(pos[s])
  end
end

"""
Graph
"""
function graph_layout!(N::T, pos::Dict{Any,NodePosition}; k::Float64=0.2, center::Bool=true) where {T <: EcologicalNetworks.AbstractEcologicalNetwork}
  general_forcedirected_layout!(N, pos; k=k, repel=repel_on_both!, attract=attract_on_both!, center=center)
end

"""
Bipartite
"""
function bipartite_layout!(N::T, pos::Dict{Any,NodePosition}; k::Float64=0.2, center::Bool=true) where {T <: EcologicalNetworks.AbstractBipartiteNetwork}
  general_forcedirected_layout!(N, pos; k=k, repel=repel_on_x!, attract=attract_on_x!, center=center)
end

"""
Foodweb
"""
function foodweb_layout!(N::T, pos::Dict{Any,NodePosition}; k::Float64=0.2, center::Bool=true) where {T <: EcologicalNetworks.AbstractUnipartiteNetwork}
  general_forcedirected_layout!(N, pos; k=k, repel=repel_on_x!, attract=attract_on_x!, center=center)
end
