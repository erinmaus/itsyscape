Animation "Dragon Eat" {
	Channel {
		Wait(30 / 24),

		Particles {
			duration = 2,
			attach = "head",
			position = { 0, 5.5, 0 },

			system = {
				numParticles = 250,
				texture = "Resources/Game/Animations/Dragon_Eat/Particle.png",	
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						speed = { 10, 15 },
						lifetime = { 0.5, 1 }
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
						type = "RandomScaleEmitter",
						scale = { 1, 1.25 }
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
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
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

	Channel {
		PlaySound "Resources/Game/Animations/Dragon_Eat/Roar.wav",
		PlaySound "Resources/Game/Animations/Dragon_Eat/Eat.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Dragon_Eat/Animation.lanim" {
			bones = {
				"neck1",
				"neck2",
				"head.top",
				"head.bottom",
				"head"
			}
		}
	}
}
