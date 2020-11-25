push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetworksPlots

const pages = [
    "Index" => "index.md",
    "Layouts" => [
        "Introduction" => "layouts/initial.md",
        "Circular" => "layouts/circular.md",
        "Bipartite" => "layouts/bipartite.md",
        "Force-directed" => "layouts/forcedirected.md",
        "Unravel" => "layouts/unravelled.md"
    ],
    "Advanced topics" => [
        "Nodes attributes" => "advanced/attributes.md",
        "Networks subsets" => "advanced/subsets.md"
    ]
    # TODO add plotting, heatmap, advanced uses
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
