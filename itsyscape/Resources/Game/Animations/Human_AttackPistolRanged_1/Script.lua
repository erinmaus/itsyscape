Animation "Human Attack (Weapon: Pistol, Style: Ranged) 1" {
	Channel {
		Wait(5 / 24),

		Particles {
			duration = 1.5,
			attach = "hand.r",

			system = {
				numParticles = 30,
				texture = "Resources/Game/Animations/Human_AttackPistolRanged_1/Smoke.png",
				columns = 1,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.125 },
						yRange = { 0, 0 },
						position = { 0.5, 1, 0 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 0.5, 1.5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.4, 0.4, 0.4, 0.0 },
							{ 0.4, 0.4, 0.4, 0.0 },
							{ 0.4, 0.4, 0.4, 0.0 },
							{ 0.4, 0.4, 0.4, 0.0 },
							{ 0.4, 0.4, 0.4, 0.0 },
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.5,  }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.1, 0.15 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 30, 60 },
						acceleration = { -40, -20 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.8 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 0.125 },
					duration = { 0.5 }
				}
			}
		}
	},

	Channel {
		Wait(5 / 24),

		Particles {
			duration = 1.5,
			attach = "hand.r",

			system = {
				numParticles = 50,
				texture = "Resources/Game/Animations/Human_AttackPistolRanged_1/Fire.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.125 },
						speed = { 3, 4 },
						yRange = { 0, 0.5 },
						xRange = { 1, 0.25 },
						zRange = { 0, 0 },
						position = { 0.5, 1, 0 }
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
						lifetime = { 0.3, 0.4 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.1, 0.2 }
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
						fadeOutPercent = { 0.8 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 25 },
					delay = { 0.1 },
					duration = { 0.5 }
				}
			}
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Human_AttackPistolRanged_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_AttackPistolRanged_1/Animation.lanim" {
			bones = {
				"root",
				"body",
				"shoulder.r",
				"arm.r",
				"hand.r",
				"shoulder.l",
				"arm.l",
				"hand.l",
				"head"
			}
		}
	}
}
