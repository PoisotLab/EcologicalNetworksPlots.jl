## Static layouts

### Nested

```@example
Unes = web_of_life("M_SD_033")
I = initial(BipartiteInitialLayout, Unes)
position!(NestedBipartiteLayout(0.4), I, Unes)
pl1 = plot(I, Unes, aspectratio=1)
scatter!(pl1, I, Unes, bipartite=true)
pl1
```

## Dynamic layouts

### Force directed

```@example
Umod = web_of_life("M_PA_003")
I = initial(RandomInitialLayout, Umod)
position!(ForceDirectedLayout(2.5), I, Umod)
plot(I, Umod, aspectratio=1)
scatter!(I, Umod, bipartite=true)
```
