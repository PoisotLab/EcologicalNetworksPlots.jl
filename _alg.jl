@time begin

    # Begin
    xy = zeros(Float64, 2, richness(N))
    k = zeros(Float64, richness(N))
    for (i, s) in enumerate(species(N))
        xy[1, i] = I[s].x
        xy[2, i] = I[s].y
        k[i] = max(I[s].degree, 1.0)
    end

    # Degree matrix
    K = k .* k'
    K[diagind(K)] .= 0.0
    K = K ./ maximum(K)

    # Distances
    distance = pairwise(Euclidean(), xy)

    # Repulsion force
    repulsion = EcologicalNetworksPlots._force.(distance, Opt.k[2], Opt.exponents[3:4]...)
    move_away = (K .* repulsion) ./ distance
    move_away[diagind(move_away)] .= 0.0

    # Attraction force
    attraction = EcologicalNetworksPlots._force.(distance, Opt.k[1], Opt.exponents[1:2]...)
    attraction[findall(iszero, N.edges)] .= 0.0
    move_towards = attraction ./ distance
    move_towards[diagind(move_towards)] .= 0.0

    sum(move_away .- move_towards; dims=2)

end

v = copy(xy)