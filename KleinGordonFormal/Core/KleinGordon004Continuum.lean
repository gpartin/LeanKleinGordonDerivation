import KleinGordonFormal.Core.KleinGordon003LatticeDispersion
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds
import Mathlib.Analysis.SpecialFunctions.Trigonometric.InverseDeriv

namespace KleinGordonFormal

noncomputable section
open Filter
open scoped Topology

def scaleWave (h : ℝ) (k : WaveVector) : WaveVector := (h*k.1, h*k.2.1, h*k.2.2)

def waveNormSq (k : WaveVector) : ℝ := k.1^2 + k.2.1^2 + k.2.2^2

def speedSq : ℝ := 2 * (positiveBonds.map fun b =>
  (b.weight : ℝ) * (b.offset.1 : ℝ)^2).sum

theorem c19_isotropic_moment (k : WaveVector) :
    2 * (positiveBonds.map fun b => (b.weight : ℝ) * (dotSite k b.offset)^2).sum =
      speedSq * waveNormSq k := by
  norm_num [positiveBonds, speedSq, waveNormSq, dotSite]
  ring

theorem c19_speed_squared : speedSq = 12 := by
  norm_num [speedSq, positiveBonds]

def spatialErrorWeight (k : WaveVector) : ℝ :=
  (positiveBonds.map fun b => (b.weight : ℝ) * (dotSite k b.offset)^4).sum / 6

theorem dotSite_scale (h : ℝ) (k : WaveVector) (s : Site) :
    dotSite (scaleWave h k) s = h * dotSite k s := by
  unfold dotSite scaleWave
  ring

theorem centered_cosine_error (x : ℝ) :
    |2 * (1 - Real.cos x) - x^2| ≤ x^4 / 12 := by
  have hc : Real.cos x = 1 - 2 * Real.sin (x/2)^2 := by
    conv_lhs => rw [show x = 2 * (x/2) by ring]
    exact Real.cos_two_mul_eq_one_sub _
  have hsum : |Real.sin (x/2) + x/2| ≤ 2 * |x/2| := by
    calc
      _ ≤ |Real.sin (x/2)| + |x/2| := abs_add_le _ _
      _ ≤ _ := by linarith [Real.abs_sin_le_abs (x := x/2)]
  have hsub : |Real.sin (x/2) - x/2| ≤ |x/2|^3 / 6 := by
    rw [abs_sub_comm]
    exact Real.abs_sub_sin_le _
  have hm := mul_le_mul hsub hsum (abs_nonneg _) (by positivity : 0 ≤ |x/2|^3 / 6)
  rw [hc, show 2 * (1 - (1 - 2 * Real.sin (x/2)^2)) - x^2 =
      4 * ((Real.sin (x/2) - x/2) * (Real.sin (x/2) + x/2)) by ring,
    abs_mul, abs_mul, abs_of_nonneg (by norm_num : 0 ≤ (4:ℝ))]
  calc
    _ ≤ 4 * ((|x/2|^3 / 6) * (2 * |x/2|)) := by
      simpa [mul_assoc] using mul_le_mul_of_nonneg_left hm (by norm_num : 0 ≤ (4:ℝ))
    _ = x^4 / 12 := by rw [abs_div, abs_of_pos (by norm_num : 0 < (2:ℝ))]; rw [show (|x| / 2)^3 / 6 * (2 * (|x| / 2)) = |x|^4 / 48 by ring, pow_abs, abs_of_nonneg (by positivity : 0 ≤ x^4)]; ring

private theorem spatial_list_error (bs : List Bond) (h : ℝ) (k : WaveVector) :
    |4 * (bs.map fun b => (b.weight : ℝ) * (1 - Real.cos (dotSite (scaleWave h k) b.offset))).sum -
      h^2 * (2 * (bs.map fun b => (b.weight : ℝ) * (dotSite k b.offset)^2).sum)| ≤
      h^4 * ((bs.map fun b => (b.weight : ℝ) * (dotSite k b.offset)^4).sum / 6) := by
  induction bs with
  | nil => simp
  | cons b bs ih =>
    simp only [List.map_cons, List.sum_cons]
    let q := dotSite k b.offset
    let w : ℝ := b.weight
    let s := (bs.map fun d => (d.weight : ℝ) * (1 - Real.cos (dotSite (scaleWave h k) d.offset))).sum
    let m := (bs.map fun d => (d.weight : ℝ) * (dotSite k d.offset)^2).sum
    let e := (bs.map fun d => (d.weight : ℝ) * (dotSite k d.offset)^4).sum
    rw [dotSite_scale]
    change |4 * (w * (1 - Real.cos (h*q)) + s) - h^2 * (2 * (w*q^2 + m))| ≤
      h^4 * ((w*q^4+e)/6)
    rw [show 4 * (w * (1 - Real.cos (h*q)) + s) - h^2 * (2 * (w*q^2 + m)) =
      (2*w) * (2*(1-Real.cos (h*q)) - (h*q)^2) + (4*s - h^2*(2*m)) by ring]
    have hw : 0 ≤ 2*w := by positivity
    calc
      _ ≤ |(2*w) * (2*(1-Real.cos (h*q)) - (h*q)^2)| + |4*s - h^2*(2*m)| := abs_add_le _ _
      _ ≤ (2*w) * ((h*q)^4 / 12) + h^4 * (e/6) := by
        rw [abs_mul, abs_of_nonneg hw]
        exact add_le_add (mul_le_mul_of_nonneg_left (centered_cosine_error _) hw) ih
      _ = _ := by ring

theorem c19_spatial_error (h : ℝ) (k : WaveVector) :
    |spaceSymbol (scaleWave h k) - h^2 * (speedSq * waveNormSq k)| ≤
      h^4 * spatialErrorWeight k := by
  rw [← c19_isotropic_moment k]
  exact spatial_list_error positiveBonds h k

/-- The fixed-wave-number readout divides the native transport part by
the squared spacing. The onsite rest-frequency term is measured separately. -/
def refinedEnergySq (h : ℝ) (k : WaveVector) : ℝ :=
  square chi0 + spaceSymbol (scaleWave h k) / h^2

def limitingEnergySq (k : WaveVector) : ℝ := square chi0 + speedSq * waveNormSq k

def timeReadout (dt omega : ℝ) : ℝ := timeSymbol dt omega / dt^2

theorem native_zoom_identity (h dt omega : ℝ) (k : WaveVector) (hdt : dt ≠ 0)
    (hnative : ∀ phase s, scalarNext chi0 dt (mode (scaleWave h k) (phase + dt*omega))
      (mode (scaleWave h k) phase) s = mode (scaleWave h k) (phase-dt*omega) s) :
    square chi0 + (timeReadout dt omega - square chi0) / h^2 = refinedEnergySq h k := by
  have hm := (discrete_dispersion_iff chi0 dt omega (scaleWave h k)).mp hnative
  have hpos : square chi0 ≠ 0 := by norm_num [square, chi0]
  simp [timeReadout, hm, hdt, refinedEnergySq, nativeModeEnergySq, hpos]

theorem spatial_readout_error (h : ℝ) (k : WaveVector) (hh : h ≠ 0) :
    |refinedEnergySq h k - limitingEnergySq k| ≤ h^2 * spatialErrorWeight k := by
  have hp : 0 < h^2 := sq_pos_of_ne_zero hh
  have he := c19_spatial_error h k
  unfold refinedEnergySq limitingEnergySq
  rw [show square chi0 + spaceSymbol (scaleWave h k) / h^2 -
      (square chi0 + speedSq * waveNormSq k) =
      (spaceSymbol (scaleWave h k) - h^2 * (speedSq * waveNormSq k)) / h^2 by
        field_simp; ring, abs_div, abs_of_pos hp]
  apply (div_le_iff₀ hp).2
  calc
    _ ≤ h^4 * spatialErrorWeight k := he
    _ = _ := by ring

theorem temporal_readout_error (dt omega : ℝ) (hdt : dt ≠ 0) :
    |timeReadout dt omega - omega^2| ≤ dt^2 * omega^4 / 12 := by
  have hp : 0 < dt^2 := sq_pos_of_ne_zero hdt
  unfold timeReadout timeSymbol
  rw [show 2 * (1 - Real.cos (dt*omega)) / dt^2 - omega^2 =
      (2 * (1 - Real.cos (dt*omega)) - (dt*omega)^2) / dt^2 by field_simp,
    abs_div, abs_of_pos hp]
  apply (div_le_iff₀ hp).2
  calc
    _ ≤ (dt * omega)^4 / 12 := centered_cosine_error _
    _ = _ := by ring

/-- Direct long-wave defect in the original lattice coordinates, before
the fixed-wave-number spectral readout. -/
theorem native_long_wave_error (h dt omega : ℝ) (k : WaveVector) (hdt : dt ≠ 0)
    (hnative : timeSymbol dt omega = dt^2 * nativeModeEnergySq chi0 (scaleWave h k)) :
    |omega^2 - (square chi0 + h^2 * (speedSq * waveNormSq k))| ≤
      dt^2 * omega^4 / 12 + h^4 * spatialErrorWeight k := by
  have hchi : square chi0 ≠ 0 := by norm_num [square, chi0]
  have hread : timeReadout dt omega = square chi0 + spaceSymbol (scaleWave h k) := by
    simp [timeReadout, hnative, nativeModeEnergySq, hdt, hchi]
  rw [show omega^2 - (square chi0 + h^2 * (speedSq * waveNormSq k)) =
    (omega^2 - timeReadout dt omega) +
      (spaceSymbol (scaleWave h k) - h^2 * (speedSq * waveNormSq k)) by rw [hread]; ring]
  calc
    _ ≤ |omega^2 - timeReadout dt omega| +
        |spaceSymbol (scaleWave h k) - h^2 * (speedSq * waveNormSq k)| := abs_add_le _ _
    _ ≤ _ := add_le_add (by rw [abs_sub_comm]; exact temporal_readout_error dt omega hdt)
      (c19_spatial_error h k)

theorem refined_symbol_limit (k : WaveVector) :
    Tendsto (fun h => refinedEnergySq h k) (𝓝[≠] 0) (𝓝 (limitingEnergySq k)) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  apply squeeze_zero' (Eventually.of_forall fun _ => norm_nonneg _)
  · filter_upwards [self_mem_nhdsWithin] with h hh
    exact (Real.norm_eq_abs _).symm ▸ (spatial_readout_error h k hh)
  · have h : Continuous (fun x : ℝ => x^2 * spatialErrorWeight k) :=
      (continuous_id.pow 2).mul continuous_const
    have ht : ContinuousWithinAt (fun x : ℝ => x^2 * spatialErrorWeight k)
        ({0}ᶜ : Set ℝ) 0 := h.continuousAt.continuousWithinAt
    simpa [ContinuousWithinAt] using ht

theorem limiting_energy_nonnegative (k : WaveVector) : 0 ≤ limitingEnergySq k := by
  rw [limitingEnergySq, c19_speed_squared]
  simp only [square, ← pow_two, waveNormSq]
  positivity

theorem native_band_nonnegative (k : WaveVector) : 0 ≤ nativeModeEnergySq chi0 k := by
  have hl (bs : List Bond) :
      0 ≤ (bs.map fun b => (b.weight : ℝ) * (1 - Real.cos (dotSite k b.offset))).sum := by
    induction bs with
    | nil => simp
    | cons b bs ih =>
      exact add_nonneg (mul_nonneg (by positivity)
        (sub_nonneg.mpr (Real.cos_le_one _))) ih
  have hs : 0 ≤ spaceSymbol k := mul_nonneg (by norm_num) (hl positiveBonds)
  unfold nativeModeEnergySq square
  exact add_nonneg (mul_self_nonneg _)
    (mul_nonneg (div_nonneg (mul_self_nonneg _) (mul_self_nonneg _)) hs)

/-- A stable refinement schedule using the actual native band. The h^2
numerator also makes dt shrink faster than the spatial sampling interval. -/
def refinementDt (h energySq : ℝ) : ℝ :=
  h^2 / (1 + h^2 * (1 + Real.sqrt energySq))

theorem refinement_schedule (h energySq : ℝ) (hh : h ≠ 0) :
    0 < refinementDt h energySq ∧
      refinementDt h energySq ≤ h^2 ∧
      refinementDt h energySq * Real.sqrt energySq ≤ 2 := by
  have hp : 0 < h^2 := sq_pos_of_ne_zero hh
  have hs := Real.sqrt_nonneg energySq
  have hd : 0 < 1 + h^2 * (1 + Real.sqrt energySq) := by positivity
  unfold refinementDt
  refine ⟨div_pos hp hd, ?_, ?_⟩
  · apply (div_le_iff₀ hd).2
    nlinarith [mul_nonneg (sq_nonneg (h^2)) (add_nonneg (by norm_num : 0 ≤ (1:ℝ)) hs)]
  · rw [div_mul_eq_mul_div]
    apply (div_le_iff₀ hd).2
    nlinarith [mul_nonneg hp.le hs]

def sampleStep (h : ℝ) (k : WaveVector) : ℝ :=
  refinementDt h (nativeModeEnergySq chi0 (scaleWave h k))

def sampledOmega (h : ℝ) (k : WaveVector) : ℝ :=
  resolvedFrequency (sampleStep h k) (nativeModeEnergySq chi0 (scaleWave h k))

theorem sampled_modes_exact (h : ℝ) (k : WaveVector) (hh : h ≠ 0) :
    (∀ phase s, scalarNext chi0 (sampleStep h k)
      (mode (scaleWave h k) (phase + sampleStep h k * sampledOmega h k))
      (mode (scaleWave h k) phase) s =
      mode (scaleWave h k) (phase - sampleStep h k * sampledOmega h k) s) ∧
    (∀ phase s, scalarNext chi0 (sampleStep h k)
      (mode (scaleWave h k) (phase + sampleStep h k * (-sampledOmega h k)))
      (mode (scaleWave h k) phase) s =
      mode (scaleWave h k) (phase - sampleStep h k * (-sampledOmega h k)) s) := by
  have hs := refinement_schedule h (nativeModeEnergySq chi0 (scaleWave h k)) hh
  have he := resolved_exact _ _ hs.1 (native_band_nonnegative _) hs.2.2
  exact ⟨(discrete_dispersion_iff ..).mpr he.1, (discrete_dispersion_iff ..).mpr he.2⟩

def sampledEnergySq (h : ℝ) (k : WaveVector) : ℝ :=
  square chi0 + (timeReadout (sampleStep h k) (sampledOmega h k) - square chi0) / h^2

theorem sampled_energy_limit (k : WaveVector) :
    Tendsto (fun h => sampledEnergySq h k) (𝓝[≠] 0) (𝓝 (limitingEnergySq k)) := by
  apply (refined_symbol_limit k).congr'
  filter_upwards [self_mem_nhdsWithin] with h hh
  exact (native_zoom_identity h (sampleStep h k) (sampledOmega h k) k
    (refinement_schedule h _ hh).1.ne' (sampled_modes_exact h k hh).1).symm

/-- The continuum frequency uses the limit of the squared phase readout
of exact native solutions. The expression for that limit is a theorem. -/
def continuumFrequency (positive : Bool) (k : WaveVector) : ℝ :=
  let limit := limUnder (𝓝[≠] (0:ℝ)) (fun h => sampledEnergySq h k)
  if positive then Real.sqrt limit else -Real.sqrt limit

theorem continuum_dispersion (positive : Bool) (k : WaveVector) :
    continuumFrequency positive k ^ 2 = limitingEnergySq k := by
  cases positive <;> simp [continuumFrequency, (sampled_energy_limit k).limUnder_eq,
    Real.sq_sqrt (limiting_energy_nonnegative k)]

def sampledReadoutFrequency (positive : Bool) (h : ℝ) (k : WaveVector) : ℝ :=
  if positive then Real.sqrt (sampledEnergySq h k) else -Real.sqrt (sampledEnergySq h k)

theorem sampled_readout_frequency_limit (positive : Bool) (k : WaveVector) :
    Tendsto (fun h => sampledReadoutFrequency positive h k) (𝓝[≠] 0)
      (𝓝 (continuumFrequency positive k)) := by
  have h := Real.continuous_sqrt.continuousAt.tendsto.comp (sampled_energy_limit k)
  cases positive
  · simpa [sampledReadoutFrequency, continuumFrequency, Function.comp_def,
      (sampled_energy_limit k).limUnder_eq] using h.neg
  · simpa [sampledReadoutFrequency, continuumFrequency, Function.comp_def,
      (sampled_energy_limit k).limUnder_eq] using h

end
end KleinGordonFormal
