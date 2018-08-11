# Force directed layout -- attempt 1

using EcologicalNetworks
using EcologicalNetworksPlots

N = simplify(nz_stream_foodweb()[1])
I0 = EcologicalNetworksPlots.initial_forcedirectedlayout(N)
[EcologicalNetworksPlots.forcedirectedlayout!(N, I0) for i in 1:600]

@recipe function f(N::T, L::Dict{K,NodePosition}) where {T <: AbstractEcologicalNetwork, K <: AllowedSpeciesTypes}

    # Node positions
    X = [L[s].x for s in species(N)]
    Y = [L[s].y for s in species(N)]

    @info X
    @info Y

    framestyle --> :none
    legend --> false
    markersize --> 10

    for int in N
        y = [L[int.from].y, L[int.to].y]
        x = [L[int.from].x, L[int.to].x]
        @series begin
            seriestype := :line
            linecolor --> :darkgrey
            x, y
        end
    end

    @series begin
        seriestype := :scatter
        color --> :white
        X, Y
    end

end

@recipe function f(N::T, L::Dict{K,NodePosition}, f::Function) where {T <: AbstractEcologicalNetwork, K <: AllowedSpeciesTypes}

    # Node positions
    X = [L[s].x for s in species(N)]
    Y = [L[s].y for s in species(N)]

    @info X
    @info Y

    framestyle --> :none
    legend --> false
    markersize --> 10
    aspectratio --> 1

    if typeof(N) <: QuantitativeNetwork
        str_max = maximum(N.A)
        str_min = minimum(filter(x -> x > 0.0, N.A))
    end

    for int in N
        y = [L[int.from].y, L[int.to].y]
        x = [L[int.from].x, L[int.to].x]
        @series begin
            seriestype := :line
            linecolor --> :darkgrey
            if typeof(N) <: QuantitativeNetwork
                linewidth --> 2.0+((int.strength / str_max)-(str_min/str_max))*3.0
            end
            if typeof(N) <: ProbabilisticNetwork
                alpha --> int.probability
            end
            linewidth --> 3
            x, y
        end
    end

    ms = [f(N)[s] for s in species(N)]

    @series begin
        seriestype := :scatter
        color --> :white
        markersize := ms
        X, Y
    end

end

plot(N, I0)
plot(N, I0, degree, msc=:teal, mc=:white, lc=:teal, msw=4, size=(2000,2000))

N = nz_stream_foodweb()[1:3]
U = simplify(reduce(union, N))
I0 = EcologicalNetworksPlots.initial_forcedirectedlayout(U)
[EcologicalNetworksPlots.forcedirectedlayout!(U, I0; k=5.0) for i in 1:2600]

xl = (-30,30)
yl = (-30,30)
pn0 = plot(U, I0, msc=:black, lc=:black)
pn1 = plot(simplify(N[1]), I0, msc=:orange, lc=:orange)
pn2 = plot(simplify(N[2]), I0, msc=:purple, lc=:purple)
pn3 = plot(simplify(N[3]), I0, msc=:blue, lc=:blue)
for p in [pn0, pn1, pn2, pn3]
    xaxis!(p, xl)
    yaxis!(p, yl)
end

plot(pn0, pn1, pn2, pn3, ms=3, frame=:none)
