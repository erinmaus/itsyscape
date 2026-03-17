Animation "Tinkerer Attack" {
	Channel {
		Wait(0.4),

		Particles {
			duration = 1.5,
			attach = "hand.r",
			direction = { 0, -1, 0 },
			position = { 0, 2, 0 },

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Tinkerer_Attack_Saw/Particle.png",
				columns = 4,
				soft = true,
				material = {
					properties = {
						isFullLit = false,
						glassThickness = 1,
						isShadowCaster = true
					}
				},

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.2 },
						zRange = { 0, 0 },
						lifetime = { 1, 0.15 },
					},
					{
						type = "DirectionalEmitter",
						speed = { 3, 4 },
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
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -7, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 15 },
					delay = { 1 / 60 },
					duration = { 0.5 }
				}
			}
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Tinkerer_Attack_Saw/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Tinkerer_Attack_Saw/Animation.lanim"
	}
}
