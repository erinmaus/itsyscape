{
	particles = {
		{
			attach = "spine2",
			position = { 0, -3, 5 },

			system = {
				numParticles = 200,
				texture = "Resources/Game/Skins/GoredDragon/Particle_Flame.png",
				columns = 4,
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.25 },
						yRange = { -0.5, 0.5 },
						lifetime = { 1.5, 0.15 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 1, 1.25 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1.0, 0.84, 0.16, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 1 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 2, 5 },
					delay = { 1 / 30 }
				}
			}
		},
		{
			attach = "spine2",
			position = { 0, -3, 5 },

			system = {
				numParticles = 200,
				texture = "Resources/Game/Skins/GoredDragon/Particle_Flame.png",
				columns = 4,
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						yRange = { -0.5, 0.5 },
						lifetime = { 1.5, 0.15 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 1, 1.25 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 1 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 2, 5 },
					delay = { 1 / 30 }
				}
			}
		}
	}
}