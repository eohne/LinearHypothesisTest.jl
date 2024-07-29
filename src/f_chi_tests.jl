function _lh_test_stats_chi(lhs,rhs,coefs,vcov)
    valHyp = lhs' * coefs - rhs
    vcovHyp = lhs' * vcov * lhs
    SSH = valHyp * inv(vcovHyp) * valHyp
    std =  sqrt(vcovHyp)
    p = ccdf(Chisq(1),SSH)
    crit = quantile(Chisq(1),1-.05)
   return std, SSH, p ,crit
  end
  
  function _lh_test_stats_F(lhs,rhs,coefs,vcov,dof)
    valHyp = lhs' * coefs - rhs
    vcovHyp = lhs' * vcov * lhs
    SSH = valHyp * inv(vcovHyp) * valHyp
    SSH = SSH/1
    std =  sqrt(vcovHyp)
    p = ccdf(FDist(1,dof),SSH)
    crit = quantile(FDist(1,dof),1-.05)
   return std, SSH, p ,crit
  end