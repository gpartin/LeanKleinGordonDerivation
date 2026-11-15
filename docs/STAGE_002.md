# Stage 2 — Small-wave response from the action

Stage 2 starts with the two-field potential variation and centered update checked in [Stage 1](STAGE_001.md). It studies first-order departures from the uniform stationary background with `Ψᵢ = 0` and `χᵢ = (χ₀, 0, 0)`.

## What Lean checks

- `actual_linear_response` proves that the linearized force pairing is the derivative of the Stage 1 variation along arbitrary two-field perturbations.
- `onsite_tangent` and `bond_tangent` compute the onsite and bond contributions. The test direction can involve any component of Ψ or χ.
- `scalar_tangent` checks that a perturbation in the Ψ direction orthogonal to the background χ stays in the selected polarization. The first-order χ acceleration is zero on this branch.
- `scalar_native_update` carries that result into the centered lattice update for both real components of the complex amplitude.

At the declared background, each component `u` of the selected wave obeys the following native acceleration law.

```text
a(i) = −χ₀² u(i) + 2 Σₙ wₙ [u(i+n) − u(i)]
     = −361 u(i) + 2 Σₙ wₙ [u(i+n) − u(i)].
```

The onsite squared gap comes from the `½ ρχ ρΨ` term. The sum uses the 18 directed C19 offsets from Stage 1, and the factor of 2 comes from the incoming and outgoing contributions in the site variation. The formula holds in the selected linearized branch. Stage 3 will use it to derive the exact relation between spatial wave number and frequency at a finite timestep.

The [Lean source](../KleinGordonFormal/Core/KleinGordon002ScalarTangent.lean) comes from research commit `078b093`. [The public audit](../scripts/AuditStage002.lean) checks the specialized lattice law and centered update.
