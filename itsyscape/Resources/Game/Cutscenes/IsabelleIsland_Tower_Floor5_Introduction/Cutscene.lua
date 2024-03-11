return Sequence {
	Player:addBehavior("Disabled"),
	Camera:target(Grimm),
	Camera:zoom(40),

	Player:dialog("GrimmYell1"),
	Camera:zoom(20, 5),
	
	Parallel {
		Grimm:walkTo("Anchor_GrimmOnTower"),

		Sequence {
			Grimm:wait(2),
			Grimm:talk("Huff... Huff... Huff...", 2),
			Grimm:wait(2),
			Grimm:talk("My knees are sure taking a beating...", 2),
		}
	},

	Player:removeBehavior("Disabled"),
	Player:dialog("GrimmYell2")
}
