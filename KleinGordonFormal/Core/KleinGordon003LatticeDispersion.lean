import KleinGordonFormal.Core.KleinGordon002ScalarTangent
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse
import Mathlib.Tactic.LinearCombination

namespace KleinGordonFormal

noncomputable section

abbrev WaveVector := ℝ × ℝ × ℝ

def dotSite (k : WaveVector) (s : Site) : ℝ :=
  k.1 * s.1 + k.2.1 * s.2.1 + k.2.2 * s.2.2

def mode (k : WaveVector) (phase : ℝ) (s : Site) : ℝ :=
  Real.cos (phase + dotSite k s)

def spaceSymbol (k : WaveVector) : ℝ :=
  4 * (positiveBonds.map fun b => (b.weight : ℝ) * (1 - Real.cos (dotSite k b.offset))).sum

def nativeModeEnergySq (r : ℝ) (k : WaveVector) : ℝ :=
  square r + square r / square chi0 * spaceSymbol k

def timeSymbol (dt omega : ℝ) : ℝ :=
  2 * (1 - Real.cos (dt * omega))

theorem dotSite_shift (k : WaveVector) (s : Site) (b : Bond) :
    dotSite k (shift s b) = dotSite k s + dotSite k b.offset := by
  simp [dotSite, shift, Int.cast_add]
  ring

theorem dotSite_reverse (k : WaveVector) (b : Bond) :
    dotSite k b.reverse.offset = -dotSite k b.offset := by
  simp [dotSite, Bond.reverse, Int.cast_neg]
  ring

private theorem cos_pair (a b : ℝ) :
    Real.cos (a + b) + Real.cos (a - b) = 2 * Real.cos a * Real.cos b := by
  rw [Real.cos_add, Real.cos_sub]
  ring

private theorem bond_mode_pair (k : WaveVector) (phase : ℝ) (s : Site) (b : Bond) :
    (b.weight : ℝ) * (mode k phase (shift s b) - mode k phase s) +
      (b.reverse.weight : ℝ) * (mode k phase (shift s b.reverse) - mode k phase s) =
    -2 * ((b.weight : ℝ) * (1 - Real.cos (dotSite k b.offset))) * mode k phase s := by
  unfold mode
  rw [dotSite_shift, dotSite_shift, dotSite_reverse]
  have hh := cos_pair (phase + dotSite k s) (dotSite k b.offset)
  simp only [Bond.reverse, ← add_assoc, ← sub_eq_add_neg] at *
  rw [show phase + (dotSite k s - dotSite k b.offset) =
    phase + dotSite k s - dotSite k b.offset by ring]
  linear_combination (b.weight : ℝ) * hh

private theorem paired_sum (bs : List Bond) (k : WaveVector) (phase : ℝ) (s : Site) :
    ((bs ++ bs.map Bond.reverse).map fun b =>
      (b.weight : ℝ) * (mode k phase (shift s b) - mode k phase s)).sum =
    -2 * (bs.map fun b => (b.weight : ℝ) * (1 - Real.cos (dotSite k b.offset))).sum *
      mode k phase s := by
  induction bs with
  | nil => simp
  | cons b bs ih =>
    simp only [List.map_append, List.sum_append, List.map_cons, List.sum_cons] at *
    have h := bond_mode_pair k phase s b
    linear_combination h + ih

theorem native_mode_force (r : ℝ) (k : WaveVector) (phase : ℝ) (s : Site) :
    scalarForce r (mode k phase) s = -(nativeModeEnergySq r k) * mode k phase s := by
  rw [scalarForce, directedBonds, paired_sum]
  unfold nativeModeEnergySq spaceSymbol
  ring

theorem exact_mode_residual (r dt omega : ℝ) (k : WaveVector) (phase : ℝ) (s : Site) :
    scalarNext r dt (mode k (phase + dt * omega)) (mode k phase) s -
        mode k (phase - dt * omega) s =
      (timeSymbol dt omega - dt^2 * nativeModeEnergySq r k) * mode k phase s := by
  rw [scalarNext, native_mode_force]
  unfold mode timeSymbol
  have h := cos_pair (phase + dotSite k s) (dt * omega)
  rw [show phase + dt * omega + dotSite k s = phase + dotSite k s + dt * omega by ring,
      show phase - dt * omega + dotSite k s = phase + dotSite k s - dt * omega by ring]
  linear_combination -h

theorem discrete_dispersion_iff (r dt omega : ℝ) (k : WaveVector) :
    (∀ phase s, scalarNext r dt (mode k (phase + dt * omega)) (mode k phase) s =
      mode k (phase - dt * omega) s) ↔
      timeSymbol dt omega = dt^2 * nativeModeEnergySq r k := by
  constructor
  · intro h
    have hres := exact_mode_residual r dt omega k 0 (0, 0, 0)
    rw [h, sub_self] at hres
    simpa [mode, dotSite, sub_eq_zero] using hres.symm
  · intro h phase s
    apply sub_eq_zero.mp
    rw [exact_mode_residual, h, sub_self, zero_mul]

theorem timeSymbol_neg (dt omega : ℝ) : timeSymbol dt (-omega) = timeSymbol dt omega := by
  simp [timeSymbol, Real.cos_neg]

/- The arcsine selects the resolved frequency before centered-time aliasing. -/
def resolvedFrequency (dt energySq : ℝ) : ℝ :=
  2 * Real.arcsin (dt * Real.sqrt energySq / 2) / dt

theorem resolved_exact (dt energySq : ℝ) (hdt : 0 < dt) (he : 0 ≤ energySq)
    (hstable : dt * Real.sqrt energySq ≤ 2) :
    timeSymbol dt (resolvedFrequency dt energySq) = dt^2 * energySq ∧
    timeSymbol dt (-(resolvedFrequency dt energySq)) = dt^2 * energySq := by
  have harg : 0 ≤ dt * Real.sqrt energySq / 2 :=
    div_nonneg (mul_nonneg hdt.le (Real.sqrt_nonneg _)) (by norm_num)
  have hsin : Real.sin (Real.arcsin (dt * Real.sqrt energySq / 2)) =
      dt * Real.sqrt energySq / 2 := Real.sin_arcsin (by linarith) (by linarith)
  have hphase : dt * resolvedFrequency dt energySq =
      2 * Real.arcsin (dt * Real.sqrt energySq / 2) := by
    unfold resolvedFrequency
    field_simp
  suffices h : timeSymbol dt (resolvedFrequency dt energySq) = dt^2 * energySq by
    exact ⟨h, (timeSymbol_neg _ _).trans h⟩
  rw [timeSymbol, hphase, Real.cos_two_mul_eq_one_sub, hsin]
  rw [show (dt * Real.sqrt energySq / 2)^2 = dt^2 * (Real.sqrt energySq)^2 / 4 by ring,
    Real.sq_sqrt he]
  ring

end
end KleinGordonFormal
