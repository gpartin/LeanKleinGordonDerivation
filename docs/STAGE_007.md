# Stage 7 — Final certificate and audit

`c40_yields_klein_gordon` proves the single proposition `C40KleinGordonCertificate`. It brings together the following evidence.

- The c40 action variations, inertia, C19 geometry, and stationary homogeneous background.
- The exact signed lattice modes on the polarization selected by the linearized reciprocal update.
- The spatial and temporal error bounds, normalized energy limit, and pointwise convergence of the reconstructed finite wave sums.
- The Klein–Gordon equation for those sums, the formal zero-mass wave equation, and the separate zero-χ lattice result.

The certificate's `operatorLimit` field gives the following equation in the coordinate units of the normalized Stage 4 readout.

```text
∂ₜ²φ − 12∇²φ + 361φ = 0
```

The `361` is the squared rest-frequency gap from the onsite response. The `12` comes from the isotropic C19 bond moment. The frequencies in the operator theorem come from the normalized phase readouts of exact lattice modes. The [Stage 4 audit](../scripts/AuditStage004.lean) also checks the unnormalized limit, which retains the rest gap alone. The certificate concerns finite superpositions on the selected linearized branch.

The [Stage 7 audit](../scripts/AuditStage007.lean) checks the full certificate, specializes its operator field to coefficients 12 and 361, and prints the kernel axiom dependencies of the final certificate and the underlying operator theorem. The [cumulative verifier](../scripts/verify_stage7.ps1) runs the full seven-stage check.

The [certificate source](../KleinGordonFormal/Core/KleinGordon007Certificate.lean) and final audit come from research commit `078b093`.
