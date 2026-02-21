Animation "Human Swap Gear (To: Archery)" {
	Channel {
		Particles {
			duration = 1,
			attach = "root",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_SwapGear_ToArchery_1/Particle.png",
				columns = 2,
				rows = 2,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						position = { 0, 1, 0 },
						speed = { 5, 6 },
					},

					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.14, 0.42, 0.34, 0.0 },
							{ 0.2, 0.62, 0.5, 0.0 },
							{ 0.31, 0.53, 0.47, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 0.75 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { -180, 180 }
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
						type = "GravityPath",
						gravity = { 0, -5, 0 }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 40 },
					delay = { 1 / 30 },
					duration = { 0.25 }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_SwapGear_ToArchery_1/Animation.lanim"
	}
}
