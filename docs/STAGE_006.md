# Stage 6 — The formal mass-zero wave equation

[Stage 5](STAGE_005.md) proves the Klein–Gordon equation for finite sums from the normalized continuum readout. Stage 6 considers setting its continuum mass coefficient to zero while retaining the spatial coefficient `c² = 12`.

```text
Ω² = 12 |k|²

∂ₜ²φ − 12∇²φ = 0
```

`formal_massless_dispersion` verifies the frequency relation for either sign, and `formal_wave_equation` proves the wave equation for finite sums of these continuum modes. This is a mathematical specialization of the continuum operator.

The lattice calculation asks a separate question. Set the background χ to zero on the selected scalar tangent and keep the locked c40 constants. In the Stage 2 native force, both the local gap and the coefficient multiplying the C19 neighbor sum then vanish. `zero_chi_native_force` and `zero_chi_native_band` verify this for every lattice configuration of the selected scalar tangent and every wave vector, respectively. Its centered update reduces to

```text
u_next(i) = 2 u_current(i) − u_previous(i).
```

The spatial coupling disappears on this zero-χ tangent. The two results specify the distinction between the formal zero-mass wave equation and the lattice response on this branch.

The [Stage 6 proof](../KleinGordonFormal/Core/KleinGordon006MasslessCorollary.lean) comes from research commit `078b093`. The [public audit](../scripts/AuditStage006.lean) checks both equations and tests their frequency symbols at the same nonzero wave vector. Stage 7 will assemble the complete certificate.
