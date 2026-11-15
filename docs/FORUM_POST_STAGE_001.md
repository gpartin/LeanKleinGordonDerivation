Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 1

We’re releasing a seven-stage Lean derivation of the free Klein–Gordon equation. The target is

(∂ₜ² − c²∇² + m²)φ = 0

Here φ is the amplitude of a small wave, c is the propagation speed, and m is the rest-frequency parameter in the units used for the derivation. We want to see whether this equation describes the leading long-wavelength behavior of a particular wave branch of the Lattice Field Medium (LFM), and where its coefficients come from.

We start with the canonical c40 framework. Space is modeled as a cubic lattice. Each site i carries two fields, Ψᵢ and χᵢ, each with three complex components. A site interacts with six face neighbors (weight 2) and twelve edge neighbors (weight 1). Together with the center, these make up the C19 neighborhood.

The framework constants are χ₀ = 19, κ = 1/63, and B = χ₀/κ = 1197. B is the inertia coefficient for χ. Define ρΨ(i) = ‖Ψᵢ‖², ρχ(i) = ‖χᵢ‖², and Wᵢ = χᵢ ∧ Ψᵢ. W is the exterior product of the two fields, computed at each site.

The action is L = T − U, with

T = Σᵢ [½‖Ψ̇ᵢ‖² + (B/2)‖χ̇ᵢ‖²]

U = U_local + U_bond
U_local = Σᵢ [¼(ρχ(i) − χ₀²)² + ½ρχ(i)ρΨ(i) + ¼ρΨ(i)²]
U_bond = Σᵢ Σₙ [wₙ/(2χ₀²)] ‖Wᵢ₊ₙ − Wᵢ‖²

The inner sum runs over the 18 directed neighbor offsets. Varying the same potential over the real and imaginary components gives the two governing equations.

Ψ̈ᵢ = −∇_{Ψᵢ} U
Bχ̈ᵢ = −∇_{χᵢ} U

The lattice advances both fields together. For either field q, the update is

qᵢⁿ⁺¹ = 2qᵢⁿ − qᵢⁿ⁻¹ + Δt² aᵢ(qⁿ)

Stage 1 checks this starting point in Lean. It verifies the neighbor list and the action’s site variations, including the incoming and outgoing bonds. It then proves that the uniform configuration Ψᵢ = 0 and χᵢ = (19, 0, 0) stays fixed under both governing equations. What happens when we put a small disturbance into that verified background?

In Stage 2 we’ll calculate that response. Later stages will track the lattice and timestep corrections and explain the long-wavelength readout used to reach the target equation.

The Stage 1 code and build instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation
