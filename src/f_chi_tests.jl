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

function _lh_test_stats_chi(hyp_m::Tuple,β,Σ,α)
    lhs,rhs = first(hyp_m),last(hyp_m)
    valHyp = lhs' * β - rhs
    vcovHyp = lhs' * Σ * lhs
    SSH = valHyp * inv(vcovHyp) * valHyp
    std =  sqrt(vcovHyp)
    p = ccdf(Chisq(1),SSH)
    crit = quantile(Chisq(1),1-α)
   return std, SSH, p ,(α,crit)
  end

  function _lh_test_stats_chi(hyp_m::Vector,β,Σ,α)
    # Stack Things:
    rhs = last.(hyp_m)
    lhs = first.(hyp_m) |> (x->hcat(x...))
    q = size(hyp_m,1)
    valHyp = lhs' * β .- rhs
    vcovHyp = lhs' * Σ * lhs
    SSH = valHyp' * inv(vcovHyp) * valHyp
    std =  sqrt.([vcovHyp[i,i] for i in 1:size(vcovHyp,1)])
    p = ccdf(Chisq(q),SSH)
    crit = quantile(Chisq(q),1-α)
   return std, SSH, p ,(α,crit)
end
  
  function _lh_test_stats_F(hyp_m::Tuple,β,Σ,dof,α)
    lhs,rhs = first(hyp_m),last(hyp_m)
    valHyp = lhs' * β - rhs
    vcovHyp = lhs' * Σ * lhs
    SSH = valHyp * inv(vcovHyp) * valHyp
    SSH = SSH/1
    std =  sqrt(vcovHyp)
    p = ccdf(FDist(1,dof),SSH)
    crit = quantile(FDist(1,dof),1-α)
   return std, SSH, p ,(α,crit)
  end




function _lh_test_stats_F(hyp_m::Vector,β,Σ,dof,α)
    # Stack Things:
    rhs = last.(hyp_m)
    lhs = first.(hyp_m) |> (x->hcat(x...))
    q = size(hyp_m,1)
    valHyp = lhs' * β .- rhs
    vcovHyp = lhs' * Σ * lhs
    SSH = valHyp' * inv(vcovHyp) * valHyp
    SSH = SSH/q
    std =  sqrt.([vcovHyp[i,i] for i in 1:size(vcovHyp,1)])
    p = ccdf(FDist(q,dof),SSH)
    crit = quantile(FDist(q,dof),1-α)
   return std, SSH, p ,(α,crit)
  end