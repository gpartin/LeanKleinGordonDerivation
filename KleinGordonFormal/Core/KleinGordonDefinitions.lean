import Mathlib.Data.Real.Basic
import Mathlib.Algebra.TrivSqZeroExt.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

namespace KleinGordonFormal

noncomputable section

/-- Three complex coordinates, presented as real and imaginary parts. The coefficient
ring also admits a first-order variation and a mixed first-order variation. -/
structure C3 (R : Type) where
  a : R × R
  b : R × R
  c : R × R

def C3.zip (f : R → S → T) (u : C3 R) (v : C3 S) : C3 T :=
  ⟨(f u.a.1 v.a.1, f u.a.2 v.a.2), (f u.b.1 v.b.1, f u.b.2 v.b.2),
    (f u.c.1 v.c.1, f u.c.2 v.c.2)⟩

def C3.zero [Zero R] : C3 R := ⟨(0, 0), (0, 0), (0, 0)⟩

def C3.sub [Sub R] (u v : C3 R) : C3 R := u.zip (· - ·) v

def square [Mul R] (x : R) : R := x * x

def pairNorm [Add R] [Mul R] (z : R × R) : R := square z.1 + square z.2

def rho [Add R] [Mul R] (u : C3 R) : R :=
  pairNorm u.a + pairNorm u.b + pairNorm u.c

def cmul [Ring R] (z w : R × R) : R × R :=
  (z.1 * w.1 - z.2 * w.2, z.1 * w.2 + z.2 * w.1)

def csub [Sub R] (z w : R × R) : R × R := (z.1 - w.1, z.2 - w.2)

def wedge [Ring R] (u v : C3 R) : C3 R :=
  ⟨csub (cmul u.a v.b) (cmul u.b v.a), csub (cmul u.a v.c) (cmul u.c v.a),
    csub (cmul u.b v.c) (cmul u.c v.b)⟩

abbrev Site := ℤ × ℤ × ℤ

structure Bond where
  offset : Site
  weight : ℕ
  deriving DecidableEq

def Bond.reverse (b : Bond) : Bond :=
  ⟨(-b.offset.1, -b.offset.2.1, -b.offset.2.2), b.weight⟩

def positiveBonds : List Bond :=
  [⟨(1, 0, 0), 2⟩, ⟨(0, 1, 0), 2⟩, ⟨(0, 0, 1), 2⟩,
   ⟨(1, 1, 0), 1⟩, ⟨(1, -1, 0), 1⟩, ⟨(1, 0, 1), 1⟩, ⟨(1, 0, -1), 1⟩,
   ⟨(0, 1, 1), 1⟩, ⟨(0, 1, -1), 1⟩]

def directedBonds : List Bond := positiveBonds ++ positiveBonds.map Bond.reverse

def shift (x : Site) (b : Bond) : Site :=
  (x.1 + b.offset.1, x.2.1 + b.offset.2.1, x.2.2 + b.offset.2.2)

def chi0 : ℝ := 19

def kappa : ℝ := 1 / 63

def chiInertia : ℝ := chi0 / kappa

structure Cell (R : Type) where
  psi : C3 R
  chi : C3 R

abbrev Field (R : Type) := Site → Cell R

def Cell.zero [Zero R] : Cell R := ⟨C3.zero, C3.zero⟩

def vacuumCell (radius : ℝ) : Cell ℝ :=
  ⟨C3.zero, ⟨(radius, 0), (0, 0), (0, 0)⟩⟩

/-- A candidate complex polarization, orthogonal to the prepared chi direction. -/
def polarization (z : ℝ × ℝ) : Cell ℝ :=
  ⟨⟨(0, 0), z, (0, 0)⟩, C3.zero⟩

def cellPairing (u v : Cell ℝ) : ℝ :=
  let pairing := fun (x y : C3 ℝ) =>
    x.a.1*y.a.1 + x.a.2*y.a.2 + x.b.1*y.b.1 + x.b.2*y.b.2 + x.c.1*y.c.1 + x.c.2*y.c.2
  pairing u.psi v.psi + chiInertia * pairing u.chi v.chi

end
end KleinGordonFormal
