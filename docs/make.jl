push!(LOAD_PATH,"../src/")
using LinearHypothesisTest
using Documenter
makedocs(
         sitename = "LinearHypothesisTest.jl",
         format = Documenter.HTML(
            # analytics = "G-LFRFQ0X1VF",
         canonical = "https://eohne.github.io/LinearHypothesisTest.jl/dev/"),
         modules  = [LinearHypothesisTest],
         pages=[
                "Home" => "index.md",
                "Version Change Log" => "VersionChanges.md"
               ])
deploydocs(;
    repo="github.com/eohne/LinearHypothesisTest.jl",
    devurl = "dev",
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"]
)