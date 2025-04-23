Animation "Keelhauler Attack (Magic)" {
	Channel {
		PlaySound "Resources/Game/Animations/Keelhauler_Attack_Archery/Sound.wav",
	},

	Channel {
		Particles {
			duration = 1.5,
			attach = "head",
			scale = { 0.5, 0.5, 0.5 },
			direction = { 0, 0, -1 },

			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Attack_Magic/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1.5 },
						lifetime = { 0.5, 0.1 },
						position = { 0, -2, 6 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 0, -1 },
						speed = { 10, 10 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
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
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 15, 25 },
					delay = { 1 / 30 },
					duration = { 1 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Keelhauler_Attack_Magic/Animation.lanim"
	}
}
