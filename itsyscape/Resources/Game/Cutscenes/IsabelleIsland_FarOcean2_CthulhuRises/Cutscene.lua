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
	text = "Something from the deep dark depths of the ocean is rising..."
}

return Sequence {
	CameraDolly:teleport("Anchor_Cthulhu_Spawn"),

	Jenkins:setState(false),
	SoakedLog:teleport("Anchor_JenkinsShip_Cthulhu"),
	SoakedLog:lookAt("Anchor_JenkinsShip_1"),
	SoakedLog:hide(),

	CapnRaven:setState(false),
	DeadPrincess:teleport("Anchor_PirateShip_Cthulhu"),
	DeadPrincess:lookAt("Anchor_PirateShip_1"),
	DeadPrincess:hide(),

	Camera:target(CameraDolly),

	Camera:zoom(75),
	Player:narrate("", DARK, 5),
	Player:wait(1),

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

	Player:wait(2),
	Player:dialog("IntroDialog")
}
