# Stage 4 — Controlled long-wavelength limit

[Stage 3](STAGE_003.md) gives the exact C19 dispersion relation at a finite timestep. Stage 4 fixes a continuum wave vector `k` and evaluates the unchanged native recurrence at lattice wave vector `h k`, with `h` tending to zero. The squared-frequency readout `D(h) = 2[1 − cos(ωΔt)]/Δt²` equals the native energy symbol on these exact modes.

Lean computes the isotropic second moment of the C19 bonds. In native coordinate units it gives the coefficient `12`, with the same result along all three axes. The native spatial error is bounded by `h⁴ C(k)`, where `C(k) = Σ_b w_b (k·b)⁴/6` over the nine representative bonds. The centered-time error is bounded by `Δt²ω⁴/12`. In particular, for a native mode,

```text
|ω² − (361 + 12 h² |k|²)| ≤ Δt² ω⁴/12 + h⁴ C(k).
```

## The normalization and its scope

The continuum readout retains the leading spatial change above the fixed rest gap. The normalization is applied to the phase readout of an exact mode after solving the lattice recurrence.

```text
Ω(h)² = 361 + [D(h) − 361]/h²

lim Ω(h)² = 361 + 12|k|²      as h → 0
```

Lean bounds the normalized error by `h² C(k)`. It also checks exact native modes with both frequency signs for the positive timestep schedule bounded by `h²`.

The normalization matters. The [public audit](../scripts/AuditStage004.lean) checks that the unscaled `D(h)` tends to `361`. For `k = (1, 0, 0)`, the normalized limit is `373`. The continuum claim concerns the normalized long-wavelength phase readout on the selected linearized branch. Stage 5 will turn this dispersion relation into the Klein–Gordon differential equation for the resulting modes and their finite sums.

## Lean evidence

- `c19_isotropic_moment` and `c19_speed_squared` derive the spatial coefficient.
- `native_long_wave_error` bounds the lattice and timestep corrections.
- `sampled_energy_limit` and `continuum_dispersion` identify the normalized squared-frequency limit of the exact lattice modes.

The [Stage 4 proof](../KleinGordonFormal/Core/KleinGordon004Continuum.lean) comes from research commit `078b093`.
