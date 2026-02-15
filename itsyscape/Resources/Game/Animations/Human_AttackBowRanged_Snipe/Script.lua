Animation "Human Attack (Weapon: Bow/Longbow, Style: Ranged) Snipe" {
	Channel {
		Particles {
			duration = 1,
			attach = "foot.l",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_AttackBowRanged_Snipe/Particle.png",
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

	Channel {
		Particles {
			duration = 1,
			attach = "foot.r",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_AttackBowRanged_Snipe/Particle.png",
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

	Channel {
		Wait(50 / 24),

		Particles {
			duration = 1,
			attach = "foot.l",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_AttackBowRanged_Snipe/Particle.png",
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

	Channel {
		Wait(50 / 24),
		
		Particles {
			duration = 1,
			attach = "foot.r",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Human_AttackBowRanged_Snipe/Particle.png",
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
		PlaySound "Resources/Game/Animations/Human_AttackBowRanged_Snipe/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_AttackBowRanged_Snipe/Animation.lanim"
	}
}
