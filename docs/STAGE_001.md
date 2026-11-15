# Stage 1 — Locked action and stationary background

## Starting equations

Each site carries complex three-vectors `Ψᵢ` and `χᵢ`. Write `ρΨ(i) = ‖Ψᵢ‖²`, `ρχ(i) = ‖χᵢ‖²`, and `Wᵢ = χᵢ ∧ Ψᵢ`. The latter is computed from the two fields. The C19 neighborhood includes the site itself, six face neighbors of weight 2 and twelve edge neighbors of weight 1. The bond sum runs over the 18 directed neighbor offsets, excluding the center, with equal weights for reverse directions.

```text
χ₀ = 19       κ = 1/63       B = χ₀/κ = 1197

L = T − U
T = Σᵢ [½‖Ψ̇ᵢ‖² + (B/2)‖χ̇ᵢ‖²]

U = U_local + U_bond
U_local = Σᵢ [¼(ρχ(i) − χ₀²)² + ½ρχ(i)ρΨ(i) + ¼ρΨ(i)²]
U_bond  = Σᵢ Σₙ [wₙ/(2χ₀²)] ‖Wᵢ₊ₙ − Wᵢ‖²

Ψ̈ᵢ = −∇_{Ψᵢ} U
Bχ̈ᵢ = −∇_{χᵢ} U

qᵢⁿ⁺¹ = 2qᵢⁿ − qᵢⁿ⁻¹ + Δt² aᵢ(qⁿ)
```

The gradients act on the real and imaginary coordinates. The site variation includes both the outgoing and incoming bonds, as required by the directed sum. The centered update advances both fields from the same committed time layers.

## Lean checks

- `c19_geometry` verifies the directed bond count, absence of duplicate bonds, and presence of each reverse bond with the same weight.
- `chi_inertia_native` verifies the value of `B`. `kinetic_pairing_from_action` computes the inertial pairing from the kinetic term.
- `actual_real_variation` checks the potential variation for arbitrary real test directions in both complex fields.
- `vacuum_stationary` proves that three successive identical layers with `Ψᵢ = 0` and `χᵢ = (χ₀, 0, 0)` satisfy the full two-field centered update.

Stage 1 establishes the background for the small-wave calculation. The branch, dispersion, long-wavelength readout, and Klein–Gordon operator are the subjects of later stages.

The stage source and its shared definitions come from research commit `078b093`. The governing c40 lock used in research has SHA-256 `00f147f3bc8e496d17bb4a9577c44e0c99942c32af3323b0b342666acd39487c`.
