module LinearHypothesisTest

using Distributions

export LinearHypothesisTests
export display


include("f_chi_tests.jl");

"""
  LinearHypothesisTests

#Fields
 - `test::String` The type of test.
 - `se::Number` Standard error
 - `val::Number` Value of the test statistic (F or Chis val)
 - `pvalue::Number` The pvalue
 - `crit::Number` The critical value for the 5% sign. level
"""
mutable struct LinearHypothesisTests
  test::String
  se::Number
  value::Number
  pvalue::Number
  crit::Number
end

function Base.display(x::LinearHypothesisTests)
  print("\n$(x.test)")
  print("\n------------------------------\n")
  print("St Error:\t\t$(round(x.se,digits=3))\n")
  print("Value:\t\t\t$(round(x.value,digits=3))\n")
  print("5% Crit Value:\t\t$(round(x.crit,digits=3))\n")
  print("P-Value:\t\t$(round(x.pvalue*100,digits=2))%\n")
  print("------------------------------\n")
end

"""
    LinearHypothesisTests(lhs::Vector{<:Number},rhs::Number,coef::Vector{<:Number},vcov::Matrix{Float64},dof=nothing;test="")

Perform linear hypothesis tests on estimated coefficents. Can perform either an F or a Chisquared test. Returns a `NamedTuple` with the standard error, the Chisquared/F value, a p-value, the type of test performed, and the 5% critical value.

# Args:
 - `lhs::Vector`:This corresponds to the hypothesis matrix. If you want to test whether b2 + 2* b3 = b4 and you have 5 coefficents from b1 to b5 (note the intercept counts as one of these coefficents) you would specify it as `[0, 1, 2, -1 0]`
 - `rhs::Number`: The value that the above linear equation should equal to under the null.
 - `coef::Vector{Number}`: A vector of estimates for (b1, b2, b3 etc)
 - `vcov::Matrix{Float64}`: A variance covariance matrix.
 - `dof`: The residual degrees of freedom. If these are not supplied a Chisquared Test will be performed.
 - `test`: One of `"F"` for an F-test or `"C"` for a Chisquared test.

"""
function LinearHypothesisTests(lhs::Vector{<:Number},rhs::Number,coef::Vector{<:Number},vcov::Matrix{Float64},dof=nothing;test="")
  if isequal(uppercase(test),"F")
    @assert !isnothing(dof) "Need Degrees Of Freedom for F test. Chisq Test performed instead!"
  end
  if !isnothing(dof) & !isequal(uppercase(test),"C")
    se,SSH,p,crit = _lh_test_stats_F(lhs,rhs,coef,vcov,dof)
    test_type = "F-Test"
    else
    se,SSH,p,crit=_lh_test_stats_chi(lhs,rhs,coef,vcov)
    test_type = "Chisq-Test"
  end
  return LinearHypothesisTests(test_type,se, SSH,p, crit) 
end
end