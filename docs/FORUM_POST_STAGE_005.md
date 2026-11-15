Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 5

The Klein–Gordon differential equation now follows in Lean for the continuum wave family we’ve been building. In the coordinate units of the Stage 4 readout, the equation is

∂ₜ²φ − 12∇²φ + 361φ = 0

This is the familiar free Klein–Gordon form with c² = 12 and m² = 361. Here m is the rest-frequency parameter in the derivation’s units. The Laplacian ∇² adds the second derivatives along the three spatial axes.

Stage 4 gave us Ω² = 361 + 12|k|² from a normalized readout of exact c40 lattice modes. Stage 5 turns that frequency relation into a differential equation. Two time derivatives multiply a mode by −Ω². The three second spatial derivatives, added together, multiply it by −|k|². Put those into the equation and the terms cancel using the relation from Stage 4.

Lean checks the actual derivatives and proves the equation for any finite sum of the resulting modes. It also verifies that the finite sums reconstructed from the normalized lattice readouts converge point by point to those continuum waves. The claim is about that wave family on the prepared small-wave branch.

Stage 6 will set the mass term to zero in the continuum equation and compare that with setting χ to zero in the original lattice equations.

Stage 5 and the build instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation
