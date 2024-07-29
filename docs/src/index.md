
# LinearHypothesisTest
GitHub Repo: [https://github.com/eohne/LinearHypothesisTest.jl](https://github.com/eohne/LinearHypothesisTest.jl)

Perform Linear Hypothesis Tests. Currently allows to test hypothesis of the following form for `GLM` and `FixedEffectModels` models:
 * $` \beta_1 = \beta_2`$
 * $` \beta_2 + 3 \times \beta_2 =5`$
 * $` 0.5 \times \beta_1 + \beta_2 + \beta_3 = \beta_4`$
 * $` 0.5 \times \beta_1 + \beta_2 + \beta_3 = 0`$


## Package Installation

The package is NOT registered with the General Registry but you can install the package either by using the Pkg REPL mode (press `]` to enter):
```
pkg> add http://github.com/eohne/LinearHypothesisTest.jl
```
or by using Pkg functions
```julia
julia> using Pkg; Pkg.add("http://github.com/eohne/LinearHypothesisTest.jl")
```
# Function Definition
````@docs
LinearHypothesisTests
````