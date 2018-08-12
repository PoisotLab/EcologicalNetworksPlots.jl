# Force directed layout -- attempt 1

using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
using RecipesBase

@recipe function f(network::T, layout::Dict{K,NodePosition}; nodesize::Union{Dict{K,Any},Nothing}=nothing, nodefill::Union{Function,Nothing}=nothing) where {T <: AbstractEcologicalNetwork, K <: AllowedSpeciesTypes}

    # Node positions
    X = [layout[s].x for s in species(network)]
    Y = [layout[s].y for s in species(network)]

    # Default values
    framestyle --> :none
    legend --> false
    aspectratio --> 1

    if typeof(network) <: QuantitativeNetwork
        int_range = (minimum(filter(x -> x > 0.0, network.A)), maximum(network.A))
    end

    for interaction in network
        y = [layout[interaction.from].y, layout[interaction.to].y]
        x = [layout[interaction.from].x, layout[interaction.to].x]
        @series begin
            seriestype := :line
            linecolor --> :darkgrey
            if typeof(network) <: QuantitativeNetwork
                linewidth --> EcologicalNetworksPlots.scale_value(interaction.strength, int_range, (0.5, 3.5))
            end
            if typeof(network) <: ProbabilisticNetwork
                alpha --> interaction.probability
            end
            x, y
        end
    end


    @series begin

        if nodesize !== nothing
            nsi_range = (minimum(values(nodesize)), maximum(values(nodesize)))
            markersize := [EcologicalNetworksPlots.scale_value(nodesize[s], nsi_range, (2,8)) for s in species(network)]
        end

        if nodefill !== nothing
            nfi_range = (minimum(values(nodefill)), maximum(values(nodefill)))
            markerz := [EcologicalNetworksPlots.scale_value(nodefill[s], nfi_range, (0,1)) for s in species(network)]
        end

        seriestype := :scatter
        color --> :white
        X, Y
    end

end

U = web_of_life("A_HP_010")
K = convert(BinaryNetwork, U)
P = null2(K)
I0 = EcologicalNetworksPlots.initial_forcedirectedlayout(U)
[EcologicalNetworksPlots.forcedirectedlayout!(U, I0) for i in 1:600]

Npart = N |> lp |> (x) -> brim(x...)

plot(U, I0; nodesize=degree(K), nodefill=Npart[2], markercolor=:isolum, size=(500,500))
savefig("network.png")
plot(U, I0; nodesize=degree(K), markercolor=:isolum)
plot(U, I0)



plot(U, I0, degree, msc=:teal, mc=:white, lc=:teal)
plot(N, I0, degree, msc=:teal, mc=:white, lc=:teal)
plot(P, I0, degree, msc=:teal, mc=:white, lc=:teal)
