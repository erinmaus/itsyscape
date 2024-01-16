Animation "Fleshy Pillar Defend" {
	Channel {
		Particles {
			attach = "top",
			duration = 1.75,

			system = {
				texture = "Resources/Game/Animations/FleshyPillar_Defend/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 3, 4 },
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
					count = { 30, 50 },
					delay = { 0.125 },
					duration = { 0.25 }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/FleshyPillar_Defend/Animation.lanim"
	}
}
