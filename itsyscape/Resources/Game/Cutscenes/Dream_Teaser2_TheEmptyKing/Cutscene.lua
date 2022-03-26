local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

return Parallel {
	Sequence {
		Camera:target(TheEmptyKing),
		Camera:zoom(1),
		Camera:horizontalRotate(0),
		Camera:translate(Vector(1, 0.5, 10), 0),
		Map:wait(2),
		Camera:translate(Vector(1, 0.5, 2), 3),
		Map:wait(5)
	},

	Sequence {
		Map:wait(2),

		Map:poke('writeLine', {
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 64,
			textShadow = true,
			align = 'left',
			width = DramaticTextController.CANVAS_WIDTH / 2 - DramaticTextController.CANVAS_WIDTH / 6,
			height = 48,
			x = DramaticTextController.CANVAS_HEIGHT / 2 + DramaticTextController.CANVAS_WIDTH / 6,
			y = DramaticTextController.CANVAS_HEIGHT / 2 - 64,
			text = "Fate controls you."
		}),

		Map:wait(1.5),

		Map:poke('writeLine', {
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 80,
			textShadow = true,
			align = 'left',
			width = DramaticTextController.CANVAS_WIDTH / 2 - DramaticTextController.CANVAS_WIDTH / 6,
			height = 56,
			x = DramaticTextController.CANVAS_HEIGHT / 2 + DramaticTextController.CANVAS_WIDTH / 6,
			y = DramaticTextController.CANVAS_HEIGHT / 2 + 64,
			text = "I control fate."
		})
	}
}
