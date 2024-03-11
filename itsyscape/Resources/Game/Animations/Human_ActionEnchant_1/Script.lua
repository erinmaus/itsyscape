Animation "Human Action (Enchant) 1" {
	Channel {
		Particles {
			duration = 1.5,
			attach = "hand.r",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Human_ActionEnchant_1/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0.0 },
						speed = { 2, 2.5 },
						position = { 0, 1.5, 0 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 0.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 1 / 30 },
					duration = { 1.0 }
				}
			}
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Human_ActionEnchant_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_ActionEnchant_1/Animation.lanim"
	}
}
