Animation "Yendor Attack (Magic)" {
	Channel {
		Particles {
			duration = 3,
			attach = "jaw.t",
			scale = { 4, 4, 4 },
			reverseRotation = "X_90",
			direction = { 0, 0, 1 },

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Yendor_Attack_Magic/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 }
					},
					{
						type = "DirectionalEmitter",
						speed = { 10, 15 }
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
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 40 },
					delay = { 1 / 30 },
					duration = { 2 }
				}
			}

		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Yendor_Attack_Magic/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Yendor_Attack_Magic/Animation.lanim"
	}
}
