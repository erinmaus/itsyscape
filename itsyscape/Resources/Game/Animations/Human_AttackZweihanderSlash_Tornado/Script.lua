Animation "Human Attack (Weapon: Zweihander, Style: Slash) Tornado" {
	Channel {
		Particles {
			duration = 2,
			attach = "hand.r",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_AttackZweihanderSlash_Tornado/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						position = { 0, 1.5, 0 },
						yRange = { 0, 0 }
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 1, 1.25 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.0, 0.8, 1.0, 0.0 },
							{ 1.0, 0.8, 0.0, 0.0 },
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.25, 0.75 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.35 }
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
						fadeInPercent = { 0.2 },
						fadeOutPercent = { 0.8 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 1, 2 },
					delay = { 0 },
					duration = { 1 }
				}
			}
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Human_AttackZweihanderSlash_Tornado/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_AttackZweihanderSlash_Tornado/Animation.lanim"
	}
}
