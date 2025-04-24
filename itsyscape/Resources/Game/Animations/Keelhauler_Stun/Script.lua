Animation "Keelhauler Stun" {
	Blend {
		from = "Keelhauler Run",
		duration = 0.25
	},

	fadesIn = true,
	fadesOut = true,

	Channel {
		Particles {
			duration = 2.5,
			attach = "head",
			scale = { 0.5, 0.5, 0.5 },

			system = {
				numParticles = 100,
				texture = "Resources/Game/Animations/Keelhauler_Stun/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 4, 5 },
						position = { 0, 2, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 0.75 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { -180, 180 }
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
						type = "GravityPath",
						gravity = { 0, -5, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 15 },
					delay = { 1 / 30 },
					duration = { 1.5 }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Keelhauler_Stun/Sit.lanim",
		PlayAnimation "Resources/Game/Animations/Keelhauler_Stun/Idle.lanim" {
			repeatAnimation = true
		}
	}
}
