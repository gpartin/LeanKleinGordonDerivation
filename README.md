# LeanKleinGordonDerivation

A staged Lean derivation of the free Klein–Gordon equation from the Lattice Field Medium (LFM) c40 action and centered update. We are testing whether the long-wavelength behavior of a selected small-wave branch has the form

```text
(∂ₜ² − c²∇² + m²)φ = 0
```

The public release contains the first two stages.

- [Stage 1](docs/STAGE_001.md) checks the locked action, its site variations, and the stationary background with `Ψ = 0` and `χ = (19, 0, 0)`.
- [Stage 2](docs/STAGE_002.md) derives the first-order lattice response on a selected Ψ polarization. Lean checks the onsite gap, C19 transport, and vanishing first-order χ acceleration on this branch.

## Build and verify

Use [Elan](https://github.com/leanprover/elan) to obtain the Lean version specified by `lean-toolchain`. Lake uses the dependency revisions in `lake-manifest.json`.

```sh
lake build
lake env lean scripts/AuditStage001.lean
lake env lean scripts/AuditStage002.lean
```

The PowerShell verifier also scans the promoted source and checks the audit's reported axiom dependencies.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify_stage2.ps1
```
