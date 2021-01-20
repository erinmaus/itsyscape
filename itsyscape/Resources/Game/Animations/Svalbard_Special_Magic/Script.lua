Animation "Svalbard Special (Magic)" {
	Channel {
		Particles {
			duration = 3,
			attach = "tongue",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Svalbard_Special_Magic/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -0.25, 0 },
						zRange = { 1, 0.125 },
						acceleration = { 0, 0 }
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
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
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
					count = { 20, 40 },
					delay = { 0.125 },
					duration = { 2 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Svalbard_Special_Magic/Animation.lanim" {
			bones = {
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
