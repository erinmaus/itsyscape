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
	text = "A peace has kept between the mortal world and a divine bureaucracy - the Fate Mashina -"
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

return Sequence {
	Camera:zoom(50),
	Camera:target(CameraDolly),

	CameraDolly:teleport("Anchor_Pan1"),

	Parallel {
		CameraDolly:lerpPosition("Anchor_Pan2", 12),
		
		Sequence {
			Player:narrate("", PEACE1, 6),

			Sequence {
				Map:poke("show", "IsabelleIsland_Tower_Floor5"),
				Map:poke("show", "IsabelleIsland_Tower_Floor4"),
				Map:poke("show", "IsabelleIsland_Tower_Floor3"),
				Map:poke("show", "IsabelleIsland_Tower_Floor2"),
				Map:poke("show", "IsabelleIsland_Tower"),

				Map:wait(3),

				Map:poke("hide", "IsabelleIsland_Tower_Floor5"),
				Map:poke("hide", "IsabelleIsland_Tower_Floor4"),
				Map:poke("hide", "IsabelleIsland_Tower_Floor3"),
				Map:poke("hide", "IsabelleIsland_Tower_Floor2"),
				Map:poke("hide", "IsabelleIsland_Tower"),
			},

			Player:narrate("", PEACE2, 3),

			Sequence {
				Map:poke("show", "Rumbridge_Town_Center"),

				Map:wait(3),

				Map:poke("hide", "Rumbridge_Town_Center"),
			},

			Player:narrate("", PEACE3, 6),

			Sequence {
				Map:poke("show", "EmptyRuins_DragonValley_Ginsville"),

				Map:wait(3),

				Map:poke("hide", "EmptyRuins_DragonValley_Ginsville"),
			},

			Player:narrate("", PEACE4, 3),

			Sequence {
				Map:poke("show", "ViziersRock_Town_Center"),

				Map:wait(3),

				Map:poke("hide", "ViziersRock_Town_Center"),
			}
		}
	}
}
