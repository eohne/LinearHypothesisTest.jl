module FE_LHT
using FixedEffectModels, LinearHypothesisTest

"""
    LinearHypothesisTests(m::FixedEffectModel,hyp;test="")

Perform linear hypothesis tests on estimated coefficents. Can perform either an F or a Chisquared test. Returns a `NamedTuple` with the standard error, the Chisquared/F value, a p-value, the type of test performed, and the 5% critical value.

# Args
 - `m`: A FixedEffectModel.
 - `hyp`: The hypothesis to be tested (e.g. `"age + 2* educ = marriage"`) or a vector of multiple hypothesis (e.g `["age = marriage","educ=0"]`)
 - `test`: One of `"F"` for and F Test or `"C"` for a Chisquared Test.
 - `alpha`: The significance level of the critical value to be returned. Defaults to 0.05 (5%)  
"""
function LinearHypothesisTest.LinearHypothesisTests(m::FixedEffectModel,hyp;test="",alpha=0.05)
    if typeof(hyp) <: Vector
      hyp_m = LinearHypothesisTest._get_hypothesis_matrix.((m,),hyp)
    else
      hyp_m = LinearHypothesisTest._get_hypothesis_matrix(m,hyp)
    end
    β = coef(m)
    Σ = vcov(m)
    df = dof_residual(m)
    return LinearHypothesisTest.LinearHypothesisTests(hyp_m,β,Σ,df,test=test,alpha=alpha) 
  end
end