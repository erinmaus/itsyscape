--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/RoomConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"

local RoomConfig = {
	{
		id = "Courtyard",
		width = { min = 12, max = 16 },
		height = { min = math.huge, max = math.huge },
		depth = { min = 12, max = 16 },
		aspectRatio = 1,
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"GreatHall",
				"Armory",
				"Foyer",
			}
		}
	},
	{
		id = "GreatHall",
		width = { min = 12, max = 18 },
		height = { min = 2, max = 3 },
		depth = { min = 16, max = 24 },
		aspectRatio = 2 / 1,
		rooms = { min = 1, max = 1 },
		anchors = {
			[BuildingAnchor.BACK] = {
				"Chapel"
			},
			[BuildingAnchor.LEFT] = {
				"Hallway_Kitchen",
				"Hallway_PrivateQuarters"
			},
			[BuildingAnchor.RIGHT] = {
				"Hallway_Kitchen",
				"Hallway_PrivateQuarters"
			}
		}
	},
	{
		id = "Hallway_Kitchen",
		isHallway = true,
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_Kitchen",
				"Kitchen",
				"Pantry",
				"Larder"
			},
			[BuildingAnchor.TOP] = {
				"Bedroom_Servants"
			},
			[BuildingAnchor.BOTTOM] = {
				"Buttery",
				"Cellar",
				"Basement"
			}
		}
	},
	{
		id = "Bedroom_Servants",
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_Kitchen",
				"Bedroom_Servants"
			}
		}
	},
	{
		id = "Hallway_PrivateQuarters",
		isHallway = true,
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_PrivateQuarters",
				"Solary",
				"Bedroom_Fancy"
			},
		}
	},
	{
		id = "Bedroom_Fancy",
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_PrivateQuarters",
				"Solary",
				"Study"
			},
		}
	},
	{
		id = "Foyer",
		rooms = { min = 1 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_PrivateQuarters"
			}
		}
	},
	{
		id = "Armory",
		rooms = { max = 1 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_Armory"
			}
		}
	},
	{
		id = "Hallway_Armory",
		isHallway = true,
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Hallway_Armory",
				"Bedroom_Soldiers"
			}
		}
	}
}

return RoomConfig