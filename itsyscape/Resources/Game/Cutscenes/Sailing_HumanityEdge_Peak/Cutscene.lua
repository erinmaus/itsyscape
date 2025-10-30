return Sequence {
	CameraDolly:teleport("Anchor_Cutscene_Ships1"),
	Camera:target(CameraDolly),
	Camera:zoom(65),
	Camera:zoom(80, 2),
	Camera:verticalRotate(math.pi / 4),
	Camera:verticalRotate(-math.pi / 8, 2),
	CameraDolly:wait(2),

	CameraDolly:teleport("Anchor_Cutscene_Ships2"),
	Camera:target(CameraDolly),
	Camera:zoom(65),
	Camera:zoom(80, 2),
	Camera:verticalRotate(math.pi / 4),
	Camera:verticalRotate(math.pi / 8, 2),
	CameraDolly:wait(2),

	Camera:verticalRotate(0),

	CameraDolly:teleport(Yendorian1),
	Camera:zoom(15),
	Camera:zoom(20, 2),
	Camera:verticalRotate(-math.deg(45)),
	CameraDolly:wait(2),

	CameraDolly:teleport(Yendorian2),
	Camera:zoom(15),
	Camera:zoom(20, 1),
	Camera:verticalRotate(math.deg(45)),
	CameraDolly:wait(2),

	CameraDolly:teleport(Yendorian3),
	Camera:zoom(15),
	Camera:zoom(20, 2),
	Camera:verticalRotate(0),
	CameraDolly:wait(2),

	CameraDolly:teleport(Player),
	Camera:zoom(15),
	Player:dialog("Talk", Orlando, "quest_tutorial_reached_peak.found_pirates"),
	KnightCommander:setState(false),
	KnightCommander:walkTo("Anchor_Spawn", 0, false, false),

	CameraDolly:teleport(CapnRaven),
	Camera:zoom(15),

	Player:dialog("Talk", CapnRaven, "quest_tutorial_initial_encounter.reach_peak"),

	CameraDolly:teleport(Pirate1),
	Camera:verticalRotate(-math.pi / 4),

	Player:dialog("Talk", CapnRaven, "quest_tutorial_initial_encounter.fire_cannon"),

	Pirate1:setState("gun-player-cutscene"),

	Parallel {
		Sequence {
			Pirate1:wait(1.5),
			Camera:zoom(75, 1.5),
			Pirate1:wait(2.5)
		},

		Pirate1:waitForState("gun-yendorians"),
	},

	CameraDolly:teleport(Player),
	Camera:zoom(15),

	Player:wait(1),

	Pirate1:fireProjectile(Player, "CannonSplosion"),
	Pirate1:wait(0.1),
	Pirate1:fireProjectile(Player, "CannonSplosion"),
	Pirate1:wait(0.1),

	Player:playAnimation("Human_Die_1"),
	Orlando:playAnimation("Human_Die_1"),

	CameraDolly:teleport(Player),
	Camera:target(CameraDolly),

	Parallel {
		Sequence {
			Camera:zoom(60, 1),
			Player:wait(1.5),

			Camera:target(Player),
		},

		Parallel {
			Player:curvePositions({ "Anchor_Cutscene_Peak1", "Anchor_Cutscene_Peak2", "Anchor_Cutscene_Peak3" }, 3),
			Player:spin(4, 2.75, Vector.UNIT_Z)
		},

		Sequence {
			Orlando:wait(0.1),

			Parallel {
				Orlando:curvePositions({ "Anchor_Cutscene_Peak1", "Anchor_Cutscene_Peak2", "Anchor_Cutscene_Peak3" }, 2.75),
				Orlando:spin(5, 2.5, Vector.UNIT_Z)
			},
		}
	},

	Player:playAnimation("Human_Resurrect_1"),
	Orlando:playAnimation("Human_Resurrect_1"),

	Player:wait(1),
	Player:stopAnimation(),
	Orlando:stopAnimation(),
}
