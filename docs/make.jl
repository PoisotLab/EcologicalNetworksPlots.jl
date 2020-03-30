push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetworksPlots

const pages = [
    "Index" => "index.md",
    "Examples" => "examples.md"
]

makedocs(
    sitename = "EcologicalNetworksPlots",
    authors = "Timothée Poisot",
    pages = pages
    )

deploydocs(
    repo = "github.com/PoisotLab/EcologicalNetworksPlots.jl.git",
    push_preview = true
)
