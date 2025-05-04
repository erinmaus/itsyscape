Animation "Keelhauler Summon" {
	Channel {
		Particles {
			duration = 1.5,
			attach = "toes.front.l",
			scale = { 0.5, 0.5, 0.5 },
			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Summon/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1 },
						lifetime = { 1.25, 0.5 },
						position = { 0, 0.5, 1 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 8, 10 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.3, 0.1, 0.8, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
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
					count = { 20, 25 },
					delay = { 1 / 30 },
					duration = { 0.5 }
				}
			}
		}
	},

	Channel {
		Particles {
			duration = 1.5,
			attach = "toes.front.r",
			scale = { 0.5, 0.5, 0.5 },
			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Summon/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1 },
						lifetime = { 1.25, 0.5 },
						position = { 0, 0.5, 1 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 8, 10 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.3, 0.1, 0.8, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
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
					count = { 20, 25 },
					delay = { 1 / 30 },
					duration = { 0.5 }
				}
			}
		}
	},

	Channel {
		Particles {
			duration = 1.5,
			attach = "toes.back.l",
			scale = { 0.5, 0.5, 0.5 },
			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Summon/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1 },
						lifetime = { 1.25, 0.5 },
						position = { 0, 0.5, 1 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 8, 10 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.3, 0.1, 0.8, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
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
					count = { 20, 25 },
					delay = { 1 / 30 },
					duration = { 0.5 }
				}
			}
		}
	},

	Channel {
		Particles {
			duration = 1.5,
			attach = "toes.back.r",
			scale = { 0.5, 0.5, 0.5 },
			system = {
				numParticles = 500,
				texture = "Resources/Game/Animations/Keelhauler_Summon/Particle.png",
				columns = 4,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 1 },
						lifetime = { 1.25, 0.5 },
						position = { 0, 0.5, 1 },
					},
					{
						type = "DirectionalEmitter",
						direction = { 0, 1, 0 },
						speed = { 8, 10 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.4, 0.2, 0.8, 0.0 },
							{ 0.3, 0.1, 0.8, 0.0 }
						}
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.5, 1 }
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
					count = { 20, 25 },
					delay = { 1 / 30 },
					duration = { 0.5 }
				}
			}
		}
	},

	Channel {
		Tint {
			1, 1, 1, 0,
			duration = 1,
			tween = 'sineIn',
			reverse = true
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Keelhauler_Summon/Animation.lanim"
	}
}
