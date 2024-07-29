
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

# Example
The below regression etc are just toy examples to show how the functions work.
## Load some required packages and data:
```julia
using GLM, FixedEffectModels, CSV, DataFrames
using LinearHypothesisTest
data = CSV.File("test/lalonde.csv") |> DataFrame;

m_lm =  lm(@formula(treat ~ age + educ + race + married + nodegree ),data);
m_glm =  glm(@formula(treat ~ age + educ + race + married + nodegree ),data,Binomial(),LogitLink());
m_fe = reg(data,@formula(treat ~ age + educ + race + married + nodegree  + fe(re74)),Vcov.cluster(:Column1));
```
## Example Linear Model (GLM) `m_lm`
```julia
julia> m_lm
StatsModels.TableRegressionModel{LinearModel{GLM.LmResp{Vector{Float64}}, GLM.DensePredChol{Float64, LinearAlgebra.CholeskyPivoted{Float64, Matrix{Float64}, Vector{Int64}}}}, Matrix{Float64}}

treat ~ 1 + age + educ + race + married + nodegree

Coefficients:
─────────────────────────────────────────────────────────────────────────────────
                    Coef.  Std. Error       t  Pr(>|t|)    Lower 95%    Upper 95%
─────────────────────────────────────────────────────────────────────────────────
(Intercept)    0.371995    0.126153      2.95    0.0033   0.124247     0.619744
age            0.00135367  0.00164096    0.82    0.4097  -0.00186898   0.00457632
educ           0.0183177   0.00818698    2.24    0.0256   0.00223943   0.0343959
race: hispan  -0.449351    0.0497604    -9.03    <1e-17  -0.547075    -0.351628
race: white   -0.539054    0.0334271   -16.13    <1e-48  -0.604701    -0.473407
married       -0.109849    0.0336998    -3.26    0.0012  -0.176031    -0.0436663
nodegree       0.103103    0.0439286     2.35    0.0192   0.0168322    0.189373
─────────────────────────────────────────────────────────────────────────────────
```
Let's test if the coefficent of `age + 2*educ = married`:
```julia
julia> LinearHypothesisTests(m_lm, "age + 2*educ = married")

F-Test
------------------------------
St Error:               0.037
Value:                  15.9
5% Crit Value:          3.857
P-Value:                0.01%
------------------------------
```

## Example Logit Model (GLM) `m_glm`
```julia
julia> m_glm
StatsModels.TableRegressionModel{GeneralizedLinearModel{GLM.GlmResp{Vector{Float64}, Binomial{Float64}, LogitLink}, GLM.DensePredChol{Float64, LinearAlgebra.CholeskyPivoted{Float64, Matrix{Float64}, Vector{Int64}}}}, Matrix{Float64}}

treat ~ 1 + age + educ + race + married + nodegree

Coefficients:
──────────────────────────────────────────────────────────────────────────────
                   Coef.  Std. Error       z  Pr(>|z|)   Lower 95%   Upper 95%
──────────────────────────────────────────────────────────────────────────────
(Intercept)   -1.55217     0.975408    -1.59    0.1115  -3.46394     0.35959
age            0.0102973   0.0132934    0.77    0.4386  -0.0157572   0.0363518
educ           0.151612    0.0656824    2.31    0.0210   0.0228773   0.280348
race: hispan  -2.12709     0.363592    -5.85    <1e-08  -2.83972    -1.41446
race: white   -3.12657     0.285138   -10.97    <1e-27  -3.68543    -2.5677
married       -0.929693    0.271283    -3.43    0.0006  -1.4614     -0.397989
nodegree       0.787192    0.335072     2.35    0.0188   0.130463    1.44392
──────────────────────────────────────────────────────────────────────────────
```
Let's test whether `age + educ =0`
```julia
julia> LinearHypothesisTests(m_glm, "age + educ = 0")

F-Test
------------------------------
St Error:               0.069
Value:                  5.429
5% Crit Value:          3.857
P-Value:                2.01%
------------------------------
```

## Fixed Effects Example:
```julia
julia> m_fe
                                 FixedEffectModel
==================================================================================
Number of obs:                       266  Converged:                          true
dof (model):                           6  dof (residuals):                     265
R²:                                0.359  R² adjusted:                       0.320
F-statistic:                     19.0944  P-value:                           0.000
R² within:                         0.294  Iterations:                            1
==================================================================================
                 Estimate  Std. Error    t-stat  Pr(>|t|)    Lower 95%   Upper 95%
──────────────────────────────────────────────────────────────────────────────────
age            0.00445118  0.00324399   1.37213    0.1712  -0.00193609   0.0108385
educ           0.0220794   0.0137164    1.60971    0.1087  -0.00492753   0.0490864
race: hispan  -0.423725    0.100488    -4.21668    <1e-04  -0.621581    -0.225869
race: white   -0.531621    0.0599516   -8.86749    <1e-15  -0.649663    -0.413578
married       -0.130539    0.0730434   -1.78715    0.0751  -0.274359     0.0132798
nodegree       0.0991155   0.0807286    1.22776    0.2206  -0.0598355    0.258066
==================================================================================
```
```julia
julia> LinearHypothesisTests(m_fe, "age + educ + race: hispan = married")

F-Test
------------------------------
St Error:               0.14
Value:                  3.611
5% Crit Value:          3.877
P-Value:                5.85%
------------------------------
```