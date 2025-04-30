return Sequence {
	Camera:target(Keelhauler),
	Camera:zoom(10),
	Camera:zoom(30, 2),
	Keelhauler:wait(2),

	Camera:target(Player),

	Parallel {
		Orlando:walkTo("Anchor_VsPirates", 2.5),
		Player:walkTo("Anchor_VsPirates")
	},

	Player:dialog("Talk", CapnRaven, "quest_tutorial_main_defeat_keelhauler.intro"),

	Camera:target(KnightCommander),
	Camera:zoom(30),
	Player:dialog("Talk", KnightCommander, "quest_tutorial_main_defeat_keelhauler"),
	Player:wait(5),

	Camera:target(Player),
	Player:dialog("Talk", CapnRaven, "quest_tutorial_main_defeat_keelhauler.vs_knights")
}
