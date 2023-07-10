Animation "Rat King Attack" {
	Channel {
		Particles {
			duration = 2,
			attach = "neck.m",
			scale = { 0.25, 0.25, 0.25 },

			system = {
				numParticles = 100,
				texture = "Resources/Game/Animations/RatKing_Attack_Archery/Particle.png",
				columns = 1,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 5, 7 },
						xRange = { 0, 0.125 },
						yRange = { -0.25, 0 },
						zRange = { 1, 0.125 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1.0, 1.0, 1.0, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.25, 0.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.4 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 20 },
					delay = { 0.125 },
					duration = { 1 }
				}
			}

		}
	},

	Target {
		PlaySound "Resources/Game/Animations/RatKing_Attack_Archery/Sound1.wav",
		PlaySound "Resources/Game/Animations/RatKing_Attack_Archery/Sound2.wav",
		PlayAnimation "Resources/Game/Animations/RatKing_Attack_Archery/Animation.lanim" {
			bones = {
				"neck1.r",
				"neck2.r",
				"neck1.l",
				"neck2.l",
				"neck.m",
				"body",
				"jaw.r",
				"jaw.m",
				"jaw.l",
				"hand.l",
				"hand.r",
				"arm.r",
				"arm.l"
			}
		}
	}
}
