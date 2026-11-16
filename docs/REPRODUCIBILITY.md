# Reproducibility

## Pinned environment

- Lean: `v4.33.1`
- Mathlib: `v4.33.1`, with transitive revisions pinned by `lake-manifest.json`
- Package: `LeanKleinGordonDerivation`
- Public entrypoint: `KleinGordonFormal.lean`
- Publication audit: `KleinGordonFormal/PublicationAudit.lean`

## Clean checkout

```text
git clone https://github.com/gpartin/LeanKleinGordonDerivation.git
cd LeanKleinGordonDerivation
python scripts/verify_release.py
```

The verifier builds the complete public library, asks Lean's kernel to report
the axiom dependencies of the cumulative certificate and final operator
theorem, and rejects any dependency outside Lean's standard `propext`,
`Classical.choice`, and `Quot.sound` foundations.

Windows users may also run the ordered stage verifier:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify_stage7.ps1
```

Read [CLAIM_BOUNDARY.md](CLAIM_BOUNDARY.md) before interpreting the final
certificate. In particular, the continuum frequency is an explicitly
normalized spectral readout, not the unscaled native phase frequency.
