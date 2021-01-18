Animation "Svalbard Summon Snow Storm" {
	fadesOut = true,

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing2.r",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Svalbard_Summon/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -0.5, 0 },
						zRange = { 1, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.0, 0.8, 1.0, 0.0 },
							{ 0.2, 0.7, 0.8, 0.0 },

						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.125, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 0.25 },
					duration = { INFINITY }
				}
			}

		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing3.r",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Svalbard_Summon/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -0.5, 0 },
						zRange = { 1, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.0, 0.8, 1.0, 0.0 },
							{ 0.2, 0.7, 0.8, 0.0 },

						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.125, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 0.25 },
					duration = { INFINITY }
				}
			}

		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing2.l",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Svalbard_Summon/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -0.5, 0 },
						zRange = { 1, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.0, 0.8, 1.0, 0.0 },
							{ 0.2, 0.7, 0.8, 0.0 },

						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.125, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 0.25 },
					duration = { INFINITY }
				}
			}

		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing3.l",

			system = {
				numParticles = 20,
				texture = "Resources/Game/Animations/Svalbard_Summon/Particle.png",

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0 },
						speed = { 10, 15 },
						xRange = { 0, 0.125 },
						yRange = { -0.5, 0 },
						zRange = { 1, 0.125 },
						acceleration = { 0, 0 }
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.0, 0.8, 1.0, 0.0 },
							{ 0.2, 0.7, 0.8, 0.0 },

						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 1, 1.5 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.125, 0.25 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 0.25 },
					duration = { INFINITY }
				}
			}

		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Svalbard_Summon/Animation.lanim" {
			repeatAnimation = true,
			bones = {
				"wing1.r",
				"wing2.r",
				"wing3.r",
				"wing1.l",
				"wing2.l",
				"wing3.l"
			}
		}
	}
}
