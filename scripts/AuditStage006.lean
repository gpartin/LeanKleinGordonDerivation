import KleinGordonFormal

namespace KleinGordonFormal

example (ms : List ModeSpec) (t x y z : ℝ) :
    second (fun a => wavesWith formalMasslessFrequency ms a x y z) t -
      12 * laplacian (wavesWith formalMasslessFrequency ms) t x y z = 0 := by
  simpa only [c19_speed_squared] using formal_wave_equation ms t x y z

example : formalMasslessFrequency
    { amplitude := 1, phase := 0, k := (1, 0, 0), positiveFrequency := true } ^ 2 = 12 := by
  rw [formal_massless_dispersion, c19_speed_squared]
  norm_num [waveNormSq]

example : nativeModeEnergySq 0 (1, 0, 0) = 0 :=
  zero_chi_native_band (1, 0, 0)

example (dt : ℝ) (prev cur : Site → ℝ) (i : Site) :
    scalarNext 0 dt prev cur i = 2 * cur i - prev i := by
  simp [scalarNext, zero_chi_native_force]

#print axioms formal_massless_dispersion
#print axioms formal_wave_equation
#print axioms zero_chi_native_force
#print axioms zero_chi_native_band

end KleinGordonFormal
