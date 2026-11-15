Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 3

Stage 2 derived the lattice update for a small disturbance on a particular c40 wave branch. Stage 3 asks what frequencies actually satisfy that update.

We give the disturbance a sinusoidal shape, with a wave vector k specifying how its phase changes across the three lattice axes. Then we put it through the centered update. Lean proves that the mode obeys the update at every site and phase exactly when its angular frequency ω satisfies

2[1 − cos(ωΔt)] = Δt² [361 + S(k)]

S(k) = 4 Σ_b w_b [1 − cos(k·b)]

Here Δt is the timestep. The sum uses one representative from each opposite pair of C19 neighbor offsets. The 361 comes from the local response derived in Stage 2, S(k) comes from the neighbor bonds, and the cosine on the left comes from stepping through discrete time.

At zero wave number, all sites in the mode move in step and the neighbor term vanishes. When Δt√[361 + S(k)] ≤ 2 for a positive timestep, Lean verifies both signs of the resolved frequency from the same equation.

This gives us the exact frequency relation on the original lattice for the selected small-wave branch. In Stage 4, we’ll track how the spatial and timestep corrections shrink and explain the readout that connects this result to the continuum equation.

Stage 3 and the build instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation
