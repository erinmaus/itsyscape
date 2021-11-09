Animation "Human Attack (Weapon: Flamethrower, Style: Ranged) 1" {
	Channel {
		Particles {
			duration = 2,
			attach = "hand.r",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Animations/Human_AttackFlamethrowerRanged_1/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						position = { 1, 0.75, -0.25 },
						xRange = { 1, 0.125 },
						yRange = { 0, 0 },
						zRange = { 0, 0 },
						acceleration = { 0, 0 }
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
						age = { 1, 1.5 }
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
						fadeInPercent = { 0.3 },
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
					count = { 10, 20 },
					delay = { 0.125 },
					duration = { 1 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_AttackFlamethrowerRanged_1/Animation.lanim" {
			bones = {
				"root",
				"body",
				"shoulder.r",
				"arm.r",
				"hand.r",
				"shoulder.l",
				"arm.l",
				"hand.l",
				"head"
			}
		}
	}
}
