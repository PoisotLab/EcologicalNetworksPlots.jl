"""
    ForceDirectedLayout

The fields are, in order:

- `move`, a tuple to specify whether moves on the x and y axes are allowed
- `k`, a tuple (kₐ,kᵣ) giving the strength of attraction and repulsion
- `exponents`, a tuple (a,b,c,d) giving the exponents for the attraction and
  repulsion functions
- `gravity`, the strength of attraction towards the center, set to `0.0` as a
  default
- `δ`, a floating point constant regulating the attractive force of interaction
  strength -- when set to its default value of 0.0, all edges have the same
  attraction
- `degree`, a boolean to specificy whether the nodes repel one another according
  to their degree

The various coefficients are used to decide how strongly nodes will *attract* or
*repel* one another, as a function of their distance Δ. Specifically, the
default is that connected nodes will attract one another proportionally to
(Δᵃ)×(kₐᵇ), with a=2 and b=-1, and all nodes repel one another proportionally to
(Δᶜ)×(kᵣᵈ) with c=-1 and d=2.

The parameterization for the Fruchterman-Rheingold layout is the default one,
particularly if kₐ=kᵣ. The Force Atlas 2 parameters are kₐ=1 (or b=0), kᵣ set to
any value, a=1, c=-1, d=1. Note that in all cases, the gravity is a multiplying
constant of the resulting attraction force, so it will also be sensitive to
these choices. The `FruchtermanRheingold` and `ForceAtlas2` functions will
return a `ForceDirectedLayout` -- as this object is mutable, you can replace the
exponents at any time.

The δ parameter is particularly important for probabilistic networks, as these
tend to have *all* their interactions set to non-zero values. As such, setting a
value of δ=1 means that the interactions only attract as much as they are
probable.
"""
mutable struct ForceDirectedLayout
    move::Tuple{Bool,Bool}
    k::Tuple{Float64,Float64}
    exponents::Tuple{Float64,Float64,Float64,Float64}
    gravity::Float64
    δ::Float64
    degree::Bool
end

"""
    ForceDirectedLayout(ka::Float64, kr::Float64; gravity::Float64=0.75)

TODO
"""
ForceDirectedLayout(ka::Float64, kr::Float64; gravity::Float64=0.75) = ForceDirectedLayout((true,true), (ka,kr), (2.0, -1.0, -1.0, 2.0), gravity, 0.0, true)

"""
    FruchtermanRheingold(k::Float64; gravity::Float64=0.75)

The default `ForceDirectedLayout` uses the Fruchterman-Rheingold parameters -
this function is simply here to make the code more explicity, and to use a
"strict" version where kᵣ=kₐ. 
"""
FruchtermanRheingold(k::Float64; gravity::Float64=0.75) = ForceDirectedLayout(k, k; gravity=gravity)

"""
    ForceAtlas2(k::Float64; gravity::Float64=0.75)

In the Force Atlas 2 layout, the attraction is proportional to the distance, and
the repulsion to the inverse of the distance. Note that kₐ in this layout is set
to 1, so kᵣ is the *relative* repulsion.
"""
ForceAtlas2(k::Float64; gravity::Float64=0.75) = ForceDirectedLayout((true, true), (1.0, k), (1.0, 0.0, -1.0, 1.0), gravity, 0.0, true)

"""
    SpringElectric(k::Float64; gravity::Float64=0.75)

In the spring electric layout, attraction is proportional to distance, and
repulsion to the inverse of the distance squared.
"""
SpringElectric(k::Float64; gravity::Float64=0.75) = ForceDirectedLayout((true,true), (k, k), (1.0, 1.0, -2.0, 1.0), gravity, 0.0, true)

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
        n1.vx += δx/Δ*fr(Δ)
        n2.vx -= δx/Δ*fr(Δ)
    end
    if LA.move[2]
        n1.vy += δy/Δ*fr(Δ)
        n2.vy -= δy/Δ*fr(Δ)
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
        n1.vx -= δx/Δ*fa(Δ)
        n2.vx += δx/Δ*fa(Δ)
    end
    if LA.move[2]
        n1.vy -= δy/Δ*fa(Δ)
        n2.vy += δy/Δ*fa(Δ)
    end
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
    position!(LA::ForceDirectedLayout, L::Dict{K,NodePosition}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork} where {K}

One iteration of the force-directed layout routine. Because these algorithms can
take some time to converge, it may be useful to stop every 500 iterations to
have a look at the results.
"""
function position!(LA::ForceDirectedLayout, L::Dict{K,NodePosition}, N::T) where {T <: EcologicalNetworks.AbstractEcologicalNetwork} where {K}
    
    degdistr = degree(N)

    # Exponents and forces - the attraction and repulsion functions are
    # (Δᵃ)×(kₐᵇ) and (Δᶜ)×(kᵣᵈ)
    a,b,c,d = LA.exponents
    ka, kr = LA.k
    fa(x) = (x^a)*(ka^b)
    fr(x) = (x^c)*(kr^d)
    
    plotcenter = NodePosition(0.0, 0.0, 0.0, 0.0)

    for (i, s1) in enumerate(species(N))
        attract!(LA, L[s1], plotcenter, (x) -> LA.gravity*fa(x))
        for (j, s2) in enumerate(species(N))
            if j > i
                if LA.degree
                    repel!(LA, L[s1], L[s2], (x) -> (degdistr[s1]+1)*(degdistr[s2]+1)*fr(x))
                else
                    repel!(LA, L[s1], L[s2], fr)
                end
            end
        end
    end
    
    for int in interactions(N)
        # We can do Bool^δ and it returns the Bool, so that's tight
        attract!(LA, L[int.from], L[int.to], (x) -> N[int.from, int.to]^LA.δ*fa(x))
    end

    for s in species(N)
        update!(L[s])
    end
    
end
