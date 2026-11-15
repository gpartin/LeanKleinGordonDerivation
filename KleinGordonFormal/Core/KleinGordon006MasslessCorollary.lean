import KleinGordonFormal.Core.KleinGordon005Operator

namespace KleinGordonFormal

noncomputable section

def formalMasslessFrequency (m : ModeSpec) : ℝ :=
  if m.positiveFrequency then Real.sqrt (speedSq * waveNormSq m.k)
  else -Real.sqrt (speedSq * waveNormSq m.k)

theorem formal_massless_dispersion (m : ModeSpec) :
    formalMasslessFrequency m ^ 2 = speedSq * waveNormSq m.k := by
  have h : 0 ≤ speedSq * waveNormSq m.k := by
    rw [c19_speed_squared, waveNormSq]
    positivity
  unfold formalMasslessFrequency
  cases m.positiveFrequency <;> simp [Real.sq_sqrt h]

theorem formal_wave_equation (ms : List ModeSpec) (t x y z : ℝ) :
    second (fun a => wavesWith formalMasslessFrequency ms a x y z) t -
      speedSq * laplacian (wavesWith formalMasslessFrequency ms) t x y z = 0 := by
  have h := wave_operator_of_dispersion formalMasslessFrequency 0
    (fun m => by simpa using formal_massless_dispersion m) ms t x y z
  simpa [kgOperator] using h

theorem zero_chi_native_force (u : Site → ℝ) (x : Site) :
    scalarForce 0 u x = 0 := by simp [scalarForce, square]

theorem zero_chi_native_band (k : WaveVector) : nativeModeEnergySq 0 k = 0 := by
  simp [nativeModeEnergySq, square]

end
end KleinGordonFormal
