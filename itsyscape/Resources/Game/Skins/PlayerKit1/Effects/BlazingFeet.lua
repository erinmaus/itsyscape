{
	isBlocking = false,
	isGhosty = true,

	particles = {
		{
			attach = "foot.r",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/PlayerKit1/Effects/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.15 },
						position = { -0.25, 0, 0.25 }
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
						lifetime = { 0.4, 0.8 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.125 }
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
					count = { 5, 10 },
					delay = { 0.125 }
				}
			}
		},
		{
			attach = "foot.l",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Skins/PlayerKit1/Effects/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.15 },
						position = { 0.25, 0, 0.25 }
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
						lifetime = { 0.4, 0.8 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.125 }
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
					count = { 5, 10 },
					delay = { 0.125 }
				}
			}
		}
	}
}