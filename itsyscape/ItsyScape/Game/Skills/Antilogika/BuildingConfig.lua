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
		floors = { min = 4, max = 6 },
		rooms = { min = 6, max = 32 },
		width = { min = 32, max = 48 },
		depth = { min = 32, max = 48 },
		root = "Courtyard",
		rootPosition = { x = 0.5, y = 0.5 }
	}
}

return BuildingConfig
