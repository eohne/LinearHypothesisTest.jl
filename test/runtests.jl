
using DataFrames, CSV, GLM, FixedEffectModels
using Test
using LinearHypothesisTest

data = CSV.File(raw"lalonde.csv") |> DataFrame;
glm_r = lm(@formula(treat ~ 1 + age + educ + race + married + nodegree + re78),data)
fe_r = reg(data,@formula(treat ~ 1 + age + educ + race + married + nodegree + re78 + fe(re75)),Vcov.cluster(:Column1))
h = "educ + age + 2*married=race: hispan"


@testset "LinearHypothesisTests" begin
      ta = LinearHypothesisTests(glm_r,h,test="F")
      @test ta.value ≈ 7.31491822963153
      @test ta.test == "F-Test"
      @test ta.num_rest == 1
      @test ta.se ≈ 0.08899211247647101
      @test ta.pvalue ≈ 0.0070306141434854676
      @test ta.crit[1] == 0.05
      @test ta.crit[2] ≈ 3.8568494811036955

      ta = LinearHypothesisTests(fe_r,h,test="F")
      @test ta.value ≈ 0.26826901009093007

      ta = LinearHypothesisTests(glm_r,h,test="C")
      @test ta.value ≈ 7.31491822963153

      ta = LinearHypothesisTests(fe_r,h,test="C")
      @test ta.value ≈ 0.26826901009093007

      ta = LinearHypothesisTests(fe_r,["educ+age = 0","married=race: hispan"],test="C")
      @test ta.value ≈ 9.141444124696555
      @test ta.num_rest ==2

      ta = LinearHypothesisTests(glm_r,["educ+age = 0","married=race: hispan"],test="C")
      @test ta.value ≈ 35.29252024317945
          
      ta = LinearHypothesisTests(fe_r,["educ+age = 0","married=race: hispan"],test="F")
      @test ta.value ≈ 4.570722062348278
      ta = LinearHypothesisTests(glm_r,["educ+age = 0","married=race: hispan"],test="F")
      @test ta.value ≈ 17.646260121589727

      # dont know how to test the base display really but ok
      @test isnothing(display(ta))

      @test_throws AssertionError LinearHypothesisTests(glm_r, ["aged =educ","married =0 "],test =  "C")
      @test_throws AssertionError LinearHypothesisTests(glm_r, ["aged =educ","married =0 "],test =  "F")
      @test_throws AssertionError LinearHypothesisTests(fe_r, ["aged =educ","married =0 "],test =  "C")
      @test_throws AssertionError LinearHypothesisTests(fe_r, ["aged =educ","married =0 "],test =  "F")
end
