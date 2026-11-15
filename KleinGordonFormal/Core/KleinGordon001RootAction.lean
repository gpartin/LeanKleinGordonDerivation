import KleinGordonFormal.Core.KleinGordonDefinitions
import Mathlib.Analysis.Calculus.Deriv.Polynomial

namespace KleinGordonFormal

noncomputable section

open TrivSqZeroExt

/-- Local potential and directed bond potential from the c40 lock. -/
def onsite [CommRing R] (c : ℝ →+* R) (q : Cell R) : R :=
  c (1 / 4) * square (rho q.chi - c (square chi0)) +
    c (1 / 2) * rho q.chi * rho q.psi + c (1 / 4) * square (rho q.psi)

def bondEnergy [CommRing R] (c : ℝ →+* R) (b : Bond) (q p : Cell R) : R :=
  c ((b.weight : ℝ) / (2 * square chi0)) *
    rho ((wedge p.chi p.psi).sub (wedge q.chi q.psi))

theorem bondEnergy_swap [CommRing R] (c : ℝ →+* R) (b : Bond) (q p : Cell R) :
    bondEnergy c b q p = bondEnergy c b p q := by
  unfold bondEnergy rho C3.sub C3.zip pairNorm square
  ring

theorem c19_geometry :
    directedBonds.length = 18 ∧ directedBonds.Nodup ∧
      (∀ b ∈ directedBonds, b.reverse ∈ directedBonds) := by
  have h : (directedBonds.all fun b => decide (b.reverse ∈ directedBonds)) = true := by decide
  refine ⟨by decide, by decide, ?_⟩
  intro b hb
  exact of_decide_eq_true ((List.all_eq_true.mp h) b hb)

theorem chi_inertia_native : chiInertia = 1197 := by
  norm_num [chiInertia, chi0, kappa]

def kinetic [CommRing R] (c : ℝ →+* R) (velocity : Cell R) : R :=
  c (1 / 2) * rho velocity.psi + c (chiInertia / 2) * rho velocity.chi

def actionDensity (q velocity : Field ℝ) (x : Site) : ℝ :=
  kinetic (RingHom.id ℝ) (velocity x) - (onsite (RingHom.id ℝ) (q x) +
    (directedBonds.map fun b => bondEnergy (RingHom.id ℝ) b (q x) (q (shift x b))).sum)

/-- Terms of the global potential that depend on a variation at x. For each
neighbor the global directed sum contains the outgoing term and its incoming
reverse, whose weight agrees by construction. -/
def incidentPotential [CommRing R] (c : ℝ →+* R)
    (q : Field R) (x : Site) (center : Cell R) : R :=
  onsite c center +
    (directedBonds.map fun b =>
      bondEnergy c b center (q (shift x b)) +
      bondEnergy c b (q (shift x b)) center).sum

abbrev Dual (R : Type) := TrivSqZeroExt R R

def makeDual (a b : R) : Dual R := (a, b)

def jetVec (u v : C3 R) : C3 (Dual R) := u.zip makeDual v

def jetCell (u v : Cell R) : Cell (Dual R) := ⟨jetVec u.psi v.psi, jetVec u.chi v.chi⟩

def constantCell [Zero R] (u : Cell R) : Cell (Dual R) := jetCell u Cell.zero

/-- The coefficient of the real site test variation in the canonical
potential. This sitewise formulation is meaningful on the infinite lattice. -/
def potentialVariation (q : Field ℝ) (x : Site) (test : Cell ℝ) : ℝ :=
  (incidentPotential (inlHom ℝ ℝ) (fun y => constantCell (q y)) x
    (jetCell (q x) test)).snd

def nativeAcceleration (q a : Field ℝ) : Prop :=
  ∀ x test, cellPairing (a x) test = -potentialVariation q x test

def centeredCell (dt : ℝ) (prev cur accel : Cell ℝ) : Cell ℝ :=
  let advance := fun (p q a : C3 ℝ) =>
    let inertial := q.zip (fun next last => 2 * next - last) p
    inertial.zip (fun value force => value + dt^2 * force) a
  ⟨advance prev.psi cur.psi accel.psi, advance prev.chi cur.chi accel.chi⟩

def nativeUpdate (dt : ℝ) (prev cur next : Field ℝ) : Prop :=
  ∃ accel : Field ℝ, nativeAcceleration cur accel ∧
    ∀ x, next x = centeredCell dt (prev x) (cur x) (accel x)

@[simp] theorem dual_pair_fst (a b : R) : TrivSqZeroExt.fst (makeDual a b) = a := rfl

@[simp] theorem dual_pair_snd (a b : R) : TrivSqZeroExt.snd (makeDual a b) = b := rfl

@[simp] theorem dual_mixed_mul [CommRing R] (x y : Dual R) :
    (x * y).snd = x.fst * y.snd + x.snd * y.fst := by
  rw [snd_mul, op_smul_eq_smul]
  simp [smul_eq_mul, mul_comm]

theorem snd_sum_eq (xs : List (Dual R)) [CommRing R] :
    xs.sum.snd = (xs.map fun j => j.snd).sum := by
  induction xs with
  | nil => rfl
  | cons _ xs ih => simp [ih]

@[simp] theorem inlHom_apply_eq [CommRing R] (r : R) :
    inlHom R R r = (inl r : Dual R) := rfl

theorem kinetic_pairing_from_action (v test : Cell ℝ) :
    (kinetic (inlHom ℝ ℝ) (jetCell v test)).snd = cellPairing v test := by
  simp [kinetic, jetCell, jetVec, C3.zip, rho, pairNorm, square, cellPairing]
  ring

def mapCell (f : R → S) (q : Cell R) : Cell S :=
  let mapVec := fun (v : C3 R) => v.zip (fun a _ => f a) v
  ⟨mapVec q.psi, mapVec q.chi⟩

theorem incident_map [CommRing R] [CommRing S] (f : R →+* S) (c : ℝ →+* R)
    (q : Field R) (x : Site) (center : Cell R) :
    f (incidentPotential c q x center) =
      incidentPotential (f.comp c) (fun y => mapCell f (q y)) x (mapCell f center) := by
  simp [incidentPotential, onsite, bondEnergy, rho, wedge, cmul, csub, C3.sub, C3.zip,
    pairNorm, square, mapCell, map_list_sum, List.map_map, Function.comp_def]

def affineCell (q u : Cell ℝ) (t : ℝ) : Cell ℝ :=
  ⟨q.psi.zip (fun a b => a + t*b) u.psi, q.chi.zip (fun a b => a + t*b) u.chi⟩

def affinePolynomial (q u : Cell ℝ) : Cell (Polynomial ℝ) :=
  let f := fun a b : ℝ => Polynomial.C a + Polynomial.X * Polynomial.C b
  ⟨q.psi.zip f u.psi, q.chi.zip f u.chi⟩

def polynomialJet [CommRing R] : Polynomial R →+* Dual R :=
  Polynomial.eval₂RingHom (inlHom R R) (makeDual 0 1)

@[simp] theorem polynomial_jet_snd [CommRing R] (p : Polynomial R) :
    (polynomialJet p).snd = p.coeff 1 := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => simp [hp, hq, Polynomial.coeff_add]
  | monomial n r =>
    rw [polynomialJet, Polynomial.coe_eval₂RingHom, Polynomial.eval₂_monomial]
    have hzero : (makeDual (0:R) 1)^2 = 0 := by
      apply TrivSqZeroExt.ext <;> simp [pow_two]
    cases n with
    | zero => simp
    | succ n =>
      cases n with
      | zero => simp
      | succ n =>
        rw [show n+1+1 = n+2 by omega, pow_add, hzero, mul_zero, mul_zero]
        simp [Polynomial.coeff_monomial]

@[simp] theorem map_affine_polynomial_eval (q u : Cell ℝ) (t : ℝ) :
    mapCell (Polynomial.eval t) (affinePolynomial q u) = affineCell q u t := by
  simp only [mapCell, affinePolynomial, affineCell, C3.zip, Polynomial.eval_add,
    Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_X]

@[simp] theorem map_affine_polynomial_jet (q u : Cell ℝ) :
    mapCell (polynomialJet (R:=ℝ)) (affinePolynomial q u) = jetCell q u := by
  have h (a b : ℝ) :
      polynomialJet (Polynomial.C a + Polynomial.X * Polynomial.C b) = makeDual a b := by
    apply TrivSqZeroExt.ext <;>
      simp [polynomialJet]
  simp only [mapCell, affinePolynomial, jetCell, jetVec, C3.zip, h]

theorem actual_real_variation (q : Field ℝ) (x : Site) (test : Cell ℝ) :
    HasDerivAt
      (fun t => incidentPotential (RingHom.id ℝ) q x (affineCell (q x) test t))
      (potentialVariation q x test) 0 := by
  let p := incidentPotential Polynomial.C (fun y => affinePolynomial (q y) Cell.zero)
    x (affinePolynomial (q x) test)
  have hEval (t : ℝ) : p.eval t =
      incidentPotential (RingHom.id ℝ) q x (affineCell (q x) test t) := by
    have he := incident_map (Polynomial.evalRingHom t) Polynomial.C
      (fun y => affinePolynomial (q y) Cell.zero) x (affinePolynomial (q x) test)
    have hc : (Polynomial.evalRingHom t).comp Polynomial.C = RingHom.id ℝ := by
      exact Polynomial.eval₂RingHom_comp_C _ _
    have hq : (fun y => affineCell (q y) Cell.zero t) = q := by
      funext y
      obtain ⟨⟨a,b,c⟩,⟨d,e,f⟩⟩ := q y
      simp [affineCell, Cell.zero, C3.zero, C3.zip]
    simpa [p, hc, hq] using he
  have hJet : (polynomialJet p).snd = potentialVariation q x test := by
    have hj := incident_map (polynomialJet (R:=ℝ)) Polynomial.C
      (fun y => affinePolynomial (q y) Cell.zero) x (affinePolynomial (q x) test)
    have hc : (polynomialJet (R:=ℝ)).comp Polynomial.C = inlHom ℝ ℝ := by
      exact Polynomial.eval₂RingHom_comp_C _ _
    have hm := congrArg (fun j : Dual ℝ => j.snd) hj
    simpa [p, hc, potentialVariation, constantCell] using hm
  have hd := p.hasDerivAt (0:ℝ)
  rw [show (fun t => p.eval t) = _ from funext hEval,
    ← Polynomial.coeff_zero_eq_eval_zero, Polynomial.coeff_derivative] at hd
  have hc := (polynomial_jet_snd p).symm.trans hJet
  simpa [hc] using hd

theorem vacuum_onsite_stationary (test : Cell ℝ) :
    (onsite (inlHom ℝ ℝ) (jetCell (vacuumCell chi0) test)).snd = 0 := by
  simp [onsite, jetCell, jetVec, C3.zip, vacuumCell, C3.zero, square, rho,
    pairNorm]

theorem vacuum_bond_stationary (b : Bond) (test : Cell ℝ) :
    (bondEnergy (inlHom ℝ ℝ) b (jetCell (vacuumCell chi0) test)
       (constantCell (vacuumCell chi0))).snd = 0 := by
  simp [bondEnergy, constantCell, jetCell, jetVec, C3.zip, C3.sub, vacuumCell,
    Cell.zero, C3.zero, square, rho, pairNorm, wedge, cmul, csub]

theorem vacuum_stationary (dt : ℝ) :
    nativeUpdate dt (fun _ => vacuumCell chi0) (fun _ => vacuumCell chi0)
      (fun _ => vacuumCell chi0) := by
  refine ⟨fun _ => Cell.zero, ?_, ?_⟩
  · intro x test
    simp [cellPairing, Cell.zero, C3.zero, potentialVariation, incidentPotential,
      snd_sum_eq, List.map_map, Function.comp_def, vacuum_onsite_stationary,
      bondEnergy_swap _ _ (constantCell _), vacuum_bond_stationary]
  · intro x
    simp [centeredCell, vacuumCell, Cell.zero, C3.zero, C3.zip]
    ring_nf

end
end KleinGordonFormal
