import KleinGordonFormal

namespace KleinGordonFormal

example : C40KleinGordonCertificate := c40_yields_klein_gordon

example (ms : List ModeSpec) (t x y z : ℝ) :
    kgOperator 12 361 (waveSum ms) t x y z = 0 := by
  have h := c40_yields_klein_gordon.operatorLimit ms t x y z
  norm_num [c19_speed_squared, square, chi0] at h
  exact h

#print axioms c40_yields_klein_gordon
#print axioms derived_waves_solve_KG

end KleinGordonFormal
