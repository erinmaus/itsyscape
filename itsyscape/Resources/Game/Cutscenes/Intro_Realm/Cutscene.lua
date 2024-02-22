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
		Map:poke("show", "Rumbridge_Town_Center"),

		Map:wait(8),

		Map:poke("hide", "Rumbridge_Town_Center"),
	},

	Sequence {
		Map:poke("show", "EmptyRuins_DragonValley_Ginsville"),

		Map:wait(8),

		Map:poke("hide", "EmptyRuins_DragonValley_Ginsville"),
	},

	Sequence {
		Map:poke("show", "ViziersRock_Town_Center"),

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

	Player:move("Rumbridge_Castle_Floor1?cutscene=intro,mute=1", "Anchor_FromStairs", 6)
}
