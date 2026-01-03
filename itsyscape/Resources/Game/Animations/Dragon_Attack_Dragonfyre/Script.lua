Animation "Dragon Attack (Dragonfyre)" {
	Channel {
		PlaySound "Resources/Game/Animations/Dragon_Attack_Dragonfyre/Roar.wav",
		Wait(0.5),
		PlaySound "Resources/Game/Animations/Dragon_Attack_Dragonfyre/Fire.wav"
	},

	Channel {
		Particles {
			duration = 4,
			attach = "head.bottom",
			direction = { 0, 0, -1 },

			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Dragon_Attack_Dragonfyre/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1.5 },
						lifetime = { 1.5, 1 },
						position = { 0, 0, 2 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 0, -1 },
						speed = { 20, 20 },
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
						type = "RandomScaleEmitter",
						scale = { 1, 1.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.2 },
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
					count = { 15, 25 },
					delay = { 1 / 30 },
					duration = { 2.5 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Dragon_Attack_Dragonfyre/Animation.lanim"
	}
}
