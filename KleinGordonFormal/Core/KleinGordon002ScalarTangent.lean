import KleinGordonFormal.Core.KleinGordon001RootAction

namespace KleinGordonFormal

noncomputable section
open TrivSqZeroExt

/-- First vary the c40 configuration, then take the real site variation
that defines both forces. Two independent nilpotents retain their mixed
coefficient, the Hessian applied to the perturbation and the site test. -/
def potentialTangent (q u : Field ℝ) (x : Site) (test : Cell ℝ) : ℝ :=
  (incidentPotential ((inlHom (Dual ℝ) (Dual ℝ)).comp (inlHom ℝ ℝ))
    (fun y => constantCell (jetCell (q y) (u y))) x
    (jetCell (jetCell (q x) (u x)) (constantCell test))).snd.snd

def tangentAcceleration (q u a : Field ℝ) : Prop :=
  ∀ x test, cellPairing (a x) test = -potentialTangent q u x test

def tangentUpdate (q : Field ℝ) (dt : ℝ) (prev cur next : Field ℝ) : Prop :=
  ∃ a : Field ℝ, tangentAcceleration q cur a ∧
    ∀ x, next x = centeredCell dt (prev x) (cur x) (a x)

private def mapDual [CommRing R] [CommRing S] (f : R →+* S) : Dual R →+* Dual S where
  toFun j := makeDual (f j.fst) (f j.snd)
  map_one' := by apply TrivSqZeroExt.ext <;> simp
  map_zero' := by apply TrivSqZeroExt.ext <;> simp
  map_mul' x y := by apply TrivSqZeroExt.ext <;> simp
  map_add' x y := by apply TrivSqZeroExt.ext <;> simp

private theorem mapDual_snd [CommRing R] [CommRing S] (f : R →+* S) (j : Dual R) :
    TrivSqZeroExt.snd (mapDual f j) = f j.snd := rfl

private theorem mapDual_jetCell [CommRing R] [CommRing S] (f : R →+* S)
    (q u : Cell R) :
    mapCell (mapDual f) (jetCell q u) = jetCell (mapCell f q) (mapCell f u) := by
  simp [mapCell, mapDual, jetCell, jetVec, C3.zip]

private theorem mapCell_zero [CommRing R] [CommRing S] (f : R →+* S) :
    mapCell f Cell.zero = Cell.zero := by
  simp [mapCell, Cell.zero, C3.zero, C3.zip]

private theorem mapDual_constantCell [CommRing R] [CommRing S] (f : R →+* S)
    (q : Cell R) :
    mapCell (mapDual f) (constantCell q) = constantCell (mapCell f q) := by
  simp only [constantCell, mapDual_jetCell, mapCell_zero]

private def variationPolynomial (q u : Field ℝ) (x : Site) (test : Cell ℝ) : Polynomial ℝ :=
  (incidentPotential ((inlHom _ _).comp Polynomial.C)
    (fun y => constantCell (affinePolynomial (q y) (u y))) x
    (jetCell (affinePolynomial (q x) (u x)) (affinePolynomial test Cell.zero))).snd

private theorem variation_polynomial_map [CommRing R] (f : Polynomial ℝ →+* R)
    (q u : Field ℝ) (x : Site) (test : Cell ℝ) :
    f (variationPolynomial q u x test) =
    (incidentPotential ((inlHom R R).comp (f.comp Polynomial.C))
      (fun y => constantCell (mapCell f (affinePolynomial (q y) (u y)))) x
      (jetCell (mapCell f (affinePolynomial (q x) (u x)))
        (mapCell f (affinePolynomial test Cell.zero)))).snd := by
  have hm := incident_map (mapDual f) ((inlHom _ _).comp Polynomial.C)
    (fun y => constantCell (affinePolynomial (q y) (u y))) x
    (jetCell (affinePolynomial (q x) (u x)) (affinePolynomial test Cell.zero))
  have hc : (mapDual f).comp ((inlHom _ _).comp Polynomial.C) =
      (inlHom R R).comp (f.comp Polynomial.C) := by
    apply RingHom.ext
    intro t
    apply TrivSqZeroExt.ext <;> simp [mapDual]
  rw [hc] at hm
  have hd := congrArg (fun j : Dual R => j.snd) hm
  simpa only [variationPolynomial, mapDual_snd, mapDual_jetCell,
    mapDual_constantCell] using hd

theorem actual_linear_response (q u : Field ℝ) (x : Site) (test : Cell ℝ) :
    HasDerivAt (fun t => potentialVariation (fun y => affineCell (q y) (u y) t) x test)
      (potentialTangent q u x test) 0 := by
  let p := variationPolynomial q u x test
  have heval (t : ℝ) : p.eval t =
      potentialVariation (fun y => affineCell (q y) (u y) t) x test := by
    have hc : (Polynomial.evalRingHom t).comp Polynomial.C = RingHom.id ℝ := by
      exact Polynomial.eval₂RingHom_comp_C _ _
    have hz : affineCell test Cell.zero t = test := by
      obtain ⟨⟨a,b,c⟩,⟨d,e,f⟩⟩ := test
      simp [affineCell, Cell.zero, C3.zero, C3.zip]
    simpa [p, hc, hz, potentialVariation] using
      variation_polynomial_map (Polynomial.evalRingHom t) q u x test
  have hjet : (polynomialJet p).snd = potentialTangent q u x test := by
    have hc : (polynomialJet (R:=ℝ)).comp Polynomial.C = inlHom ℝ ℝ := by
      exact Polynomial.eval₂RingHom_comp_C _ _
    have hm := congrArg (fun j : Dual ℝ => j.snd)
      (variation_polynomial_map (polynomialJet (R:=ℝ)) q u x test)
    simpa [p, hc, potentialTangent, constantCell] using hm
  have hd := p.hasDerivAt (0:ℝ)
  rw [show (fun t => p.eval t) = _ from funext heval,
    ← Polynomial.coeff_zero_eq_eval_zero, Polynomial.coeff_derivative] at hd
  have hc := (polynomial_jet_snd p).symm.trans hjet
  simpa [hc] using hd

def scalarForce (radius : ℝ) (u : Site → ℝ) (x : Site) : ℝ :=
  -(square radius) * u x +
    (2 * square radius / square chi0) *
      (directedBonds.map fun b => (b.weight : ℝ) * (u (shift x b) - u x)).sum

private def mixedCenter (r : ℝ) (z : ℝ × ℝ) (test : Cell ℝ) :
    Cell (Dual (Dual ℝ)) :=
  jetCell (jetCell (vacuumCell r) (polarization z)) (constantCell test)

private def mixedNeighbor (r : ℝ) (z : ℝ × ℝ) :
    Cell (Dual (Dual ℝ)) :=
  constantCell (jetCell (vacuumCell r) (polarization z))

private abbrev liftReal : ℝ →+* Dual (Dual ℝ) :=
  (inlHom (Dual ℝ) (Dual ℝ)).comp (inlHom ℝ ℝ)

theorem onsite_tangent (r : ℝ) (z : ℝ × ℝ) (test : Cell ℝ) :
    (onsite liftReal (mixedCenter r z test)).snd.snd =
      square r * (z.1 * test.psi.b.1 + z.2 * test.psi.b.2) := by
  simp [onsite, liftReal, mixedCenter, constantCell, jetCell, jetVec, C3.zip,
    vacuumCell, polarization, Cell.zero, C3.zero, square, rho, pairNorm,
    RingHom.comp_apply]
  ring

theorem bond_tangent (r : ℝ) (b : Bond) (z w : ℝ × ℝ) (test : Cell ℝ) :
    (bondEnergy liftReal b (mixedCenter r z test) (mixedNeighbor r w)).snd.snd =
      (b.weight : ℝ) * square r / square chi0 *
        ((z.1 - w.1) * test.psi.b.1 + (z.2 - w.2) * test.psi.b.2) := by
  simp [bondEnergy, liftReal, mixedCenter, mixedNeighbor, constantCell,
    jetCell, jetVec, C3.zip, C3.sub, vacuumCell, polarization, Cell.zero,
    C3.zero, square, rho, pairNorm, wedge, cmul, csub, RingHom.comp_apply, chi0]
  ring

private theorem sum_force_pairing (bs : List Bond) (r : ℝ) (u : Site → ℝ × ℝ)
    (x : Site) (test : Cell ℝ) :
    (bs.map fun b => (2 * ((b.weight : ℝ) * square r / square chi0) *
      (((u x).1 - (u (shift x b)).1) * test.psi.b.1 +
        ((u x).2 - (u (shift x b)).2) * test.psi.b.2))).sum =
      -(2 * square r / square chi0) *
      ((bs.map fun b => (b.weight : ℝ) * ((u (shift x b)).1 - (u x).1)).sum * test.psi.b.1 +
       (bs.map fun b => (b.weight : ℝ) * ((u (shift x b)).2 - (u x).2)).sum * test.psi.b.2) := by
  induction bs with
  | nil => simp
  | cons b bs ih =>
    simp only [List.map_cons, List.sum_cons]
    rw [ih]
    ring

theorem scalar_tangent (r : ℝ) (u : Site → ℝ × ℝ) :
    tangentAcceleration (fun _ => vacuumCell r) (polarization ∘ u)
      (fun x => polarization (scalarForce r (fun y => (u y).1) x,
        scalarForce r (fun y => (u y).2) x)) := by
  intro x test
  change cellPairing (polarization _) test =
    -(onsite liftReal (mixedCenter r (u x) test) +
      (directedBonds.map fun b =>
        bondEnergy liftReal b (mixedCenter r (u x) test) (mixedNeighbor r (u (shift x b))) +
        bondEnergy liftReal b (mixedNeighbor r (u (shift x b))) (mixedCenter r (u x) test)).sum).snd.snd
  simp only [TrivSqZeroExt.snd_add, snd_sum_eq, List.map_map, Function.comp_def,
    bondEnergy_swap _ _ (mixedNeighbor _ _), bond_tangent, onsite_tangent]
  simp only [← two_mul, ← mul_assoc]
  rw [sum_force_pairing]
  simp [cellPairing, polarization, C3.zero, scalarForce]
  ring

def scalarNext (r dt : ℝ) (prev cur : Site → ℝ) (x : Site) : ℝ :=
  2 * cur x - prev x + dt^2 * scalarForce r cur x

theorem scalar_native_update (r dt : ℝ) (p q : Site → ℝ × ℝ) :
    tangentUpdate (fun _ => vacuumCell r) dt (polarization ∘ p) (polarization ∘ q)
      (fun x => polarization (scalarNext r dt (fun y => (p y).1) (fun y => (q y).1) x,
        scalarNext r dt (fun y => (p y).2) (fun y => (q y).2) x)) := by
  refine ⟨_, scalar_tangent r q, ?_⟩
  intro x
  simp [centeredCell, polarization, C3.zero, C3.zip, scalarNext]

end
end KleinGordonFormal
