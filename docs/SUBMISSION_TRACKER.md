# External submission tracker

Last reconciled: 2026-11-16 (America/Los_Angeles)

This ledger separates source publication, immutable preservation, formal
verification, curated listings, and community publicity. A listing is not an
endorsement of the physical interpretation. The public claim is limited to
the linearized selected polarization and the explicitly normalized continuum
spectral readout described in [CLAIM_BOUNDARY.md](CLAIM_BOUNDARY.md).

| Destination | Scope | Status | Last event | Next action | Follow-up date |
| --- | --- | --- | --- | --- | --- |
| Production verification | Full seven-stage package | Local PASS; Linux CI pending | All seven ordered stage audits and the cross-platform release verifier passed locally; the publication theorems report only `propext`, `Classical.choice`, and `Quot.sound` | Require clean Linux CI on the release pull request before merging or tagging | Before release |
| [GitHub repository](https://github.com/gpartin/LeanKleinGordonDerivation) | Full seven-stage package | Public source; no versioned release yet | Stages 1–7 are public on `main` | Merge audited release metadata and create `v0.7.0-research` | This release |
| Zenodo | Full archived release | Not submitted | No standalone record found | Publish the verified GitHub release as a standalone software record | After GitHub release |
| Software Heritage | Full Git history | Not submitted | No save request recorded | Submit the released public origin and retain the request/snapshot identifier | After GitHub release |
| Palomar Registry | Bounded spectral/operator theorem | Not submitted | Candidate scope not yet packaged | Prepare a dedicated comparator package; run official preflight; request author approval before intake or permanent registration | After release audit |
| Lax Lean Archive | Bounded spectral/operator theorem | Not submitted | No concept exists | Prepare and validate a replaceable draft; request author approval before permanent registration | After release audit |
| Lemmata | Bounded spectral/operator theorem | Not submitted | No contribution exists | Prepare a narrowly scoped contribution with release/DOI provenance and explicit normalization boundary | After Zenodo |
| VibeRegistry | Independent statement/comparator | Not submitted | No comparator exists | Prepare a comparator pinned to the released theorem and await independent workflow results | After release audit |
| Lean Pool | Full project proposal | Not submitted | No proposal exists | File a bounded project-fit proposal linked to the release and DOI | After Zenodo |
| Best-of-Lean4 | Project listing | Not submitted | No listing exists | Open one narrowly scoped listing PR | After Zenodo |
| Formalization Corpus | Repository indexing | Not submitted | No request exists | Request indexing of the versioned source and immutable archive | After Zenodo |
| Project Intentions | Community coordination | Manual-only; not submitted | No Klein–Gordon issue found | G. D. Partin must personally write any community post | Manual |
| Constraint Systems Institute | Project listing | Not submitted | No request exists | Send a bounded listing request with AI-assistance disclosure | After Zenodo |
| Lean Zulip | Community publicity | Excluded | Existing instruction excludes Zulip after the prior moderation event | Do not post | Closed |

## Update rule

For every status change, update the status, last event, next action, and
follow-up date in this file. Preserve failed, blocked, or incomplete
submissions as such; do not convert a draft, intake, listing, announcement,
or passing workflow into acceptance or endorsement.
