push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetworksPlots

const pages = [
    "Index" => "index.md",
    "Layouts" => [
        "Introduction" => "layouts/initial.md",
        "Circular" => "layouts/circular.md"
    ],
    "Reference" => "library.md"
]

makedocs(
    sitename = "EcologicalNetworksPlots",
    authors = "Timothée Poisot",
    pages = pages
    )

deploydocs(
    repo = "github.com/EcoJulia/EcologicalNetworksPlots.jl.git",
    push_preview = true
)
