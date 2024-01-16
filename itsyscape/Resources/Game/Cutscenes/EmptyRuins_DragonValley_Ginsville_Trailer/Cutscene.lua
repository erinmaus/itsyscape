return Sequence {
	Map:wait(2),

	-- Camera sweep
	Sequence {
		Camera:target(CameraDolly),
		Camera:zoom(20),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 4),

		GoryMass:teleport("Trailer_Sweep_GoryMass_1"),
		SurgeonZombi:teleport("Trailer_Sweep_SurgeonZombi_1"),
		Tinkerer:teleport("Trailer_Sweep_Tinkerer_1"),
		ExperimentX:teleport("Trailer_Sweep_ExperimentX_1"),
		CameraDolly:teleport("Trailer_Sweep_Dolly_1"),
		Player:teleport("Anchor_Spawn"),

		Parallel {
			GoryMass:poke("startRoll", Map:getPosition("Trailer_Sweep_GoryMass_2")),
			SurgeonZombi:walkTo("Trailer_Sweep_SurgeonZombi_2"),
			Tinkerer:walkTo("Trailer_Sweep_Tinkerer_2"),
			ExperimentX:walkTo("Trailer_Sweep_ExperimentX_2"),
			CameraDolly:lerpPosition("Trailer_Sweep_Dolly_2", 10, "sineEaseOut")
		}
	},

	Map:wait(2),

	GoryMass:teleport("Adventurer1"),
	SurgeonZombi:teleport("Adventurer1"),

	-- Zoom in on Experiment X
	Sequence {
		Camera:target(ExperimentX),
		Camera:zoom(35),
		Camera:translate(Vector(5, 2.5, 5)),
		Camera:verticalRotate(-math.pi / 2 + math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 - math.pi / 24),
		Map:poke("darken", 40, 50),

		ExperimentX:teleport("Trailer_ZoomInView"),

		Parallel {
			ExperimentX:lerpPosition("Trailer_ZoomInView", 5),

			Sequence {
				ExperimentX:lookAt(Player, 0.5),
				ExperimentX:playAnimation("ExperimentX_Attack_Wizard"),
				ExperimentX:fireProjectile(Map:getPosition("Trailer_ZoomInView") + Vector(0, 0, 10), "FireBlast_ExperimentX"),
				ExperimentX:wait(1),
				ExperimentX:slerpRotation(Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi / 2), 0.5, "sineEaseOut"),
				ExperimentX:playAnimation("ExperimentX_Attack_Warrior"),
				ExperimentX:wait(1),
				ExperimentX:slerpRotation(Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi * 1.5 + math.pi / 32), 1, "sineEaseOut"),
				ExperimentX:playAnimation("ExperimentX_Attack_Archer"),
				ExperimentX:fireProjectile(Player, "ItsyArrow_ExperimentX"),
				ExperimentX:wait(1),
				ExperimentX:slerpRotation(Quaternion.IDENTITY, 0.5, "sineEaseOut")
			}
		},

		Map:poke("lighten", 10, 25),
		ExperimentX:teleport("Trailer_Sweep_ExperimentX_1")
	},

	Map:wait(2),

	-- Zoom in on Tinkerer
	Sequence {
		Camera:target(Tinkerer),
		Camera:zoom(15),
		Camera:translate(Vector(-2.5, 2.5, 4)),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 + math.pi / 24),
		Map:poke("darken", 25, 35),

		Tinkerer:teleport("Trailer_ZoomInView"),

		Parallel {
			Tinkerer:lerpPosition("Trailer_ZoomInView", 4),
			ExperimentX:walkTo("Trailer_Sweep_Tinkerer_1"),
			ExperimentX:lerpScale(Vector(0.75), 0),

			Sequence {
				Tinkerer:playAnimation("Tinkerer_Special_Attack"),
				Tinkerer:wait(2.5)
			}
		},

		Map:poke("lighten", 10, 25),
		ExperimentX:lerpScale(Vector(1), 0),
		ExperimentX:teleport("Trailer_Sweep_Tinkerer_2")
	},

	-- Player fights Experiment X
	Sequence {
		ExperimentX:teleport("Trailer_ExperimentX_Fight_1"),
		Player:teleport("Trailer_ExperimentX_Fight_2"),
		Tinkerer:teleport("Tinkerer"),

		Camera:target(Player),
		Camera:zoom(25),
		Camera:translate(Vector(6, 0, 0)),
		Camera:verticalRotate(-math.pi / 2 + math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 + math.pi / 24),

		ExperimentX:lookAt(Player),
		ExperimentX:playAnimation("ExperimentX_Idle_Wizard", "x-idle"),
		ExperimentX:wait(1.5),

		Parallel {
			Sequence {
				Player:wait(0.5),
				Player:playAttackAnimation(ExperimentX, 1),
				Player:wait(0.5),
				Player:playAttackAnimation(ExperimentX, 1),
				Player:wait(0.5),
				Player:playAttackAnimation(ExperimentX, 1)
			},

			Sequence {
				ExperimentX:playAnimation("ExperimentX_Attack_Wizard", "x-combat"),
				ExperimentX:fireProjectile(Player, "FireBlast_ExperimentX"),
				ExperimentX:wait(0.75),

				ExperimentX:playAnimation("ExperimentX_Idle_Warrior", "x-idle"),
				ExperimentX:wait(1),
				ExperimentX:playAnimation("ExperimentX_Attack_Warrior", "x-combat"),
				ExperimentX:wait(1.25),

				ExperimentX:playAnimation("ExperimentX_Idle_Archer", "x-idle"),
				ExperimentX:wait(1),
				ExperimentX:playAnimation("ExperimentX_Attack_Archer", "x-combat"),
				ExperimentX:fireProjectile(Player, "ItsyArrow_ExperimentX"),
				ExperimentX:wait(1.5)
			},

			Sequence {
				Tinkerer:wait(2),
				Tinkerer:playAnimation("Tinkerer_Special_Attack"),
				Tinkerer:fireProjectile(ExperimentX, "SoulStrike"),

				Tinkerer:wait(3),
				Tinkerer:playAnimation("Tinkerer_Special_Attack"),
				Tinkerer:fireProjectile(ExperimentX, "SoulStrike"),
			}
		},

		ExperimentX:playAnimation("ExperimentX_Idle_Wizard", "x-idle"),
	},

	-- Tinkerer heals Experiment X
	Sequence {
		Camera:target(Tinkerer),
		Camera:zoom(25),
		Camera:translate(Vector.ZERO),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 - math.pi / 24),

		Tinkerer:wait(1),

		Parallel {
			Sequence {
				Player:wait(0.5),
				Player:playAttackAnimation(ExperimentX, 1),

				Player:wait(0.5),
				Player:playAttackAnimation(ExperimentX, 1),
			},

			Sequence {
				ExperimentX:playAnimation("ExperimentX_Attack_Wizard", "x-combat"),
				ExperimentX:fireProjectile(Player, "FireBlast_ExperimentX"),
				ExperimentX:wait(0.75),

				ExperimentX:playAnimation("ExperimentX_Idle_Warrior", "x-idle"),
				ExperimentX:wait(1),
			},

			Sequence {
				Tinkerer:playAnimation("Tinkerer_Special_Attack"),
				Tinkerer:fireProjectile(ExperimentX, "SoulStrike"),
				Tinkerer:wait(3)
			}
		},

		ExperimentX:playAnimation("ExperimentX_Idle_Wizard", "x-idle"),
	},

	-- Experiment X dies
	Sequence {
		ExperimentX:teleport("Trailer_Sweep_ExperimentX_2"),
		Player:teleport("Trailer_ExperimentX_Fight_2"),
		Tinkerer:teleport("Tinkerer"),

		Camera:target(ExperimentX),
		Camera:zoom(25),
		Camera:translate(Vector.ZERO),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 - math.pi / 24),

		ExperimentX:playAnimation("ExperimentX_Idle"),
		ExperimentX:lookAt(Player),
		ExperimentX:wait(2),

		Parallel {
			Player:playAttackAnimation(ExperimentX, 1),

			Sequence {
				ExperimentX:playAnimation("ExperimentX_Die"),
				Camera:zoom(45, 0.25),
				ExperimentX:wait(1)
			}
		}
	},

	-- Tinkerer summons bones
	Sequence {
		ExperimentX:teleport("Trailer_Sweep_ExperimentX_2"),
		Player:teleport("Trailer_ExperimentX_Fight_2"),
		Tinkerer:teleport("Tinkerer"),
		CameraDolly:teleport("Tinkerer"),

		Camera:target(CameraDolly),
		Camera:zoom(25),
		Camera:translate(Vector.ZERO),
		Camera:verticalRotate(-math.pi / 2 + math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 + math.pi / 12),

		Parallel {
			Sequence {
				Player:follow(Tinkerer, 4.5),
				Player:wait(0.25),
				Player:face(Tinkerer),
				Player:playAttackAnimation(ExperimentX, 1),
			},

			Sequence {
				Tinkerer:playAttackAnimation(Player, 2)
			}
		},

		Parallel {
			Tinkerer:playAnimation("Tinkerer_Special_Attack"),
			Player:walkTo("Trailer_Tinkerer_BoneBlast"),

			Camera:zoom(35, 0.25),
			Camera:horizontalRotate(-math.pi / 6 - math.pi / 12, 0.25),

			While {
				CameraDolly:lerpPosition("Trailer_Tinkerer_BoneBlast", 2, "sineEastOut"),

				Sequence {
					Tinkerer:wait(0.125),
					Tinkerer:fireProjectile(CameraDolly, "Tinkerer_BoneBlast")
				}
			}
		}
	},

	-- Tinkerer summons fleshy pillar
	Sequence {
		ExperimentX:teleport("Trailer_Sweep_ExperimentX_2"),
		Player:teleport("Trailer_ExperimentX_Fight_2"),
		Tinkerer:teleport("Tinkerer"),
		FleshyPillar:teleport("Trailer_Sweep_SurgeonZombi_1"),

		Camera:target(FleshyPillar),
		Camera:zoom(20),
		Camera:translate(Vector(0, -5, 0)),
		Camera:verticalRotate(-math.pi / 2),
		Camera:horizontalRotate(-math.pi / 6),

		FleshyPillar:wait(1),

		FleshyPillar:playAnimation("FleshyPillar_Idle"),
		Camera:translate(Vector.ZERO, 0.25),
		FleshyPillar:wait(1.5),

		Camera:target(Player),
		Player:teleport("Trailer_Tinkerer_BoneBlast"),
		Camera:zoom(25),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 - math.pi / 24),

		Player:follow(FleshyPillar, 4.5),

		Parallel {
			Player:playAttackAnimation(FleshyPillar, 1.5),
			FleshyPillar:fireProjectile(ExperimentX, "SoulStrike")
		},

		Camera:target(ExperimentX),
		Camera:zoom(35),
		Camera:verticalRotate(-math.pi / 2),
		Camera:horizontalRotate(-math.pi / 6),
		ExperimentX:playAnimation("ExperimentX_Resurrect"),
		ExperimentX:lookAt(Player)
	},

	-- Player death
	Sequence {
		ExperimentX:teleport("Trailer_ExperimentX_Fight_1"),
		Player:teleport("Trailer_ExperimentX_Fight_2"),
		Tinkerer:teleport("Tinkerer"),

		Camera:target(Player),
		Camera:zoom(25),
		Camera:translate(Vector(6, 0, 0)),
		Camera:verticalRotate(-math.pi / 2 + math.pi / 6),
		Camera:horizontalRotate(-math.pi / 6 + math.pi / 24),

		ExperimentX:lookAt(Player),
		ExperimentX:playAnimation("ExperimentX_Idle_Wizard", "x-idle"),
		ExperimentX:wait(1.5),

		Parallel {
			Sequence {
				Player:playAttackAnimation(ExperimentX, 1),
				Camera:translate(Vector.ZERO),
				Camera:zoom(10),
				Player:talk("Aaaah!"),
				Player:playAnimation("Human_Die_1"),
				Player:wait(1),
			},

			Sequence {
				ExperimentX:playAnimation("ExperimentX_Attack_Wizard", "x-combat"),
				ExperimentX:fireProjectile(Player, "Power_IceBarrage"),
				ExperimentX:usePower("IceBarrage"),
				ExperimentX:wait(0.75)
			}
		}
	}
}
