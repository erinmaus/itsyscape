Animation "Human Swap Gear (To: Melee)" {
	Channel {
		Particles {
			duration = 1,
			attach = "root",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_SwapGear_ToMelee_1/Particle.png",
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
							{ 0.63, 0.17, 0.29, 0.0 },
							{ 0.48, 0.14, 0.24, 0.0 },
							{ 0.48, 0.14, 0.24, 0.0 }
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
					count = { 10, 20 },
					delay = { 1 / 30 },
					duration = { 0.25 }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_SwapGear_ToMelee_1/Animation.lanim"
	}
}
