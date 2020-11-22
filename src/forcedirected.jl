"""
    ForceDirectedLayout

The fields are, in order:

- `move`, a tuple to specify whether moves on the x and y axes are allowed
- `k`, a tuple giving the strength of attraction and repulsion
- `gravity`, the strength of attraction towards the center, set to `0.0` as a default

The spring coefficient is used to decide how strongly nodes will *attract* or
*repel* one another, as a function of their distance Δ. Specifically, the
default is that connected nodes will attract one another proportionally to Δ²/k,
and all nodes will repel one another proportionally to k²/Δ.
"""
struct ForceDirectedLayout
    move::Tuple{Bool,Bool}
    k::Tuple{Float64,Float64}
    gravity::Float64
end

"""
    ForceDirectedLayout(;k::Float64=0.2, gravity::Float64=0.75)

Creates a default force directed layout where nodes move in both directions, are
attracted to the center, with a spring coefficient of 0.2. The spring
coefficient can be changed with the `k` argument, and the attachment to the
center can be changed with the `center` keyword. Note that if the network as
multiple disconnected components, `center=false` can lead to strange results.
"""
ForceDirectedLayout(;k::Float64=0.2, gravity::Float64=0.75) = ForceDirectedLayout((true,true), (k,k), gravity)
ForceDirectedLayout(;ka::Float64=0.2, kr::Float64=0.2, gravity::Float64=0.75) = ForceDirectedLayout((true,true), (ka,kr), gravity)
ForceDirectedLayout(k::Float64) = ForceDirectedLayout(k=(k,k))

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
    if LA.move[1]
        n1.vx = n1.vx + δx/Δ*fr(Δ)
        n2.vx = n2.vx - δx/Δ*fr(Δ)
    end
    if LA.move[2] # Do we need to move y here?
        n1.vy = n1.vy + δy/Δ*fr(Δ)
        n2.vy = n2.vy - δy/Δ*fr(Δ)
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
    if LA.move[1]
        n1.vx = n1.vx - δx/Δ*fa(Δ)
        n2.vx = n2.vx + δx/Δ*fa(Δ)
    end
    if LA.move[2]
        n1.vy = n1.vy - δy/Δ*fa(Δ)
        n2.vy = n2.vy + δy/Δ*fa(Δ)
    end
end

"""
Update the position of a node
"""
function update!(n::NodePosition) where {T <: ForceDirectedLayout}
    Δ = sqrt(n.vx^2.0+n.vy^2.0)
    Δ = Δ == 0.0 ? 0.0001 : Δ
    n.x += n.vx/Δ*min(Δ, 0.01)
    n.y += n.vy/Δ*min(Δ, 0.01)
    stop!(n)
end

"""
    position!(LA::ForceDirectedLayout, L::Dict{K,NodePosition}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork} where {K}

One iteration of the force-directed layout routine. Because these algorithms can
take some time to converge, it may be useful to stop every 500 iterations to
have a look at the results.
"""
function position!(LA::ForceDirectedLayout, L::Dict{K,NodePosition}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork} where {K}
    fa(x) = (x^2.0)/LA.ka # Default attraction function
    fr(x) = (LA.kr^2.0)/x # Default repulsion function
    
    for (i, s1) in enumerate(species(N))
        for (j, s2) in enumerate(species(N))
            if j > i
                repel!(LA, L[s1], L[s2], fr)
            end
        end
    end
    
    for int in interactions(N)
        attract!(LA, L[int.from], L[int.to], fa)
    end
    
    if LA.gravity > 0.0
        plotcenter = NodePosition(0.0, 0.0, 0.0, 0.0)
        for s in species(N)
            attract!(LA, L[s], plotcenter, (x) -> LA.gravity*fa(x))
        end
    end
    
    for s in species(N)
        update!(L[s])
    end
    
end
