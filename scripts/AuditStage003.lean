import KleinGordonFormal

namespace KleinGordonFormal

example (dt omega : ℝ) (k : WaveVector) :
    (∀ phase s, scalarNext chi0 dt (mode k (phase + dt * omega)) (mode k phase) s =
      mode k (phase - dt * omega) s) ↔
    2 * (1 - Real.cos (dt * omega)) = dt^2 * (361 + spaceSymbol k) := by
  have hEnergy : nativeModeEnergySq chi0 k = 361 + spaceSymbol k := by
    norm_num [nativeModeEnergySq, square, chi0]
  change _ ↔ timeSymbol dt omega = dt^2 * (361 + spaceSymbol k)
  rw [← hEnergy]
  exact discrete_dispersion_iff chi0 dt omega k

example : nativeModeEnergySq chi0 (0, 0, 0) = 361 := by
  norm_num [nativeModeEnergySq, square, chi0, spaceSymbol, positiveBonds, dotSite]

example : nativeModeEnergySq chi0 (Real.pi, 0, 0) = 409 := by
  norm_num [nativeModeEnergySq, square, chi0, spaceSymbol, positiveBonds, dotSite, Real.cos_pi]

example (dt energySq : ℝ) (hdt : 0 < dt) (he : 0 ≤ energySq)
    (hresolved : dt * Real.sqrt energySq ≤ 2) :
    timeSymbol dt (resolvedFrequency dt energySq) = dt^2 * energySq ∧
    timeSymbol dt (-(resolvedFrequency dt energySq)) = dt^2 * energySq :=
  resolved_exact dt energySq hdt he hresolved

#print axioms native_mode_force
#print axioms discrete_dispersion_iff
#print axioms resolved_exact

end KleinGordonFormal
