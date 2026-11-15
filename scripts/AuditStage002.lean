import KleinGordonFormal

namespace KleinGordonFormal

example (u : Site → ℝ) (i : Site) :
    scalarForce chi0 u i =
      -(361 : ℝ) * u i +
        2 * (directedBonds.map fun b => (b.weight : ℝ) * (u (shift i b) - u i)).sum := by
  norm_num [scalarForce, square, chi0]

example (dt : ℝ) (p q : Site → ℝ × ℝ) :
    tangentUpdate (fun _ => vacuumCell chi0) dt (polarization ∘ p) (polarization ∘ q)
      (fun x => polarization
        (scalarNext chi0 dt (fun y => (p y).1) (fun y => (q y).1) x,
         scalarNext chi0 dt (fun y => (p y).2) (fun y => (q y).2) x)) :=
  scalar_native_update chi0 dt p q

#print axioms actual_linear_response
#print axioms scalar_tangent
#print axioms scalar_native_update

end KleinGordonFormal
