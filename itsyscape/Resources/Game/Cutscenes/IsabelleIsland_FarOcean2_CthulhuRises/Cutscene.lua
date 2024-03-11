local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local DARK = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 48,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "Something from the deep dark depths of the ocean is surfacing..."
}

return Sequence {
	CameraDolly:teleport("Anchor_Cthulhu_Spawn"),

	Jenkins:setState(false),
	SoakedLog:teleport("Anchor_JenkinsShip_Cthulhu"),
	SoakedLog:lookAt("Anchor_JenkinsShip_4"),
	SoakedLog:hide(),

	CapnRaven:setState(false),
	DeadPrincess:teleport("Anchor_PirateShip_Cthulhu"),
	DeadPrincess:lookAt("Anchor_PirateShip_1"),
	DeadPrincess:hide(),

	Camera:target(CameraDolly),

	Camera:zoom(20),
	Camera:zoom(100, 2.5),
	Player:narrate("", DARK, 5),

	SoakedLog:show(),
	DeadPrincess:show(),

	CapnRaven:setState("idle"),
	Jenkins:setState("idle"),

	CapnRaven:waitForState("cthulhu"),
	Jenkins:waitForState("cthulhu"),

	Map:wait(1),
	Map:poke("cthulhuRises"),

	Map:poke("boom", SoakedLog:getPeep()),
	Map:poke("boom", DeadPrincess:getPeep()),

	Orlando:setState("run"),

	Camera:zoom(35),
	Camera:translate(Vector(0, 10, 0)),
	Map:wait(4),

	Camera:target(Jenkins),
	Camera:translate(Vector(0, 0, 0)),
	Camera:zoom(35),
	Jenkins:talk("Oi! Watch out, Rosalind!", 3),
	Jenkins:wait(3),

	Camera:target(Rosalind),
	Rosalind:talk("Aah! The light! It burns!", 3),
	Rosalind:wait(3),

	Camera:target(Orlando),
	Orlando:talk("OH NO, ROSALIND!", 3),
	Orlando:wait(3),

	Player:dialog("IntroDialog"),

	Rosalind:setState("attack"),
	Jenkins:setState("flee"),
	Map:poke("flee")
}
