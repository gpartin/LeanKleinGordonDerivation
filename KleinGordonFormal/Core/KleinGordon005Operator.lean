import KleinGordonFormal.Core.KleinGordon004Continuum

namespace KleinGordonFormal

noncomputable section
open Filter
open scoped Topology

abbrev Wave := ℝ → ℝ → ℝ → ℝ → ℝ

def second (f : ℝ → ℝ) (s : ℝ) : ℝ := deriv (deriv f) s

def laplacian (f : Wave) (t x y z : ℝ) : ℝ :=
  second (fun a => f t a y z) x +
  second (fun a => f t x a z) y +
  second (fun a => f t x y a) z

def kgOperator (cSq massSq : ℝ) (f : Wave) (t x y z : ℝ) : ℝ :=
  second (fun a => f a x y z) t - cSq * laplacian f t x y z + massSq * f t x y z

structure ModeSpec where
  amplitude : ℝ
  phase : ℝ
  k : WaveVector
  positiveFrequency : Bool

def waveAt (A phase : ℝ) (k : WaveVector) (omega : ℝ) : Wave :=
  fun t x y z => A * Real.cos (phase + k.1*x + k.2.1*y + k.2.2*z - omega*t)

def modeWith (freq : ModeSpec → ℝ) (m : ModeSpec) : Wave :=
  waveAt m.amplitude m.phase m.k (freq m)

def wavesWith (freq : ModeSpec → ℝ) (modes : List ModeSpec) : Wave :=
  fun t x y z => (modes.map fun m => modeWith freq m t x y z).sum

def waveSum (modes : List ModeSpec) : Wave :=
  wavesWith (fun m => continuumFrequency m.positiveFrequency m.k) modes

def sampledWaveSum (h : ℝ) (modes : List ModeSpec) : Wave :=
  wavesWith (fun m => sampledReadoutFrequency m.positiveFrequency h m.k) modes

theorem sampled_wave_sum_limit (ms : List ModeSpec) (t x y z : ℝ) :
    Tendsto (fun h => sampledWaveSum h ms t x y z) (𝓝[≠] 0)
      (𝓝 (waveSum ms t x y z)) := by
  induction ms with
  | nil => exact tendsto_const_nhds
  | cons m ms ih =>
    have hc : Continuous (fun omega => waveAt m.amplitude m.phase m.k omega t x y z) := by
      unfold waveAt
      fun_prop
    have hm := hc.continuousAt.tendsto.comp
      (sampled_readout_frequency_limit m.positiveFrequency m.k)
    simpa [sampledWaveSum, waveSum, wavesWith, modeWith, Function.comp_def] using hm.add ih

theorem affine_cos_deriv (A a b x : ℝ) :
    HasDerivAt (fun z => A * Real.cos (a + b*z))
      (-A*b * Real.sin (a + b*x)) x := by
  have ha : HasDerivAt (fun z : ℝ => a + b*z) b x := by
    simpa using (((hasDerivAt_id x).const_mul b).const_add a)
  convert ((Real.hasDerivAt_cos (a+b*x)).comp x ha).const_mul A using 1 <;>
    first | rfl | ring

theorem affine_sin_deriv (A a b x : ℝ) :
    HasDerivAt (fun z => A * Real.sin (a + b*z))
      (A*b * Real.cos (a + b*x)) x := by
  have ha : HasDerivAt (fun z : ℝ => a + b*z) b x := by
    simpa using (((hasDerivAt_id x).const_mul b).const_add a)
  convert ((Real.hasDerivAt_sin (a+b*x)).comp x ha).const_mul A using 1 <;>
    first | rfl | ring

private theorem hasDerivAt_list_sum (ms : List α) (f f' : α → ℝ → ℝ)
    (h : ∀ m x, HasDerivAt (f m) (f' m x) x) (x : ℝ) :
    HasDerivAt (fun z => (ms.map fun m => f m z).sum)
      (ms.map fun m => f' m x).sum x := by
  induction ms with
  | nil => simpa using hasDerivAt_const x (0:ℝ)
  | cons m ms ih => convert (h m x).add ih using 1 <;> rfl

theorem second_affine_cos_sum (ms : List α) (A a b : α → ℝ) (x : ℝ) :
    second (fun z => (ms.map fun m => A m * Real.cos (a m + b m*z)).sum) x =
      (ms.map fun m => -(b m)^2 * (A m * Real.cos (a m + b m*x))).sum := by
  have h₁ := hasDerivAt_list_sum ms (fun m z => A m * Real.cos (a m + b m*z))
    (fun m z => -A m*b m * Real.sin (a m + b m*z))
    (fun m z => affine_cos_deriv (A m) (a m) (b m) z)
  have h₂ := hasDerivAt_list_sum ms
    (fun m z => -A m*b m * Real.sin (a m + b m*z))
    (fun m z => (-A m*b m)*b m * Real.cos (a m + b m*z))
    (fun m z => affine_sin_deriv (-A m*b m) (a m) (b m) z)
  unfold second
  rw [show deriv (fun z => (ms.map fun m => A m * Real.cos (a m + b m*z)).sum) =
      (fun z => (ms.map fun m => -A m*b m * Real.sin (a m + b m*z)).sum) from
    funext fun z => (h₁ z).deriv, (h₂ x).deriv]
  congr 1
  apply List.map_congr_left
  intro m _
  ring

private theorem second_wave_slice (ms : List ModeSpec) (a b : ModeSpec → ℝ)
    (slice : ℝ → ℝ) (s : ℝ)
    (h : ∀ q, slice q =
      (ms.map fun m => m.amplitude * Real.cos (a m + b m*q)).sum) :
    second slice s =
      (ms.map fun m => -(b m)^2 * (m.amplitude * Real.cos (a m + b m*s))).sum := by
  rw [funext h]
  exact second_affine_cos_sum ms ModeSpec.amplitude a b s

theorem wave_sum_time (freq : ModeSpec → ℝ) (ms : List ModeSpec) (t x y z : ℝ) :
    second (fun a => wavesWith freq ms a x y z) t =
      (ms.map fun m => -(freq m)^2 *
        modeWith freq m t x y z).sum := by
  rw [second_wave_slice ms (fun m => m.phase + m.k.1*x + m.k.2.1*y + m.k.2.2*z)
    (fun m => -freq m) _ t]
  · simp [modeWith, waveAt, sub_eq_add_neg, neg_mul]
  · intro q
    simp [wavesWith, modeWith, waveAt, sub_eq_add_neg, neg_mul]

private theorem wave_sum_x (freq : ModeSpec → ℝ) (ms : List ModeSpec) (t x y z : ℝ) :
    second (fun a => wavesWith freq ms t a y z) x =
      (ms.map fun m => -m.k.1^2 * modeWith freq m t x y z).sum := by
  have h (q : ℝ) (m : ModeSpec) :
      m.phase + m.k.1*q + m.k.2.1*y + m.k.2.2*z -
        freq m*t =
      m.phase + m.k.2.1*y + m.k.2.2*z -
        freq m*t + m.k.1*q := by ring
  rw [second_wave_slice ms (fun m => m.phase + m.k.2.1*y + m.k.2.2*z -
    freq m*t) (fun m => m.k.1) _ x]
  · simp only [modeWith, waveAt, h]
  · intro q
    simp only [wavesWith, modeWith, waveAt, h]

private theorem wave_sum_y (freq : ModeSpec → ℝ) (ms : List ModeSpec) (t x y z : ℝ) :
    second (fun a => wavesWith freq ms t x a z) y =
      (ms.map fun m => -m.k.2.1^2 * modeWith freq m t x y z).sum := by
  have h (q : ℝ) (m : ModeSpec) :
      m.phase + m.k.1*x + m.k.2.1*q + m.k.2.2*z -
        freq m*t =
      m.phase + m.k.1*x + m.k.2.2*z -
        freq m*t + m.k.2.1*q := by ring
  rw [second_wave_slice ms (fun m => m.phase + m.k.1*x + m.k.2.2*z -
    freq m*t) (fun m => m.k.2.1) _ y]
  · simp only [modeWith, waveAt, h]
  · intro q
    simp only [wavesWith, modeWith, waveAt, h]

private theorem wave_sum_z (freq : ModeSpec → ℝ) (ms : List ModeSpec) (t x y z : ℝ) :
    second (fun a => wavesWith freq ms t x y a) z =
      (ms.map fun m => -m.k.2.2^2 * modeWith freq m t x y z).sum := by
  have h (q : ℝ) (m : ModeSpec) :
      m.phase + m.k.1*x + m.k.2.1*y + m.k.2.2*q -
        freq m*t =
      m.phase + m.k.1*x + m.k.2.1*y -
        freq m*t + m.k.2.2*q := by ring
  rw [second_wave_slice ms (fun m => m.phase + m.k.1*x + m.k.2.1*y -
    freq m*t) (fun m => m.k.2.2) _ z]
  · simp only [modeWith, waveAt, h]
  · intro q
    simp only [wavesWith, modeWith, waveAt, h]

theorem wave_operator_of_dispersion (freq : ModeSpec → ℝ) (massSq : ℝ)
    (h : ∀ m, (freq m)^2 = massSq + speedSq * waveNormSq m.k)
    (ms : List ModeSpec) (t x y z : ℝ) :
    kgOperator speedSq massSq (wavesWith freq ms) t x y z = 0 := by
  unfold kgOperator laplacian
  rw [wave_sum_time, wave_sum_x, wave_sum_y, wave_sum_z]
  unfold wavesWith
  induction ms with
  | nil => simp
  | cons m ms ih =>
    simp only [List.map_cons, List.sum_cons]
    rw [h, waveNormSq]
    linear_combination ih

theorem derived_waves_solve_KG (ms : List ModeSpec) (t x y z : ℝ) :
    kgOperator speedSq (square chi0) (waveSum ms) t x y z = 0 :=
  wave_operator_of_dispersion _ _ (fun m =>
    continuum_dispersion m.positiveFrequency m.k) ms t x y z

end
end KleinGordonFormal
