# External submission tracker

Last reconciled: 2026-11-17 (America/Los_Angeles)

This ledger separates source publication, immutable preservation, formal
verification, curated listings, and community publicity. A listing is not an
endorsement of the physical interpretation. The public claim is limited to
the linearized selected polarization and the explicitly normalized continuum
spectral readout described in [CLAIM_BOUNDARY.md](CLAIM_BOUNDARY.md).

| Destination | Scope | Status | Last event | Next action | Follow-up date |
| --- | --- | --- | --- | --- | --- |
| Production verification | Full seven-stage package | PASS | Linux CI run [43920990123](https://github.com/gpartin/LeanKleinGordonDerivation/actions/runs/43920990123) passed before release; all seven stages and the publication axiom audit pass | Re-run for every release-changing commit | Each release |
| [GitHub repository](https://github.com/gpartin/LeanKleinGordonDerivation) | Full seven-stage package | Released | Release [`v0.7.0-research`](https://github.com/gpartin/LeanKleinGordonDerivation/releases/tag/v0.7.0-research) was published from audited `main` | Preserve tag and monitor downstream reports | Ongoing |
| [Zenodo](https://zenodo.org/records/24287570) | Full archived release | Published | Standalone software record published with DOI [`10.5281/zenodo.24287570`](https://doi.org/10.5281/zenodo.24287570) | Keep future versions linked under the same concept record | Next release |
| [Software Heritage request 2656289](https://archive.softwareheritage.org/api/1/origin/save/2656289/) | Full Git history | Accepted/pending ingestion | Save request accepted for the public GitHub origin | Recheck until a snapshot identifier is assigned | 2026-11-23 |
| [Palomar Registry package](https://github.com/gpartin/LeanKleinGordonPalomar) | Bounded C19 isotropy/error theorem | Preflight passed; intake authorization required | Exact public commit `957ed546c7d6de1c88dc82eb6ce85d9c3124ee9d` passed official [Palomar preflight](https://github.com/gpartin/LeanKleinGordonPalomar/actions/runs/43939664133); the comparator names only three bounded C19 declarations | Obtain exact maintainer authorization for this repository, commit, `comparator.json`, and author relationship; then run intake. Permanent registration remains a later separate decision | On authorization |
| [Lax `lax-161794`](https://laxarchive.org/lax-161794/) | Bounded C19 isotropy/error theorem | Permanently registered; immutable and citable | G. D. Partin explicitly approved irreversible registration on 2026-11-17. Lax permanently registered the validated source commit `d216e639e4f9dfec6806c2cd64fab5bd2a0722c0`; [registration workflow 44095220144](https://github.com/lax-archive/lax/actions/runs/44095220144) completed successfully, while [control issue #229](https://github.com/lax-archive/lax/issues/229) preserves submission provenance | None; cite as `\cite{lax-161794}` and publish a new concept only for a materially different formal result | Closed |
| [Lemmata PR #21](https://github.com/ZIB-IOL/lemmata/pull/21) | Bounded C19 isotropy/error theorem | Pull request submitted; awaiting maintainer workflow/review | Exact contribution commit `5c1d75adef9bc64bfced1050144e22889eebbe5b` passed manifest/adversarial checks, full Lean build, archive-wide `leanchecker`, the 22,072-declaration axiom/export audit, strict render, cluster-style render, and offline render before submission | Respond to upstream CI or maintainer review; do not treat the pull request as acceptance | On review activity |
| [VibeRegistry PR #16](https://github.com/GasStationManager/VibeRegistry/pull/16) | Independent statement/comparator | Pull request submitted; awaiting maintainer workflow | Independent specification pins production commit `fed494f8e9b9ad6b0c1f1b6afd2fda08072339df`; local import scan and isolated short-path spec build passed, while the upstream PR currently reports no checks | Respond to independent comparator or maintainer review; do not treat submission as acceptance | On review activity |
| [Lean Pool](https://github.com/LeanPool/lean-pool/issues/848) | Full project proposal | Accepted for a later import run; not assigned a current import slot | Lean Pool confirmed that the MIT alternative satisfies licensing and accepted the project for a future run. Its two current import slots are assigned elsewhere. The normalization and finite-mode scope must remain explicit during the later source/dependency audit, Lean port, optimization, and Pool validation | No further licensing reply is required. Wait for Lean Pool scheduling and preserve the stated normalization and finite-mode boundary in any future import work | On maintainer scheduling |
| [Best-of-Lean4](https://github.com/34j/best-of-lean4/pull/302) | Project listing | Pull request submitted | PR #302 adds one narrowly scoped listing with the Zenodo record and explicit claim boundary; local YAML validation passed | Respond to listing review and CI | On review activity |
| [Formalization Corpus](https://github.com/dzackgarza/formalization-corpus/issues/13) | Repository indexing | Indexing request submitted | Issue #13 requests corpus indexing for the versioned source and immutable Zenodo archive | Respond to curator questions and record any indexed identifier | On review activity |
| Project Intentions | Community coordination | Manual-only; not submitted | No Klein–Gordon issue found | G. D. Partin must personally write any community post | Manual |
| [Constraint Systems Institute](https://constraintsystemsinstitute.org/index.html) | Project listing | Submitted; awaiting response | A bounded listing request was emailed to `amos@constraintsystemsinstitute.org` on 2026-11-16 with the release, Zenodo record and DOI, CI evidence, claim boundary, and AI-assistance disclosure | Await a response and answer any scope or reproducibility questions | 2026-11-23 |
| Lean Zulip | Community publicity | Excluded | Existing instruction excludes Zulip after the prior moderation event | Do not post | Closed |

## Update rule

For every status change, update the status, last event, next action, and
follow-up date in this file. Preserve failed, blocked, or incomplete
submissions as such; do not convert a draft, intake, listing, announcement,
or passing workflow into acceptance or endorsement.
