# Force directed layout -- attempt 1

N = nz_stream_foodweb()[1]
I0 = initial_forcedirectedlayout(N)
forcedirectedlayout!(N, I0)

@recipe function f(N::T, L::Dict{K,NodePosition}) where {T <: AbstractEcologicalNetwork, K <: AllowedSpeciesTypes}

    # Node positions
    X = [L[s].x for s in species(N)]
    Y = [L[s].x for s in species(N)]

    @series begin
        seriestype := scatter
        x, y
    end

end
