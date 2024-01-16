Animation "Tinkerer Special Attack" {
	Channel {
		Wait(1),

		Particles {
			duration = 3,
			attach = "wing.l.3",
			rotation = "Y_180",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Tinkerer_Special_Attack/Particle_Feather.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 2, 4 },
						xRange = { 0, 0 },
						yRange = { -0.5, 0.25 },
						zRange = { 0.25, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 1.0 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 2, 4 },
					delay = { 1 / 32 },
					duration = { 2 }
				}
			}
		}
	},

	Channel {
		Wait(1),

		Particles {
			duration = 3,
			attach = "wing.r.3",
			rotation = "Y_180",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Tinkerer_Special_Attack/Particle_Feather.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 2, 4 },
						xRange = { 0, 0 },
						yRange = { -0.5, 0.25 },
						zRange = { 0.25, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 1.0 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 2, 4 },
					delay = { 1 / 32 },
					duration = { 1 }
				}
			}
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Tinkerer_Special_Attack/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Tinkerer_Special_Attack/Animation.lanim"
	}
}
