@recipe function f(network::T) where {T<:AbstractEcologicalNetwork}
    if plotattributes[:seriestype] == :heatmap
        adjacency(network)
    end
end

@recipe function f(
    layout::Dict{K,NodePosition},
    network::T;
    nodesize=nothing,
    nodefill=nothing,
    bipartite=false,
) where {T<:AbstractEcologicalNetwork} where {K}

    # Node positions
    X = [layout[s].x for s in species(network)]
    Y = [layout[s].y for s in species(network)]

    # Default values
    framestyle --> :none
    legend --> false

    if typeof(network) <: QuantitativeNetwork
        int_range = extrema(network.edges.nzval)
    end

    if get(plotattributes, :seriestype, :plot) == :plot
        for interaction in network
            y = [layout[interaction.from].y, layout[interaction.to].y]
            x = [layout[interaction.from].x, layout[interaction.to].x]
            @series begin
                seriestype := :line
                linecolor --> :darkgrey
                if typeof(network) <: QuantitativeNetwork
                    linewidth --> EcologicalNetworksPlots._scale_value(
                        interaction.strength, int_range, (0.5, 3.5)
                    )
                end
                if typeof(network) <: ProbabilisticNetwork
                    seriesalpha --> interaction.probability
                end
                x, y
            end
        end
    end

    if get(plotattributes, :seriestype, :plot) == :scatter
        @series begin
            if nodesize !== nothing
                nsi_range = (minimum(values(nodesize)), maximum(values(nodesize)))
                markersize := [
                    EcologicalNetworksPlots._scale_value(nodesize[s], nsi_range, (2, 8)) for
                    s in species(network)
                ]
            end

            if nodefill !== nothing
                nfi_range = (minimum(values(nodefill)), maximum(values(nodefill)))
                marker_z := [
                    EcologicalNetworksPlots._scale_value(nodefill[s], nfi_range, (0, 1)) for
                    s in species(network)
                ]
            end

            if bipartite
                m_shape = Symbol[]
                for (i, s) in enumerate(species(network))
                    this_mshape = s ∈ species(network; dims=1) ? :dtriangle : :circle
                    push!(m_shape, this_mshape)
                end
                marker := m_shape
            end

            seriestype := :scatter
            seriescolor --> :white
            X, Y
        end
    end
end
