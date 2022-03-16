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
						speed = { 0.25, 0.75 },
						position = { 0, 1.5, 0 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.25, 0.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.8 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 0.5 },
					duration = { 1.5 }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionEnchant_1/Animation.lanim"
	}
}
