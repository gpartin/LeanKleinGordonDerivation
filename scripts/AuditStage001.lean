import KleinGordonFormal

namespace KleinGordonFormal

example : directedBonds.length = 18 ∧ directedBonds.Nodup ∧
    (∀ b ∈ directedBonds, b.reverse ∈ directedBonds) :=
  c19_geometry

example : chiInertia = 1197 :=
  chi_inertia_native

example (dt : ℝ) :
    nativeUpdate dt (fun _ => vacuumCell chi0) (fun _ => vacuumCell chi0)
      (fun _ => vacuumCell chi0) :=
  vacuum_stationary dt

#print axioms kinetic_pairing_from_action
#print axioms actual_real_variation
#print axioms vacuum_stationary

end KleinGordonFormal
