Animation "Human Action (Eat; Right) 1" {
	Channel {
		Wait(14 / 24),

		ApplySkin "Resources/Game/Skins/Tools/Spoon_Right.lua" {
			slot = SLOTS.PLAYER_SLOT_LEFT_HAND,
			duration = 1
		}
	},

	Channel {
		ApplySkin "Resources/Game/Skins/Tools/Cereal_Right.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 39 / 24
		}
	},

	Channel {
		Wait(36 / 24),

		Particles {
			duration = 1,
			attach = "hand.l",

			system = {
				texture = "Resources/Game/Animations/Human_ActionEat_Right_1/Dust.png",
				numParticles = 100,
				columns = 2,
				rows = 2,
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.1 },
						speed = { 0, 0.1 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 } 
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.5, 1 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.2, 0.4 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 360, 720 },
					},
					{
						type = "RandomTextureIndexEmitter",
						textures = { 1, 4 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -2, 0 }
					},
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 20 },
					delay = { 0 },
					duration= { 1 / 30 }
				}
			}
		}		
	},

	Channel {
		Wait(36 / 24),

		Particles {
			duration = 1,
			attach = "hand.r",

			system = {
				texture = "Resources/Game/Animations/Human_ActionEat_Right_1/Dust.png",
				numParticles = 100,
				columns = 2,
				rows = 2,
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.1 },
						speed = { 0, 0.1 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 } 
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.5, 1 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.2, 0.4 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 360, 720 },
					},
					{
						type = "RandomTextureIndexEmitter",
						textures = { 1, 4 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.1 },
						fadeOutPercent = { 0.9 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -2, 0 }
					},
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 10, 20 },
					delay = { 0 },
					duration= { 1 / 30 }
				}
			}
		}		
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionEat_Right_1/Animation.lanim" {
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
