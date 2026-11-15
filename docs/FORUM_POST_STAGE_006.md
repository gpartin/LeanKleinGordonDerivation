Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 6

Stage 5 proved the free Klein–Gordon equation for continuum waves reconstructed from the normalized c40 lattice readout. Stage 6 asks what happens if we set the mass term in that continuum equation to zero and keep its spatial coefficient.

∂ₜ²φ − 12∇²φ = 0

This is the ordinary three-dimensional wave equation in the units of the derivation. Lean verifies it for finite sums of modes with Ω² = 12|k|².

We then checked what happens if we set the background χ to zero in the original lattice calculation. On the small-wave branch used in this derivation, χ supplies both the local restoring term and the coupling that lets neighboring sites influence one another. With χ set to zero, both contributions vanish. The update can still carry each site’s initial motion forward, but there is no spatial coupling on this branch to carry a wave from site to site.

The continuum specialization keeps the spatial term, while the zero-χ lattice calculation loses it. Stage 7 will bring the full derivation and its checks together in one Lean certificate.

Stage 6 and the build instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation
