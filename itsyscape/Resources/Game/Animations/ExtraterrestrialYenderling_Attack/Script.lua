Animation "Extraterrestrial Yenderling Attack" {
	Channel {
		Particles {
			duration = 3,
			attach = "squishy",
			direction = { 0, 0, -1 },

			system = {
				numParticles = 150,
				texture = "Resources/Game/Animations/ExtraterrestrialYenderling_Attack/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.25 },
						lifetime = { 1, 0.15 },
						position = { 0, 0, 0 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 0, 1 },
						speed = { 4, 6 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.2, 0.62, 0.5, 0.0 },
							{ 0.2, 0.62, 0.5, 0.0 },
							{ 0.2, 0.62, 0.5, 0.0 },
							{ 0.2, 0.62, 0.5, 0.0 },
							{ 0.14, 0.42, 0.34, 0.0 },
							{ 0.14, 0.42, 0.34, 0.0 },
							{ 0.31, 0.53, 0.47, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.75, 1.25 }
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
					count = { 15, 25 },
					delay = { 1 / 30 },
					duration = { 1.5 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/ExtraterrestrialYenderling_Attack/Animation.lanim"
	}
}
