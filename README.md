# LinearHypothesisTest
[![Build Status](https://github.com/eohne/LinearHypothesisTest.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/eohne/LinearHypothesisTest.jl/actions/workflows/CI.yml)
[![][docs-stable-img]][docs-stable-url]  
Perform Linear Hypothesis Tests. Currently allows to test hypothesis of the following form for `GLM` and `FixedEffectModels` models:
 * $ \beta_1 = \beta_2$
 * $ \beta_2 + 3 \times \beta_2 =5$
 * $ 0.5 \times \beta_1 + \beta_2 + \beta_3 = \beta_4$

## Package Installation

The package is NOT registered with the General Registry but you can install the package either by using the Pkg REPL mode (press `]` to enter):
```
pkg> add http://github.com/eohne/LinearHypothesisTest.jl
```
or by using Pkg functions
```julia
julia> using Pkg; Pkg.add("http://github.com/eohne/LinearHypothesisTest.jl")
```

[docs-stable-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-stable-url]: https://eohne.github.io/LinearHypothesisTest.jl/dev/