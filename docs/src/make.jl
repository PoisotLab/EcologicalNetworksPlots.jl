push!(LOAD_PATH,"../src/")

using Documenter, EcologicalNetworksPlots

makedocs(sitename="EcologicalNetworksPlots")

deploydocs(
    repo = "github.com/USER_NAME/PACKAGE_NAME.jl.git",
    push_preview = true
)
