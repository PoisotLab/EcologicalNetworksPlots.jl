using Pkg
using Documenter

push!(LOAD_PATH,"../src/")

Pkg.activate(".")
Pkg.add("Plots")
using EcologicalNetworksPlots
using EcologicalNetworks

makedocs(
    sitename = "EcologicalNetworksPlots",
    authors = "Timothée Poisot",
    modules = [EcologicalNetworksPlots],
    pages = [
        "Index" => "index.md"
        ]
)

deploydocs(
    deps   = Deps.pip("pygments", "python-markdown-math"),
    repo   = "github.com/PoisotLab/EcologicalNetworksPlots.jl.git",
    devbranch = "master"
)

Pkg.rm("Plots")
