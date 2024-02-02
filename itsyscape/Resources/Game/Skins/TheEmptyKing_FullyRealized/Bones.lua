{
	model = "Resources/Game/Skins/TheEmptyKing_FullyRealized/Bones.lmesh",
	texture = "Resources/Game/Skins/TheEmptyKing_FullyRealized/Bones.png",
	particles = {
		{
			attach = "eye.l",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/TheEmptyKing/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.03125 },
						position = { 0.5, -0.5, 1.25 },
						yRange = { 0, 0 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 0.5, 1.5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.75, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.15 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.4 },
						fadeOutPercent = { 0.6 },
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
					delay = { 0.125 }
				}
			}
		},
		{
			attach = "eye.r",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/TheEmptyKing/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.03125 },
						position = { -0.5, -0.5, 1.25 },
						yRange = { 0, 0 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 0.5, 1.5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.75, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.15 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.4 },
						fadeOutPercent = { 0.6 },
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
					delay = { 0.125 }
				}
			}
		},
		{
			attach = "eye.l",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/TheEmptyKing/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.0625, 0.125 },
						position = { 0.5, -0.5, 1.25 },
						yRange = { 0, 0 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 0.5, 1.5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.25, 0.85 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.15 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.4 },
						fadeOutPercent = { 0.6 },
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
					delay = { 0.125 }
				}
			}
		},
		{
			attach = "eye.r",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/TheEmptyKing/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.0625, 0.125 },
						position = { -0.5, -0.5, 1.25 },
						yRange = { 0, 0 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 0.5, 1.5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.25, 0.85 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.15 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.4 },
						fadeOutPercent = { 0.6 },
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
					delay = { 0.125 }
				}
			}
		}
	}
}
