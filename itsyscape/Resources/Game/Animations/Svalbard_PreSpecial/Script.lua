Animation "Svalbard Pre-Special" {
	Target {
		Particles {
			duration = 10,
			system = {
				numParticles = 100,
				texture = "Resources/Game/Animations/Svalbard_PreSpecial/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 15 },
						speed = { -5, -5 },
						acceleration = { -5, -10 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.7, 0.2, 0.8, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 0.5 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.8 },
						tween = { 'sineEaseIn' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 30 },	
					delay = { 0.5, 1 },
					duration = { 5 }
				}
			}
		}
	}
}
