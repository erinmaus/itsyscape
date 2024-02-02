Animation "The Empty King (Fully Realized) Attack (Magic, Special)" {
	fadesOut = true,

	Blend {
		from = "The Empty King (Fully Realized) Idle (Magic)",
		duration = 0.25
	},

	Channel {
		Particles {
			duration = 1.5,
			attach = "root",

			reverseRotation = 'X_90',
			
			system = {
				texture = "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic_Special/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.0, 0.125 },
						speed = { 4, 7 },
						yRange = { 0, 0 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.4, 0.4, 0.4, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.5, 0.75 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 1, 1.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 30, 60 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.8 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 20 },
					delay = { 1 / 30 },
					duration = { 0.75 }
				}
			}
		}
	},

	Channel {
		PlaySound "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic_Special/Sound.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic_Special/Animation.lanim"
	}
}
