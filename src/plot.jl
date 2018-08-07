function mkplot(N, pos, d; size=(600,600), c=:isolum, ms=2.5, msw=1.0)
  x = [pos[s].x for s in species(N)]
  y = [pos[s].y for s in species(N)]
  z = [d[s] for s in species(N)]
  pl = scatter(x, y, ms=0, leg=false, frame=:none, size=size)
  for int in interactions(N)
    s1, s2 = int.from, int.to
    lw_int = typeof(N) <: ProbabilisticNetwork ? int.probability./maximum(N.A) : 0.8
    plot!(pl, [pos[s1].x, pos[s2].x], [pos[s1].y, pos[s2].y], c=:grey, lw=lw_int, lab="")
  end
  scatter!(pl, x, y, marker_z = z, c=c, lab="Degree", ms=ms, msw=msw, msc=:grey)
  return pl
end
