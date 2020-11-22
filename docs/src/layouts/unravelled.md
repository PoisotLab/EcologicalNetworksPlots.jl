## Unravelled layout

The unravelled layout is essentially a scatterplot of network properties with
interactions drawn as well. This is inspired by [the work of Giulio V. Dalla
Riva on this visualisation](https://github.com/gvdr/unravel). By default, it
will compare the omnivory index and the trophic level:

### Layouts

```@docs
UnravelledInitialLayout
UnravelledLayout
```

### Example

```@example default
N = nz_stream_foodweb()[10]
I = initial(UnravelledInitialLayout, N)
plot(I, N, lab="", framestyle=:box)
scatter!(I, N, nodefill=degree(N), colorbar=true, framestyle=:box)
```

Because a lot of species will have the same omnivory index, we might want to use
a slightly different function, which adds some randomness to the omnivory:

```@example default
N = nz_stream_foodweb()[10]
I = initial(UnravelledInitialLayout, N)

function random_omnivory(N::T) where {T <: UnipartiteNetwork}
  o = omnivory(N)
  for s in species(N)
    o[s] += (rand()-0.5)*0.1
  end
  return o
end

UL = UnravelledLayout(x=random_omnivory, y=trophic_level)
position!(UL, I, N)

plot(I, N, lab="", framestyle=:box)
scatter!(I, N, nodefill=degree(N), colorbar=true, framestyle=:box, mc=:viridis)
```
