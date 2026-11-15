# Stage 5 — The three-dimensional Klein–Gordon equation

[Stage 4](STAGE_004.md) derives the normalized continuum dispersion `Ω² = 361 + 12|k|²` from the selected linearized c40 branch. Stage 5 uses those frequencies to prove the differential equation in the continuum coordinates of that readout.

```text
(∂ₜ² − 12∇² + 361)φ = 0

∇² = ∂²/∂x² + ∂²/∂y² + ∂²/∂z²
```

For each mode, two time derivatives multiply its amplitude by `−Ω²`. The sum of its three second spatial derivatives multiplies it by `−|k|²`. The dispersion relation cancels the resulting terms. The same identity holds for a finite sum of the modes and applies separately to the real and imaginary parts of the complex scalar amplitude.

## What Lean checks

- `sampled_wave_sum_limit` proves pointwise convergence of the finite sums reconstructed from the normalized phase readouts in Stage 4.
- `second_affine_cos_sum` uses actual first and second derivatives of the finite mode sums. `laplacian` sums the second derivatives along all three spatial axes.
- `derived_waves_solve_KG` checks that the operator vanishes everywhere on the resulting family, with the frequency condition supplied by `continuum_dispersion`.

The theorem is scoped to finite superpositions of the normalized continuum modes of the prepared small-wave branch. It uses coordinate units and a pointwise limit of the reconstructed waves. Stage 6 will examine the formal zero-mass specialization.

The [Stage 5 proof](../KleinGordonFormal/Core/KleinGordon005Operator.lean) comes from research commit `078b093`. The [public audit](../scripts/AuditStage005.lean) checks the expanded equation with numeric coefficients, the convergence theorem, and a nonzero member of the mode family.
