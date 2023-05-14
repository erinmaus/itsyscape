Animation "Trash Heap Attack" {
	Channel {
		Wait(0.25),

		Particles {
			duration = 2,
			attach = "body2",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Animations/Yendor_Attack_Magic/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.25 },
						speed = { 5, 7 },
						yRange = { -0.5, 0 },
						xRange = { 0, 0 },
						zRange = { 1, 0.5 },
						acceleration = { 0, 0 },
						position = { 0, -0.5, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.62, 0.19, 0.35, 0.0 },
							{ 0.50, 0.16, 0.50, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 2, 2.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 0.75 }
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
					count = { 10, 12 },
					delay = { 0.125 },
					duration = { 1 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TrashHeap_Attack/Animation.lanim"
	}
}
