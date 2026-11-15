import KleinGordonFormal

open Filter
open scoped Topology

namespace KleinGordonFormal

example (ms : List ModeSpec) (t x y z : ℝ) :
    deriv (deriv (fun a => waveSum ms a x y z)) t -
      12 * (deriv (deriv (fun a => waveSum ms t a y z)) x +
        deriv (deriv (fun a => waveSum ms t x a z)) y +
        deriv (deriv (fun a => waveSum ms t x y a)) z) +
      361 * waveSum ms t x y z = 0 := by
  change kgOperator 12 361 (waveSum ms) t x y z = 0
  have h := derived_waves_solve_KG ms t x y z
  norm_num [c19_speed_squared, square, chi0] at h
  exact h

example (ms : List ModeSpec) (t x y z : ℝ) :
    Tendsto (fun h => sampledWaveSum h ms t x y z) (𝓝[≠] 0)
      (𝓝 (waveSum ms t x y z)) :=
  sampled_wave_sum_limit ms t x y z

example :
    waveSum [{ amplitude := 1, phase := 0, k := (0, 0, 0), positiveFrequency := true }]
      0 0 0 0 = 1 := by
  simp [waveSum, wavesWith, modeWith, waveAt]

#print axioms sampled_wave_sum_limit
#print axioms second_affine_cos_sum
#print axioms derived_waves_solve_KG

end KleinGordonFormal
