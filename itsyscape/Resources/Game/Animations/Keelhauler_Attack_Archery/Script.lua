Animation "Keelhauler Attack (Archery)" {
	Channel {
		Wait(1),

		PlaySound "Resources/Game/Animations/Keelhauler_Attack_Archery/Sound.wav",
	},

	Channel {
		Wait(1),

		Particles {
			duration = 1.5,
			attach = "toes.front.l",
			scale = { 0.5, 0.5, 0.5 },
			direction = { -1, -1, 0 },

			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Attack_Archery/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1 },
						lifetime = { 1.25, 0.5 },
						position = { 0, 0.5, 1 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 0, -1 },
						speed = { 12, 14 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.5, 0.5, 0.4, 0.0 },
							{ 0.5, 0.5, 0.4, 0.0 },
							{ 0.3, 0.3, 0.2, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 30, 60 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 25 },
					delay = { 1 / 30 },
					duration = { 0.5 }
				}
			}
		}
	},

	Channel {
		Wait(1),

		Particles {
			duration = 1.5,
			attach = "toes.front.r",
			scale = { 0.5, 0.5, 0.5 },
			direction = { 1, -1, 0 },

			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Attack_Archery/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1.5 },
						lifetime = { 1.25, 0.5 },
						position = { 0, 0.5, 1 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 0, -1 },
						speed = { 12, 14 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.5, 0.5, 0.4, 0.0 },
							{ 0.5, 0.5, 0.4, 0.0 },
							{ 0.3, 0.3, 0.2, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 30, 60 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 25 },
					delay = { 1 / 30 },
					duration = { 0.5 }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Keelhauler_Attack_Archery/Animation.lanim"
	}
}
