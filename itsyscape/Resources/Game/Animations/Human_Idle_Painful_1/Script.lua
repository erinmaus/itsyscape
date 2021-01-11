Animation "Human Idle (Painful) 1" {
	Channel {
		Wait(4),

		Particles {
			duration = INFINITY,

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Svalbard_Special_Magic/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 5, 7 },
						xRange = { 1, 0.5 },
						yRange = { 1, 0.25 },
						zRange = { 0, 0 },
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
						age = { 0.25, 0.5 }
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
					count = { 10, 15 },
					delay = { 1, 1.5 },
					duration = { INFINITY }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_Idle_Painful_1/Animation.lanim" {
			repeatAnimation = true
		}
	}
}
