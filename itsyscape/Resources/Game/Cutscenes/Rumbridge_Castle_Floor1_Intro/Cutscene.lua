local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local SHADOWS = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "But distant shadows have started moving."
}

local WHISPERS = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 128,
	text = "Whispers have begun of a threat to the balance of things."
}

return Sequence {
	RumbridgeCastle1:show(),
	RumbridgeCastle2:show(),

	Player:narrate("", SHADOWS, 8),

	Kvre:playAnimation("Darken"),
	Isabelle:playAnimation("Darken"),
	EarlReddick:playAnimation("Darken"),

	Kvre:lookAt(EarlReddick),
	Isabelle:face(EarlReddick),

	Camera:target(EarlReddick),
	Camera:zoom(20),
	Camera:zoom(30, 8),

	Player:wait(4),
	Player:narrate("", WHISPERS, 4),
	Player:wait(4),

	Player:move("@IsabelleIsland_FarOcean2", "Anchor_Spawn")
}
