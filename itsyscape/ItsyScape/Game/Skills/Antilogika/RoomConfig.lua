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
		id = "Foyer_AzathothCabin",
		width = { min = 5, max = 8 },
		depth = { min = 5, max = 8 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Bedroom_Azathoth",
				"Bedroom_Closet"
			}
		}
	},
	{
		id = "Bedroom_Azathoth",
		width = { min = 5, max = 8 },
		depth = { min = 5, max = 8 },
		anchors = {
			[BuildingAnchor.PLANE_XZ] = {
				"Bedroom_Closet",
				"Bathroom"
			}
		}
	},
	{
		id = "ErrorRoom"
	}
}

return RoomConfig
