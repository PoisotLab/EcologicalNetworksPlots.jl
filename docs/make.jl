push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetworksPlots

makedocs(sitename="EcologicalNetworksPlots")

deploydocs(
    repo = "github.com/PoisotLab/EcologicalNetworksPlots.jl.git",
    push_preview = true
)
