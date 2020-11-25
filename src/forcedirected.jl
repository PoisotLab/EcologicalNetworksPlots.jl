"""
    ForceDirectedLayout

The fields are, in order:

- `move`, a tuple to specify whether moves on the x and y axes are allowed
- `k`, a tuple (kₐ,kᵣ) giving the strength of attraction and repulsion
- `exponents`, a tuple (a,b,c,d) giving the exponents for the attraction and
  repulsion functions
- `gravity`, the strength of attraction towards the center, set to `0.0` as a
  default

The various coefficients are used to decide how strongly nodes will *attract* or
*repel* one another, as a function of their distance Δ. Specifically, the
default is that connected nodes will attract one another proportionally to
(kₐᵃ)*(Δᵇ), with a=-1 and b=2, and all nodes repel one another proportionally to
(kᵣᶜ)*(Δᵈ) with c=2 and d=1.

The parameterization for the Fruchterman-Rheingold layout is the default one,
particularly if kₐ=kᵣ. The Force Atlas 2 parameters are kₐ=1 (or a=0), kᵣ set to
any value, b=1, c=1, d=-2. Note that in all cases, the gravity is a multiplying
constant of the resulting attraction force, so it will also be sensitive to
these choices. The `FruchtermanRheingold` and `ForceAtlas2` functions will
return a `ForceDirectedLayout` -- as this object is mutable, you can replace the
exponents at any time.
"""
mutable struct ForceDirectedLayout
    move::Tuple{Bool,Bool}
    k::Tuple{Float64,Float64}
    exponents::Tuple{Float64,Float64,Float64,Float64}
    gravity::Float64
end

"""
    ForceDirectedLayout(ka::Float64, kr::Float64; gravity::Float64=0.75)

TODO
"""
ForceDirectedLayout(ka::Float64, kr::Float64; gravity::Float64=0.75) = ForceDirectedLayout((true,true), (ka,kr), (-1.0, 2.0, 2.0, 1.0), gravity)

"""
TODO
"""
FruchtermanRheingold(k::Float64; gravity::Float64=0.75) = ForceDirectedLayout(ka=k, kr=a; gravity=gravity)

"""
TODO
"""
ForceAtlas2(k::Float64; gravity::Float64=0.75) = ForceDirectedLayout((true, true), (1.0, k), (0.0, 1.0, 1.0, -2.0), gravity)

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
    if LA.move[2]
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
    a,b,c,d = LA.exponents
    ka, kr = LA.k
    fa(x) = (x^a)*(LA.ka^b) # Default attraction function
    fr(x) = (x^b)*(LA.kr^d) # Default repulsion function
    
    plotcenter = NodePosition(0.0, 0.0, 0.0, 0.0)

    for (i, s1) in enumerate(species(N))
        attract!(LA, L[s1], plotcenter, (x) -> LA.gravity*fa(x))
        for (j, s2) in enumerate(species(N))
            if j > i
                repel!(LA, L[s1], L[s2], fr)
            end
        end
    end
    
    for int in interactions(N)
        attract!(LA, L[int.from], L[int.to], fa)
    end

    for s in species(N)
        update!(L[s])
    end
    
end
