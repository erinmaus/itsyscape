Animation "Svalbard Special (Archery)" {
	Channel {
		Particles {
			duration = 5,
			attach = "foot.fr",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Animations/Svalbard_Special_Archery/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 1 },
						speed = { 5, 6 },
						yRange = { 0, 0 },
						acceleration = { -1, -2 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.8, 0.8, 0.9, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.30 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 0, 720 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "BurstEmissionStrategy",
					count = { 50 },
					delay = { 0.25 }
				}
			}

		}
	},

	Channel {
		Particles {
			duration = 5,
			attach = "foot.fl",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Animations/Svalbard_Special_Archery/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 1 },
						speed = { 5, 6 },
						yRange = { 0, 0 },
						acceleration = { -1, -2 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.8, 0.8, 0.9, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.30 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 0, 720 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "BurstEmissionStrategy",
					count = { 50 },
					delay = { 0.25 }
				}
			}

		}
	},

	Target {
		Wait(3)
	}
}
