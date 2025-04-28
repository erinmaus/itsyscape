return Sequence {
	CameraDolly:teleport("Anchor_Cutscene_Ships"),
	Camera:focus(CameraDolly),
	Camera:zoom(45),
	Camera:zoom(55, 2),
	Camera:verticalRotate(math.pi / 4),
	Camera:verticalRotate(math.pi / 8, 2),
	CameraDolly:wait(2),

	Camera:verticalRotate(0),

	CameraDolly:teleport(Yendorian1),
	Camera:zoom(25),
	Camera:zoom(35, 2)
	CameraDolly:wait(2),

	CameraDolly:teleport(Yendorian2),
	Camera:zoom(25),
	Camera:zoom(35, 2)
	CameraDolly:wait(2),

	CameraDolly:teleport(Yendorian2),
	Camera:zoom(25),
	Camera:zoom(35, 2)
	CameraDolly:wait(2),

	CameraDolly:teleport(Player),
	Camera:zoom(15),
	Player:dialog(Orlando, "Talk", "quest_tutorial_pirate_encounter.reach_peak"),
	KnightCommander:walkTo("Anchor_Spawn"),

	CameraDolly:teleport(CapnRaven),
	CameraDolly:zoom(15),

	Player:dialog(CapnRaven, "Talk", "quest_tutorial_initial_encounter.reach_peak"),

	CameraDolly:teleport(Pirate1),
	Camera:verticalRotate(-math.pi / 4),

	Player:dialog(CapnRaven, "Talk", "quest_tutorial_initial_encounter.fire_cannon"),

	Pirate1:setState("gun-player-cutscene"),
	Pirate1:waitForState("gun-yendorians"),

	CameraDolly:teleport(Player),
	Player:wait(0.5),

	Pirate1:fireProjectile("Anchor_Peak", "CannonSplosion"),

	Player:playAnimation("Human_Die_1"),
	Orlando:playAnimation("Human_Die_1"),

	Parallel {
		Player:curvePositions({ "Anchor_Cutscene_Peak1"} )
	}

	Player:playAnimation("Human_Resurrect_1"),
	Orlando:playAnimation("Human_Resurrect_1"),

	Player:wait(1),
	Player:stopAnimation(),
	Orlando:stopAnimation(),
}
