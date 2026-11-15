Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 7 and conclusion

Stage 7 brings the full derivation together in one Lean certificate. The exact equation it verifies for the continuum waves in this derivation is

∂ₜ²φ − 12∇²φ + 361φ = 0

This is the free three-dimensional Klein–Gordon equation in the coordinate units of the Stage 4 readout. The squared rest-frequency gap 361 comes from the local c40 interaction. The spatial coefficient 12 comes from the weighted C19 neighbor bonds.

The certificate connects the first six stages. We checked the c40 action and its stationary background, derived the response of a small Ψ disturbance, and solved its exact frequency relation on the lattice. We bounded the spatial and timestep errors, took the normalized long-wavelength readout, and checked the actual time and spatial derivatives for finite sums of the resulting modes. We also checked the formal zero-mass wave equation and the separate lattice calculation in which setting χ to zero removes spatial coupling on this branch.

The normalization is part of the result. In Stage 4 we read the phase of exact lattice modes, subtracted the rest gap from the squared-frequency readout, divided the difference by the squared spacing scale, and restored the gap. The unscaled readout tends to the rest gap alone. The normalized readout retains the spatial term, and the certificate proves Klein–Gordon for the finite wave sums built from it on the prepared small-wave branch.

All seven stages now pass the cumulative Lean verifier. The final audit checks the numerical coefficients and reports only Lean’s standard foundational axioms.

The full source and replay instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation

To check the final certificate from the repo, run

lake build
lake env lean scripts/AuditStage007.lean

That closes the seven-stage derivation. Thanks for following it and checking the steps with us.
