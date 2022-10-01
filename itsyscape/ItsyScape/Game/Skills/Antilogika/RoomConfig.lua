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
		id = "CastleEntrance",
		width = { min = 12, max = 16 },
		depth = { min = 12, max = 16 },
		rooms = { min = 1, max = 1 }
	},
	{
		id = "CastleTower",
		width = { min = 6, max = 8 },
		depth = { min = 6, max = 8 },
		aspectRatio = 1
	},
	{
		id = "Courtyard",
		width = { min = 12, max = 16 },
		height = { min = math.huge, max = math.huge },
		depth = { min = 12, max = 16 },
		aspectRatio = 1,
		anchors = {
			[{ BuildingAnchor.BACK, BuildingAnchor.LEFT, BuildingAnchor.RIGHT }] = {
				"GreatHall",
				"Foyer",
				"Armory"
			},
			[BuildingAnchor.FRONT] = {
				"CastleEntrance"
			}
		}
	},
	{
		id = "GreatHall",
		width = { min = 16, max = 24 },
		height = { min = 2, max = 3 },
		depth = { min = 16, max = 24 },
		aspectRatio = 2 / 1,
		rooms = { min = 1, max = 1 },
		required = {
			"Chapel",
			"Kitchen",
			"Foyer"
		},
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Chapel",
				"Kitchen",
				"LordFoyer"
			}
		}
	},
	{
		id = "Kitchen",
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Kitchen",
				"Pantry",
				"Larder",
				"Bedroom_Servants"
			}
		}
	},
	{
		id = "Bedroom_Servants",
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Bedroom_Servants",
				"Bathroom_Servants"
			}
		}
	},
	{
		id = "Bedroom_Fancy",
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Bedroom_Fancy",
				"Solary",
				"Study",
				"Bathroom_Fancy"
			}
		}
	},
	{
		id = "LordFoyer",
		rooms = { max = 1 },
		width = { min = 16, max = 18 },
		height = { min = 16, max = 18 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Bedroom_Fancy"
			}
		}
	},
	{
		id = "Foyer",
		rooms = { max = 1 },
		width = { min = 16, max = 18 },
		height = { min = 16, max = 18 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Bedroom_Fancy"
			}
		}
	},
	{
		id = "Armory",
		rooms = { max = 1 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Smithy",
				"Bedroom_Soldiers",
				"Closet"
			}
		}
	},
	{
		id = "Chapel",
		rooms = { max = 1 }
	}
}

return RoomConfig
