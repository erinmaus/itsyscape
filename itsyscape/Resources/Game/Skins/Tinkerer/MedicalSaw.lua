{
	model = "Resources/Game/Skins/Tinkerer/MedicalSaw.lmesh",
	texture = "Resources/Game/Skins/Tinkerer/MedicalSaw.png",

	particles = {
		{
			attach = "hand.r",
			position = { -1, 2.5, 1.5 },

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/Tinkerer/Particle_Blood.png",
				columns = 4,
				soft = true,
				material = {
					properties = {
						isFullLit = false,
						glassThickness = 1,
						isShadowCaster = true
					}
				},

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.1 },
						speed = { 0, 0 },
						acceleration = { 0, 0 },
						lifetime = { 1.5, 0.15 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, -1, 0 },
						speed = { 3, 5 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.8, 0.2, 0.2, 0.0 },
							{ 1.0, 0.2, 0.2, 0.0 },
							{ 0.5, 0.1, 0.1, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.05 },
						fadeOutPercent = { 0.95 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 15 },
					delay = { 0.5, 1.5 }
				}
			}
		},
		{
			attach = "hand.r",
			position = { -1, 2.25, 1.5 },

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/Tinkerer/Particle_Blood.png",
				columns = 4,
				soft = true,
				material = {
					properties = {
						isFullLit = false,
						glassThickness = 1,
						isShadowCaster = true
					}
				},

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.1 },
						speed = { 0, 0 },
						acceleration = { 0, 0 },
						lifetime = { 1.5, 0.15 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, -1, 0 },
						speed = { 3, 5 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.8, 0.2, 0.2, 0.0 },
							{ 1.0, 0.2, 0.2, 0.0 },
							{ 0.5, 0.1, 0.1, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.05 },
						fadeOutPercent = { 0.95 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 15 },
					delay = { 0.5, 1.5 }
				}
			}
		},
		{
			attach = "hand.r",
			position = { -1, 2, 1.5 },

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/Tinkerer/Particle_Blood.png",
				columns = 4,
				soft = true,
				material = {
					properties = {
						isFullLit = false,
						glassThickness = 1,
						isShadowCaster = true
					}
				},

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.1 },
						speed = { 0, 0 },
						acceleration = { 0, 0 },
						lifetime = { 1.5, 0.15 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, -1, 0 },
						speed = { 3, 5 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.8, 0.2, 0.2, 0.0 },
							{ 1.0, 0.2, 0.2, 0.0 },
							{ 0.5, 0.1, 0.1, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.05 },
						fadeOutPercent = { 0.95 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 15 },
					delay = { 0.5, 1.5 }
				}
			}
		}
	}
}
