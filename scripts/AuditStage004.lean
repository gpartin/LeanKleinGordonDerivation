import KleinGordonFormal

open Filter
open scoped Topology

namespace KleinGordonFormal

example : speedSq = 12 := c19_speed_squared

example (positive : Bool) (k : WaveVector) :
    continuumFrequency positive k ^ 2 = 361 + 12 * waveNormSq k := by
  have h := continuum_dispersion positive k
  norm_num [limitingEnergySq, square, chi0, c19_speed_squared] at h
  exact h

-- The unscaled native readout tends to the rest gap. This checks the
-- distinction between the direct lattice readout and the continuum one.
theorem stage4_raw_readout_limit (k : WaveVector) :
    Tendsto (fun h => timeReadout (sampleStep h k) (sampledOmega h k))
      (𝓝[≠] (0:ℝ)) (𝓝 (square chi0)) := by
  have hz : Tendsto (fun h : ℝ => h^2) (𝓝[≠] (0:ℝ)) (𝓝 0) := by
    have ht : ContinuousWithinAt (fun h : ℝ => h^2) ({0}ᶜ : Set ℝ) 0 :=
      (continuous_id.pow 2).continuousAt.continuousWithinAt
    simpa [ContinuousWithinAt] using ht
  have hprod := hz.mul ((sampled_energy_limit k).sub (tendsto_const_nhds (x := square chi0)))
  have hsum := (tendsto_const_nhds (x := square chi0)).add hprod
  simp only [zero_mul, add_zero] at hsum
  apply hsum.congr'
  filter_upwards [self_mem_nhdsWithin] with h hh
  unfold sampledEnergySq
  have hh' : h ≠ 0 := hh
  field_simp
  ring

example : Tendsto (fun h => timeReadout (sampleStep h (1, 0, 0))
    (sampledOmega h (1, 0, 0))) (𝓝[≠] (0:ℝ)) (𝓝 361) := by
  have h := stage4_raw_readout_limit (1, 0, 0)
  norm_num [square, chi0] at h
  exact h

example : Tendsto (fun h => sampledEnergySq h (1, 0, 0))
    (𝓝[≠] (0:ℝ)) (𝓝 373) := by
  have h := sampled_energy_limit (1, 0, 0)
  norm_num [limitingEnergySq, square, chi0, c19_speed_squared, waveNormSq] at h
  exact h

#print axioms c19_isotropic_moment
#print axioms native_long_wave_error
#print axioms sampled_energy_limit
#print axioms continuum_dispersion
#print axioms stage4_raw_readout_limit

end KleinGordonFormal
