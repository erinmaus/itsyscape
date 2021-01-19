Animation "Svalbard Attack (Archery)" {
	Channel {
		Particles {
			duration = 3,
			attach = "tongue",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Svalbard_Attack_Archery/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -2, 0 },
						zRange = { 1, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }

						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
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
					count = { 5, 10 },
					delay = { 0.125 },
					duration = { 3 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Svalbard_Attack_Archery/Animation.lanim" {
			bones = {
				"wing1.r",
				"wing2.r",
				"wing3.r",
				"wing1.l",
				"wing2.l",
				"wing3.l",
				"neck1",
				"neck2",
				"neck3",
				"neck4",
				"head",
				"jaw",
				"tongue"
			}
		}
	}
}
