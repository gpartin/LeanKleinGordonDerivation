import KleinGordonFormal.Core.KleinGordon006MasslessCorollary

namespace KleinGordonFormal

noncomputable section
open Filter
open scoped Topology

def polarizedMode (k : WaveVector) (phase : ℝ) : Field ℝ :=
  fun s => polarization (mode k phase s, mode k (phase - Real.pi / 2) s)

theorem exact_reciprocal_wave (dt omega : ℝ) (k : WaveVector) (phase : ℝ)
    (h : timeSymbol dt omega = dt^2 * nativeModeEnergySq chi0 k) :
    tangentUpdate (fun _ => vacuumCell chi0) dt
      (polarizedMode k (phase + dt*omega)) (polarizedMode k phase)
      (polarizedMode k (phase - dt*omega)) := by
  have hmode := (discrete_dispersion_iff chi0 dt omega k).mpr h
  let p : Site → ℝ × ℝ := fun s =>
    (mode k (phase + dt*omega) s, mode k ((phase - Real.pi/2) + dt*omega) s)
  let q : Site → ℝ × ℝ := fun s => (mode k phase s, mode k (phase - Real.pi/2) s)
  have hu := scalar_native_update chi0 dt p q
  have hp : polarization ∘ p = polarizedMode k (phase + dt*omega) := by
    funext s
    simp only [p, Function.comp_apply, polarizedMode]
    rw [show phase - Real.pi/2 + dt*omega = phase + dt*omega - Real.pi/2 by ring]
  have hq : polarization ∘ q = polarizedMode k phase := rfl
  rw [hp, hq] at hu
  convert hu using 1
  funext s
  simp only [polarizedMode, p, q, hmode]
  rw [show phase - Real.pi/2 - dt*omega = phase - dt*omega - Real.pi/2 by ring]

def sampledSignedOmega (h : ℝ) (k : WaveVector) (positive : Bool) : ℝ :=
  if positive then sampledOmega h k else -sampledOmega h k

theorem sampled_reciprocal_wave (h : ℝ) (k : WaveVector) (positive : Bool)
    (phase : ℝ) (hh : h ≠ 0) :
    tangentUpdate (fun _ => vacuumCell chi0) (sampleStep h k)
      (polarizedMode (scaleWave h k) (phase + sampleStep h k * sampledSignedOmega h k positive))
      (polarizedMode (scaleWave h k) phase)
      (polarizedMode (scaleWave h k) (phase - sampleStep h k * sampledSignedOmega h k positive)) := by
  apply exact_reciprocal_wave
  have he := sampled_modes_exact h k hh
  cases positive
  · exact (discrete_dispersion_iff ..).mp he.2
  · exact (discrete_dispersion_iff ..).mp he.1

structure C40KleinGordonCertificate : Prop where
  c19 : directedBonds.length = 18 ∧ directedBonds.Nodup ∧
    (∀ b ∈ directedBonds, b.reverse ∈ directedBonds)
  inertia : chiInertia = 1197
  kineticPairing : ∀ v test,
    (kinetic (TrivSqZeroExt.inlHom ℝ ℝ) (jetCell v test)).snd = cellPairing v test
  variation : ∀ q x test, HasDerivAt
    (fun t => incidentPotential (RingHom.id ℝ) q x (affineCell (q x) test t))
    (potentialVariation q x test) 0
  linearResponse : ∀ q u x test, HasDerivAt
    (fun t => potentialVariation (fun y => affineCell (q y) (u y) t) x test)
    (potentialTangent q u x test) 0
  stationary : ∀ dt, nativeUpdate dt (fun _ => vacuumCell chi0)
    (fun _ => vacuumCell chi0) (fun _ => vacuumCell chi0)
  nativeModes : ∀ h k positive phase, h ≠ 0 →
    tangentUpdate (fun _ => vacuumCell chi0) (sampleStep h k)
      (polarizedMode (scaleWave h k) (phase + sampleStep h k * sampledSignedOmega h k positive))
      (polarizedMode (scaleWave h k) phase)
      (polarizedMode (scaleWave h k) (phase - sampleStep h k * sampledSignedOmega h k positive))
  spatialError : ∀ h k, h ≠ 0 →
    |refinedEnergySq h k - limitingEnergySq k| ≤ h^2 * spatialErrorWeight k
  temporalError : ∀ dt omega, dt ≠ 0 →
    |timeReadout dt omega - omega^2| ≤ dt^2 * omega^4 / 12
  nativeError : ∀ h dt omega k, dt ≠ 0 →
    timeSymbol dt omega = dt^2 * nativeModeEnergySq chi0 (scaleWave h k) →
    |omega^2 - (square chi0 + h^2 * (speedSq * waveNormSq k))| ≤
      dt^2 * omega^4 / 12 + h^4 * spatialErrorWeight k
  nativeLimit : ∀ k, Tendsto (fun h => sampledEnergySq h k)
    (𝓝[≠] 0) (𝓝 (limitingEnergySq k))
  waveLimit : ∀ ms t x y z, Tendsto (fun h => sampledWaveSum h ms t x y z)
    (𝓝[≠] 0) (𝓝 (waveSum ms t x y z))
  operatorLimit : ∀ ms t x y z, kgOperator speedSq (square chi0) (waveSum ms) t x y z = 0
  formalMassless : ∀ ms t x y z,
    second (fun a => wavesWith formalMasslessFrequency ms a x y z) t -
      speedSq * laplacian (wavesWith formalMasslessFrequency ms) t x y z = 0
  zeroChi : ∀ k, nativeModeEnergySq 0 k = 0

theorem c40_yields_klein_gordon : C40KleinGordonCertificate :=
  { c19 := c19_geometry
    inertia := chi_inertia_native
    kineticPairing := kinetic_pairing_from_action
    variation := actual_real_variation
    linearResponse := actual_linear_response
    stationary := vacuum_stationary
    nativeModes := sampled_reciprocal_wave
    spatialError := spatial_readout_error
    temporalError := temporal_readout_error
    nativeError := native_long_wave_error
    nativeLimit := sampled_energy_limit
    waveLimit := sampled_wave_sum_limit
    operatorLimit := derived_waves_solve_KG
    formalMassless := formal_wave_equation
    zeroChi := zero_chi_native_band }

end
end KleinGordonFormal
