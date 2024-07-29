
using DataFrames, CSV, GLM, FixedEffectModels
using Test
using LinearHypothesisTest

data = CSV.File(raw"lalonde.csv") |> DataFrame;
glm_r = lm(@formula(treat ~ 1 + age + educ + race + married + nodegree + re78),data)
fe_r = reg(data,@formula(treat ~ 1 + age + educ + race + married + nodegree + re78 + fe(re75)),Vcov.cluster(:Column1))
h = "educ + age + 2*married=race: hispan"


@testset "LinearHypothesisTests" begin
      ta = LinearHypothesisTests(glm_r,h,test="F")
      @test ta.SSH ≈ 7.31491822963153

      ta = LinearHypothesisTests(fe_r,h,test="F")
      @test ta.SSH ≈ 0.26826901009093007

      ta = LinearHypothesisTests(glm_r,h,test="C")
      @test ta.SSH ≈ 7.31491822963153

      ta = LinearHypothesisTests(fe_r,h,test="C")
      @test ta.SSH ≈ 0.26826901009093007

end
