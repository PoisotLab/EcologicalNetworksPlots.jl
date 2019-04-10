"""
    ForceDirectedLayout
"""
struct ForceDirectedLayout
    move_x::Bool
    move_y::Bool
    k::Float64
    center::Bool
    height::Float64
end

ForceDirectedLayout() = ForceDirectedLayout(true, true, 0.2, true, 1.0)

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
function repel!(LA::T, n1::NodePosition, n2::NodePosition, fr) where {T <: ForceDirectedLayout}
  δx = n1.x - n2.x
  δy = n1.y - n2.y
  Δ = sqrt(δx^2.0+δy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  if LA.move_x
    n1.vx = n1.vx + δx/Δ*fr(Δ)
    n2.vx = n2.vx - δx/Δ*fr(Δ)
  end
  if LA.move_y # Do we need to move y here?
    n1.vy = n1.vy + δy/Δ*fr(Δ)
    n1.vy = n1.vy - δy/Δ*fr(Δ)
  end
end

"""
Attract two connected nodes
"""
function attract!(LA::T, n1::NodePosition, n2::NodePosition, fa) where {T <: ForceDirectedLayout}
  δx = n1.x - n2.x
  δy = n1.y - n2.y
  Δ = sqrt(δx^2.0+δy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  if LA.move_x
    n1.vx = n1.vx - δx/Δ*fa(Δ)
    n2.vx = n2.vx + δx/Δ*fa(Δ)
  end
  if LA.move_y
    n1.vy = n1.vy - δy/Δ*fa(Δ)
    n2.vy = n2.vy + δy/Δ*fa(Δ)
  end
end

"""
Update the position of a node
"""
function update!(LA::T, n::NodePosition) where {T <: ForceDirectedLayout}
  Δ = sqrt(n.vx^2.0+n.vy^2.0)
  Δ = Δ == 0.0 ? 0.0001 : Δ
  n.x += n.vx/Δ*min(Δ, 0.01)
  n.y += n.vy/Δ*min(Δ, 0.01)
  stop!(n)
end

"""
One iteration of the force-directed layout routine
"""
function position!(LA::ForceDirectedLayout, L::Dict{K,NodePosition}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork} where {K}
  fa(x) = (x*x)/LA.k # Default attraction function
  fr(x) = (LA.k*LA.k)/x # Default repulsion function
  for (i, s1) in enumerate(species(N))
    n1 = L[s1]
    stop!(n1)
    for (j, s2) in enumerate(species(N))
      n2 = L[s2]
      if j != i
        repel!(LA, n1, n2, fr)
      end
    end
  end

  for int in interactions(N)
    n1, n2 = L[int.from], L[int.to]
    attract!(LA, n1, n2, fa)
  end

  if center
    for s in species(N)
      attract!(LA, L[s], NodePosition(0.0, 0.0, 0.0, 0.0), (x) -> 0.8*fa(x))
    end
  end

  for (i,s) in enumerate(species(N))
    update!(LA, L[s])
  end
end
