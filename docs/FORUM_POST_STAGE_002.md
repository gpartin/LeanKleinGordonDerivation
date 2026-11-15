Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 2

Stage 1 verified that the c40 lattice has a steady background with Ψ = 0 and χ = (19, 0, 0) at every site. In Stage 2, we ask how that lattice responds to a small disturbance in Ψ.

We choose the disturbance to point in an internal direction perpendicular to the background χ. Lean differentiates the same c40 action from Stage 1 and checks the response in both fields. At first order, the disturbance stays in the selected Ψ direction and produces zero acceleration in χ. That is what lets us describe this branch with one complex wave amplitude u at each site.

For either the real or imaginary part of u, the lattice acceleration is

a(i) = −361 u(i) + 2 Σₙ wₙ [u(i+n) − u(i)]

The first term is the local restoring response. Its coefficient comes from χ₀² = 19² in the interaction between the two fields. The second term carries the disturbance between neighboring sites. It uses the C19 weights, and its factor of 2 comes from counting the incoming and outgoing contributions to the variation at a site.

Lean also verifies the centered timestep update for this wave branch. We now have a small-wave equation on the original lattice. In Stage 3, we’ll use it to work out exactly how a wave’s frequency depends on its wavelength and the timestep.

Stage 2 and the build instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation
