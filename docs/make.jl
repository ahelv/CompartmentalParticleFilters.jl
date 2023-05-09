using CompartmentalParticleFilters
using Documenter

DocMeta.setdocmeta!(CompartmentalParticleFilters, :DocTestSetup, :(using CompartmentalParticleFilters); recursive=true)

makedocs(;
    modules=[CompartmentalParticleFilters],
    authors="Annika Helverson",
    repo="https://github.com/ahelv/CompartmentalParticleFilters.jl/blob/{commit}{path}#{line}",
    sitename="CompartmentalParticleFilters.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ahelv.github.io/CompartmentalParticleFilters.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ahelv/CompartmentalParticleFilters.jl",
    devbranch="main",
)
