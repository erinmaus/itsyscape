local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local HERO = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 48,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "Little does anyone know the actions of an up-and-coming hero may stir the Old Ones from their slumber and bring about ruin of the Realm..."
}

return Sequence {
	Map:poke("engage"),

	Camera:target(Player),
	Camera:zoom(150),

	Player:narrate("", HERO, 10),
	Camera:zoom(75, 4),
	Player:wait(4),

	Map:poke("boom", SoakedLog:getPeep()),
	Player:wait(6),

	Player:dialog("IntroDialog")
}
