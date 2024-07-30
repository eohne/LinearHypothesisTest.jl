module LinearHypothesisTest

using Distributions

export LinearHypothesisTests
export display


include("f_chi_tests.jl");

"""
  LinearHypothesisTests

# Fields
 - `test::String` The type of test.
 - `num_rest::Int` The number of restrictions tested
 - `se::Union{<:Number,Vector{<:Number}}` Standard error(s) one for each restriction
 - `val::Number` Value of the test statistic (F or Chis val)
 - `pvalue::Number` The pvalue
 - `crit::Tuple{Float64,Float64}` The critical value for the chosen sign. level
"""
mutable struct LinearHypothesisTests
  test::String
  num_rest::Int
  se::Union{<:Number,Vector{<:Number}}
  value::Number
  pvalue::Number
  crit::Tuple{Float64,Float64}
end

function Base.display(x::LinearHypothesisTests)
  print("\n$(x.test)")
  print("\n==============================\n")
  print("Number of Restrictions:\t$(x.num_rest)\n")
  print("Value:\t\t\t$(round(x.value,digits=3))\n")
  print("$(round(x.crit[1]*100,digits=1))% Crit Value:\t$(round(x.crit[2],digits=3))\n")
  print("P-Value:\t\t$(round(x.pvalue*100,digits=2))%\n")
  print("""St Error:\t[$(join((round.(x.se,digits=3)),", "))]\n""")
  print("==============================\n") 
end

"""
    LinearHypothesisTests(lhs::Vector{<:Number},rhs::Number,coef::Vector{<:Number},vcov::Matrix{Float64},dof=nothing;test="",alpha=0.05)

Perform linear hypothesis tests on estimated coefficents. Can perform either an F or a Chisquared test. Returns a `NamedTuple` with the standard error, the Chisquared/F value, a p-value, the type of test performed, and the 5% critical value.

# Args:
 - `lhs::Vector`:This corresponds to the hypothesis matrix. If you want to test whether b2 + 2* b3 = b4 and you have 5 coefficents from b1 to b5 (note the intercept counts as one of these coefficents) you would specify it as `[0, 1, 2, -1 0]`
 - `rhs::Number`: The value that the above linear equation should equal to under the null.
 - `coef::Vector{Number}`: A vector of estimates for (b1, b2, b3 etc)
 - `vcov::Matrix{Float64}`: A variance covariance matrix.
 - `dof`: The residual degrees of freedom. If these are not supplied a Chisquared Test will be performed.
 - `test`: One of `"F"` for an F-test or `"C"` for a Chisquared test.
 - `alpha`: The significance level of the critical value to be returned. Defaults to 0.05 (5%) 

"""
function LinearHypothesisTests(hyp_m,coef::Vector{<:Number},vcov::Matrix{Float64},dof=nothing;test="",alpha=0.05)
  if isequal(uppercase(test),"F")
    @assert !isnothing(dof) "Need Degrees Of Freedom for F test. Chisq Test performed instead!"
  end
  if !isnothing(dof) & !isequal(uppercase(test),"C")
    se,SSH,p,crit = _lh_test_stats_F(hyp_m,coef,vcov,dof,alpha)
    test_type = "F-Test"
    else
    se,SSH,p,crit=_lh_test_stats_chi(hyp_m,coef,vcov,alpha)
    test_type = "Chisq-Test"
  end
  if typeof(hyp_m)<:Tuple
    Q = 1
  else
    Q = size(hyp_m,1)
  end
  return LinearHypothesisTests(test_type,Q,se, SSH,p, crit) 
end
end

