Animation "Spider Attack" {
	Channel {
		Particles {
			duration = 2,
			attach = "abdomen",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Spider_Attack_Magic/Particle.png",
				columns = 1,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 5, 8 },
						position = { 0, 0, 1 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 },
							{ 1, 1, 1, 0 },
							{ 1, 1, 1, 0 },
							{ 0.9, 0.9, 0.9, 0 },
							{ 0.9, 0.9, 0.9, 0 },
							{ 0.8, 0.8, 0.8, 0 },
							{ 0.8, 0.8, 0.8, 0 },
							{ 0.2, 0.2, 0.2, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.2, 0.3 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.35 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 270 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.8 },
						tween = { 'linear' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 15 },
					delay = { 0.125 },
					duration = { 1 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Spider_Attack_Magic/Animation.lanim"
	}
}
