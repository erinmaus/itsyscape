local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

return Parallel {
	Sequence {
		Camera:target(Orlando),
		Camera:zoom(1),
		Camera:horizontalRotate(0),
		Camera:translate(Vector(-1, 1, 10), 0),
		Map:wait(2),
		Camera:translate(Vector(-1, 1, 4), 3),
		Map:wait(2)
	},

	Sequence {
		Map:wait(2),

		Map:poke('writeLine', {
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 160,
			textShadow = true,
			align = 'left',
			width = DramaticTextController.CANVAS_WIDTH / 2 - DramaticTextController.CANVAS_WIDTH / 6,
			x = DramaticTextController.CANVAS_WIDTH / 6,
			y = DramaticTextController.CANVAS_HEIGHT / 2 - 80,
			text = "Fight!"
		}),

		Map:wait(5)
	}
}
