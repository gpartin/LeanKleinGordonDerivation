# Stage 3 — Exact lattice dispersion

[Stage 2](STAGE_002.md) derives a scalar centered update for the chosen small-wave branch. Stage 3 evaluates that update on a three-dimensional lattice mode of the form `uᵢⁿ = cos(θ + k·i − nΔtω)`. Here `k` is the wave vector measured in inverse lattice spacings and `ω` is the angular frequency in the native time coordinate.

At the prepared background with `χ₀ = 19`, the resulting condition is

```text
2[1 − cos(ωΔt)] = Δt² [361 + S(k)]

S(k) = 4 Σ_b w_b [1 − cos(k·b)].
```

The sum takes one representative from each of the nine opposite C19 bond pairs. `S(k)` accounts for the spatial lattice and the cosine on the left comes from the two adjacent time layers. At zero wave number the spatial contribution vanishes.

## What Lean checks

- `native_mode_force` computes the action of the full Stage 2 spatial force on the mode by pairing reverse bonds.
- `exact_mode_residual` expresses the difference between the prescribed next layer and the Stage 2 update through the frequency condition. `discrete_dispersion_iff` proves necessity and sufficiency for the mode family, using the value at zero site and phase to rule out a vacuous cancellation.
- `resolved_exact` verifies both signed frequencies on the principal centered-time branch. For `E² = 361 + S(k)`, a positive timestep, and `Δt√(E²) ≤ 2`, those frequencies are `±(2/Δt) arcsin(Δt√(E²)/2)`.

This is a finite-lattice, finite-timestep identity for the linearized branch. Stage 4 will control the long-wavelength and timestep errors and specify the continuum readout.

The [Lean source](../KleinGordonFormal/Core/KleinGordon003LatticeDispersion.lean) comes from research commit `078b093`. The [public audit](../scripts/AuditStage003.lean) checks the exact relation at the prepared background and the two frequency signs.
