Animation "Human Summon (Keelhauler)" {
	Channel {
		ApplySkin "Resources/Game/Skins/Keelhauler/Heart.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 45 / 24
		}
	},

	Channel {
		Particles {
			duration = 1.5,
			attach = "hand.r",
			scale = { 0.5, 0.5, 0.5 },

			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Human_Summon_Keelhauler/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						lifetime = { 0.5, 0.1 },
						position = { 0, 0.5, 0 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 5, 5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 0.4, 0.0, 0.0 },
							{ 0.9, 0.4, 0.0, 0.0 },
							{ 1, 0.5, 0.0, 0.0 },
							{ 0.9, 0.5, 0.0, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.1, 0.3 }
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
					count = { 10, 15 },
					delay = { 1 / 30 },
					duration = { 1 }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_Summon_Keelhauler/Animation.lanim"
	}
}
