# Claim boundary

This repository proves a scoped linearized and normalized continuum statement.
Starting from the stated two-field C19 action, it derives the site variation,
linearizes about the uniform `Psi = 0`, `chi = (19,0,0)` background, selects one
transverse `Psi` polarization, and proves its exact centered-update plane-wave
dispersion. It derives the isotropic C19 second moment `12`, explicit spatial
and temporal error bounds, and a normalized long-wave spectral readout that
converges to

```text
omega_readout^2 = 361 + 12 |k|^2.
```

Finite sums of continuum plane waves constructed from that limiting readout
are then proved to satisfy

```text
(partial_t^2 - 12 Laplacian + 361) phi = 0.
```

The normalization is part of the theorem, not an unmentioned identity: it
subtracts the native onsite rest contribution from the squared-frequency
symbol, divides the remaining long-wave shift by the squared lattice spacing,
and restores the rest contribution. The proof does **not** identify the
unscaled native phase frequency with the continuum readout frequency. It also
does not yet prove convergence of arbitrary native trajectories or a complete
space-time interpolation theorem.

The release does not prove any of the following:

- that every nonlinear solution of the native action obeys Klein–Gordon;
- completeness for arbitrary continuum initial data or infinite Fourier sums;
- a physical particle, quantum measurement rule, or experimental model;
- a native propagating massless branch at `chi = 0` (the native selected
  tangent force vanishes there); or
- that the LFM interpretation is a model of nature.

Stage 6's massless wave equation is a formal continuum corollary of the
operator algebra and is deliberately reported separately from the native
zero-`chi` result.
