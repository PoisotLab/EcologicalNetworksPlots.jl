struct NestedBipartiteLayout
    align::Bool
    relative::Bool
end

function position!(LA::NestedBipartiteLayout, L::Dict{K,NodePosition}, N::T) where {T <: AbstractBipartiteNetwork} where {K}
    r_top = ordinalrank(collect(values(degree(N; dims=1)))).-1
    r_bot = ordinalrank(collect(values(degree(N; dims=2)))).-1

    r_top = r_top./maximum(r_top)
    r_bot = r_bot./maximum(r_bot)
    if LA.relative
        if richness(N; dims=2)>richness(N; dims=1)
            r_bot = r_bot .* richness(N; dims=2)./richness(N; dims=1)
        end
        if richness(N; dims=1)>richness(N; dims=2)
            r_top = r_top .* richness(N; dims=1)./richness(N; dims=2)
        end
    end

    if LA.align
        r_bot = r_bot .+ (0.5 - (maximum(r_bot)-minimum(r_bot))/2.0)
        r_top = r_top .+ (0.5 - (maximum(r_top)-minimum(r_top))/2.0)
    end

    d_bot = Dict(zip(species(N, dims=2), r_bot))
    d_top = Dict(zip(species(N, dims=1), r_top))

    d_all = merge(d_bot, d_top)

    for s in species(N)
        L[s].x = d_all[s]
    end
end
