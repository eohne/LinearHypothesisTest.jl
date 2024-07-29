push!(LOAD_PATH,"../src/")
using LinearHypothesisTest
using GLM, FixedEffectModels
using Documenter
makedocs(
         sitename = "LinearHypothesisTest.jl",
         format = Documenter.HTML(
            # analytics = "G-LFRFQ0X1VF",
         canonical = "https://eohne.github.io/LinearHypothesisTest.jl/dev/"),
         modules  = [LinearHypothesisTest,
         isdefined(Base, :get_extension) ? Base.get_extension(LinearHypothesisTest, :FE_LHT) :
         LinearHypothesisTest.FE_LHT,
         isdefined(Base, :get_extension) ? Base.get_extension(LinearHypothesisTest, :GLM_LHT) :
         LinearHypothesisTest.GLM_LHT,],
         pages=[
                "Home" => "index.md",
                "Version Change Log" => "VersionChanges.md"
               ])
deploydocs(;
    repo="github.com/eohne/LinearHypothesisTest.jl",
    devurl = "dev",
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"]
)