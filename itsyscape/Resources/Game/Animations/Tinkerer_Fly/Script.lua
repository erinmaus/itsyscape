Animation "Tinkerer Fly" {
	fadesIn = true,
	fadesOut = true,

	Channel {
		PlaySound "Resources/Game/Animations/Tinkerer_Fly/Sound.wav" {
			repeatSound = true,
			minDuration = 20 / 24,
			maxDuration = 20 / 24,
		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing.r.2",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Tinkerer_Fly/Particle_Feather.png",
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						xRange = { 0, 0 },
						yRange = { -0.5, 0.5 },
						speed = { 1, 2 },
						speed = { 0, 0 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 1.0 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 1 / 10 },
					duration = { INFINITY }
				}
			}
		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing.l.2",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Tinkerer_Fly/Particle_Feather.png",
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						xRange = { 0, 0 },
						yRange = { -0.5, 0.5 },
						speed = { 1, 2 },
						speed = { 0, 0 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 1.0 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 1 / 10 },
					duration = { INFINITY }
				}
			}
		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing.r.3",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Tinkerer_Fly/Particle_Feather.png",
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						xRange = { 0, 0 },
						yRange = { -0.5, 0.5 },
						speed = { 1, 2 },
						speed = { 0, 0 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 1.0 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 1 / 10 },
					duration = { INFINITY }
				}
			}
		}
	},

	Channel {
		Particles {
			duration = INFINITY,
			attach = "wing.l.3",

			system = {
				numParticles = 200,
				texture = "Resources/Game/Animations/Tinkerer_Fly/Particle_Feather.png",
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 0, 0.5 },
						xRange = { 0, 0 },
						yRange = { -0.5, 0.5 },
						speed = { 1, 2 },
						speed = { 0, 0 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 1, 1, 1, 0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						age = { 0.5, 1.0 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 0.25, 0.5 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 },
						velocity = { 180, 360 }
					}
				},

				paths = {
					{
						type = "FadeInOutPath",
						fadeInPercent = { 0.3 },
						fadeOutPercent = { 0.7 },
						tween = { 'sineEaseOut' }
					},
					{
						type = "GravityPath",
						gravity = { 0, -10, 0 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 5, 10 },
					delay = { 1 / 10 },
					duration = { INFINITY }
				}
			}
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Tinkerer_Fly/Begin.lanim" {
			bones = {
				"wing.l.1",
				"wing.l.2",
				"wing.l.3",
				"wing.l.4",
				"wing.r.1",
				"wing.r.2",
				"wing.r.3",
				"wing.r.4",
				"root",
			}
		},

		PlayAnimation "Resources/Game/Animations/Tinkerer_Fly/Idle.lanim" {
			repeatAnimation = true,
			bones = {
				"wing.l.1",
				"wing.l.2",
				"wing.l.3",
				"wing.l.4",
				"wing.r.1",
				"wing.r.2",
				"wing.r.3",
				"wing.r.4",
				"root",
			}
		},

		PlayAnimation "Resources/Game/Animations/Tinkerer_Fly/End.lanim" {
			bones = {
				"wing.l.1",
				"wing.l.2",
				"wing.l.3",
				"wing.l.4",
				"wing.r.1",
				"wing.r.2",
				"wing.r.3",
				"wing.r.4",
				"root",
			}
		}
	}
}
