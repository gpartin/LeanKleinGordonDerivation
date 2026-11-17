# LeanKleinGordonDerivation

A seven-stage Lean derivation of the free Klein–Gordon equation from the Lattice Field Medium (LFM) c40 action and centered update. The final certificate proves the following equation for finite sums of the normalized continuum modes of the selected small-wave branch.

```text
(∂ₜ² − 12∇² + 361)φ = 0
```

The public release contains all seven stages.

The word **normalized** is essential: the continuum spectral readout removes
the native onsite rest contribution, rescales the remaining long-wave shift by
the squared lattice spacing, and restores the rest contribution. The proof does
not equate the unscaled native phase frequency with the continuum readout or
prove convergence of arbitrary nonlinear trajectories. See the precise
[claim boundary](docs/CLAIM_BOUNDARY.md).

- [Stage 1](docs/STAGE_001.md) checks the locked action, its site variations, and the stationary background with `Ψ = 0` and `χ = (19, 0, 0)`.
- [Stage 2](docs/STAGE_002.md) derives the first-order lattice response on a selected Ψ polarization. Lean checks the onsite gap, C19 transport, and vanishing first-order χ acceleration on this branch.
- [Stage 3](docs/STAGE_003.md) derives the exact frequency relation on that lattice and verifies both signed frequencies for a resolved timestep.
- [Stage 4](docs/STAGE_004.md) derives the isotropic C19 coefficient and proves that the normalized long-wavelength squared-frequency readout tends to `361 + 12|k|²`. The stage documents the normalization and bounds the lattice and timestep errors.
- [Stage 5](docs/STAGE_005.md) converts that dispersion into the three-dimensional Klein–Gordon equation by taking actual derivatives of the limiting finite wave sums.
- [Stage 6](docs/STAGE_006.md) verifies the formal zero-mass wave equation and checks separately that zero background χ removes transport on the selected lattice tangent.
- [Stage 7](docs/STAGE_007.md) checks the complete chain in one certificate, including the exact lattice modes, the error bounds, and the final differential equation.

## Build and verify

Use [Elan](https://github.com/leanprover/elan) to obtain the Lean version specified by `lean-toolchain`. Lake uses the dependency revisions in `lake-manifest.json`.

```sh
lake build
lake env lean scripts/AuditStage001.lean
lake env lean scripts/AuditStage002.lean
lake env lean scripts/AuditStage003.lean
lake env lean scripts/AuditStage004.lean
lake env lean scripts/AuditStage005.lean
lake env lean scripts/AuditStage006.lean
lake env lean scripts/AuditStage007.lean
```

The PowerShell verifier also scans the promoted source and checks the audit's reported axiom dependencies.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify_stage7.ps1
```

The cross-platform release verifier performs the full build and checks the
kernel-reported axiom dependencies of the publication theorems:

```sh
python scripts/verify_release.py
```

Publication and preservation activity is recorded in the
[external submission tracker](docs/SUBMISSION_TRACKER.md).
Clean-checkout instructions are in the
[reproducibility guide](docs/REPRODUCIBILITY.md).

## License

Project-authored content is available under [MIT](LICENSE) or
[CC0-1.0](LICENSE-CC0), at the recipient's option. See
[LICENSING.md](LICENSING.md) for scope and third-party terms.
