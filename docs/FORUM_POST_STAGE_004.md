Deriving the Klein–Gordon equation from the Lattice Field Medium — Stage 4

Stage 3 gave us the exact frequency relation for the selected small-wave branch on the c40 lattice. Stage 4 asks what that relation becomes when a wavelength spans many lattice cells. The continuum readout in native coordinate units gives

Ω² = 361 + 12|k|²

The 361 is the squared rest-frequency gap from Stage 2. The 12 comes from adding up the weighted effects of the C19 bonds. Lean verifies that the leading spatial coefficient is the same in all three directions and gives explicit bounds on the lattice and timestep corrections.

We hold the continuum wave vector k fixed and shrink the spacing scale h. The unchanged lattice update sees wave vector h k, so the wave spans more cells as h shrinks. From the native squared-frequency readout D(h), we isolate the change above the rest gap, divide it by h², and then put the rest gap back.

Ω(h)² = 361 + [D(h) − 361]/h²

We checked what happens with and without that normalization. At k = (1, 0, 0), the native readout tends to 361, while the normalized readout tends to 373. This makes clear which quantity carries the spatial term into the continuum limit.

This is the dispersion relation that will feed Stage 5. There we’ll use it to prove the familiar Klein–Gordon differential equation for these modes and their finite superpositions.

Stage 4 and the build instructions are public at
https://github.com/gpartin/LeanKleinGordonDerivation
