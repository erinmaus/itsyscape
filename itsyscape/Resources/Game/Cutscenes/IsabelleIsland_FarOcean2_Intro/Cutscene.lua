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
	Camera:target(Player),

	-- Camera:translate(Vector(64, 0, 64)),
	-- Camera:zoom(100),

	-- Player:narrate("", HERO, 10),
	-- Player:wait(10),
	-- Player:dialog("IntroDialog"),
}
