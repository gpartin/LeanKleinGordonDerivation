# LeanKleinGordonDerivation

A staged Lean derivation of the free Klein–Gordon equation from the Lattice Field Medium (LFM) c40 action and centered update. We are testing whether the long-wavelength behavior of a selected small-wave branch has the form

```text
(∂ₜ² − c²∇² + m²)φ = 0
```

The first public release contains **Stage 1, the locked action and stationary background**. Lean checks the C19 bond list, both fields' inertia, and the real site variations of the potential. It then proves that a homogeneous cell with `Ψ = 0` and `χ = (19, 0, 0)` remains fixed under the centered update. The [Stage 1 notes](docs/STAGE_001.md) give the equations, scope, and theorem names.

## Build and verify

Use [Elan](https://github.com/leanprover/elan) to obtain the Lean version specified by `lean-toolchain`. Lake uses the dependency revisions in `lake-manifest.json`.

```sh
lake build
lake env lean scripts/AuditStage001.lean
```

The PowerShell verifier also scans the promoted source and checks the audit's reported axiom dependencies.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify_stage1.ps1
```
