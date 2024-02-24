local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local PEACE1 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "The enchantment has held for as long as written history can remember."
}

local PEACE2 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 128,
	text = "The Old Ones are beyond the reach of mortals on the physical plane."
}

local PEACE3 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "An uneasy peace has kept between the mortal world and a divine bureaucracy - the Fate Mashina -"
}

local PEACE4 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 128,
	text = "with the all-knowing, all-powerful Empty King at the throne."
}

local NarrationSequence = Sequence {
	Player:narrate("", PEACE1, 11),
	Player:wait(6),

	Player:narrate("", PEACE2, 5),
	Player:wait(6),

	Player:narrate("", PEACE3, 11),
	Player:wait(6),

	Player:narrate("", PEACE4, 5),
	Player:wait(6),
}

local MapSequence = Sequence {
	Sequence {
		RumbridgeTownCenter:show(),

		Map:wait(8),

		RumbridgeTownCenter:hide()
	},

	Sequence {
		Ginsville:show(),

		Map:wait(8),

		Ginsville:hide()
	},

	Sequence {
		ViziersRockTownCenter:show(),

		Map:wait(8)
	}
}

return Sequence {
	Parallel {
		Sequence {
			Camera:zoom(50),
			Camera:target(CameraDolly),

			CameraDolly:teleport("Anchor_Pan1"),

			Parallel {
				Camera:translate(Vector(32, 0, -32), 32),

				NarrationSequence,
				MapSequence
			}
		}
	},

	RumbridgeCastle:poke("playIntroCutscene", Player:getPeep()),
	Player:wait(),

	ViziersRockTownCenter:hide()
}
