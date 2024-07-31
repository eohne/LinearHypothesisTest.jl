module GLM_LHT

using GLM, LinearHypothesisTest

function _get_hypothesis_matrix(m, h)
  lhs,rhs=split(h,"=")
  rhs=  try   
    parse(Float64,rhs)
  catch e
    lhs = lhs * "-$rhs"
    rhs = 0.
  end
  lhs = replace(lhs, r"( ){1,}"=>"")
  vars = split(lhs,r"(\+|-)")
  if !all(occursin.("-",lhs))
    pos_neg= ones(length(vars))
  else
    pos_neg= first(ifelse.(occursin.("-",split(lhs,Regex("("*join(vars,"|")*")"))),-1,1),size(vars,1))
  end
  cnames = replace.(coefnames(m), r"( ){1,}"=>"")
  hyp_mat = zeros(Float64,size(cnames,1))
  for i in 1:size(cnames,1)
     idx = findfirst(occursin.(Regex("(^|\\*)"*cnames[i]*"\$"),vars))
     if isnothing(idx)
      continue
     else
      if occursin(r"[0-9]{1,}\*",vars[idx])
        mult = match(r"[0-9]{1,}",vars[idx]).match
        mult = parse(Float64,mult)
        hyp_mat[i] = pos_neg[idx]*mult
      else
        hyp_mat[i] = pos_neg[idx]
      end
     end
  end
  @assert sum(.!isequal.(hyp_mat,0)) == size(vars,1) "Some of the coefficents int the Hypothesis could not be found in the model. Please check that the names match exactly!"
  return hyp_mat,rhs
end

"""
    LinearHypothesisTests(m::StatsModels.TableRegressionModel,hyp;test="")

Perform linear hypothesis tests on estimated coefficents. Can perform either an F or a Chisquared test. Returns a `NamedTuple` with the standard error, the Chisquared/F value, a p-value, the type of test performed, and the 5% critical value.

# Args
 - `m`: A TableRegressionModel from GLM.
 - `hyp`: The hypothesis to be tested (e.g. `"age + 2* educ = marriage"`) or a vector of multiple hypothesis (e.g `["age = marriage","educ=0"]`)
 - `test`: One of `"F"` for and F Test or `"C"` for a Chisquared Test.
 - `alpha`: The significance level of the critical value to be returned. Defaults to 0.05 (5%)  
"""
function LinearHypothesisTest.LinearHypothesisTests(m::StatsModels.TableRegressionModel,hyp;test="",alpha=0.05)
    if typeof(hyp) <: Vector
      hyp_m = _get_hypothesis_matrix.((m,),hyp)
    else
      hyp_m = _get_hypothesis_matrix(m,hyp)
    end
    β = coef(m)
    Σ = vcov(m)
    df = dof_residual(m)
    return LinearHypothesisTest.LinearHypothesisTests(hyp_m,β,Σ,df,test=test,alpha=alpha)
  end
  

end
