local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

return Sequence {
	Sequence {
		Camera:target(TheEmptyKing),
		Camera:zoom(30),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 8)
	},

	Map:wait(2),

	Sequence {
		Map:poke('engage', TheEmptyKing, Player),
		Camera:zoom(25, 0.5),
		Map:wait(1),
		Map:poke('writeLine', {
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 80,
			textShadow = true,
			align = 'center',
			width = DramaticTextController.CANVAS_WIDTH,
			height = 80,
			x = 0,
			y = DramaticTextController.CANVAS_HEIGHT - 256,
			text = "I WILL DECIDE YOUR FATE!"
		}),
		Map:wait(3),
		Map:poke('clearText')
	},

	Sequence {
		Camera:target(Player),
		Camera:horizontalRotate(-math.pi / 4),
		Camera:zoom(15),
		Camera:verticalRotate(-math.pi / 2),
		Map:poke('splode', Player),
		Player:talk("Aaaah!"),
		Player:playAnimation("Human_Die_1", 'main', math.huge, true),
		Player:wait(2)
	}
}
