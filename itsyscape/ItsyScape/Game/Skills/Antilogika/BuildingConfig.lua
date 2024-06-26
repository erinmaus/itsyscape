--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/BuildingConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"

local BuildingConfig = {
	{
		id = "Castle",
		layout = "ItsyScape.Game.Skills.Antilogika.CastleFloorLayout",
		floors = { min = 4, max = 6 },
		rooms = { min = 6, max = 32 },
		width = { min = 32, max = 48 },
		depth = { min = 32, max = 48 },
		split = {
			min = 0.35, max = 0.75,
			minWidth = 5,
			minDepth = 5,
			iterations = 2
		},

		props = {
			numTowers = { min = 1, max = 4 },
			relativeTowerSize = { min = 0.3, max = 0.35 },
			towerOffsets = {}
		}
	},
	{
		id = "Azathoth_Cabin",
		layout = "ItsyScape.Game.Skills.Antilogika.SmallBuildingLayout",
		floors = { min = 1, max = 2 },
		rooms = { min = 1, max = 3 },
		width = { min = 8, max = 13 },
		depth = { min = 8, max = 13 },
		split = {
			min = 0.45, max = 0.55,
			minWidth = 5,
			minDepth = 5,
			iterations = 2
		},

		props = {
			seedRoom = { "Foyer_AzathothCabin" }
		}
	}
}

return BuildingConfig
