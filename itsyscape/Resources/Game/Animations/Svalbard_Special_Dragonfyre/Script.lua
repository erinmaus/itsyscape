Animation "Svalbard Special (Dragonfyre)" {
	Channel {
		Particles {
			duration = 3,
			attach = "tongue",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Svalbard_Special_Dragonfyre/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -0.5, 0 },
						zRange = { 1, 0.125 },
						position = { 0, 0, 2 },
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
						fadeInPercent = { 0.1 },
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
					duration = { 1.5 }
				}
			}
		}
	},

	Channel {
		PlaySound "Resources/Game/Animations/Svalbard_Special_Dragonfyre/Roar.wav",
		Wait(0.5),
		PlaySound "Resources/Game/Animations/Svalbard_Special_Dragonfyre/Fire.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Svalbard_Special_Dragonfyre/Animation.lanim" {
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
