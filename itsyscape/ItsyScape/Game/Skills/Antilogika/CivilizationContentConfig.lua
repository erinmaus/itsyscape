--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/CivilizationContentConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local CivilizationContentConfig = {
	{
		id = "HeavyForest",

		livingScale = 0.75,
		populationScale = -0.5,

		content = {
			"Woodcutting",
			"Combat"
		}
	},
	{
		id = "River",

		livingScale = 0.5,
		populationScale = -0.75,

		content = {
			"River",
		}
	},
	{
		id = "Cabin",

		livingScale = 0.25,
		populationScale = -0.6,

		content = {
			"SmallBuilding"
		}
	},
	{
		id = "Mine",

		livingScale = 0.0,
		populationScale = -0.9,

		content = {
			"Mining",
			"Combat"
		}
	},
	-- {
	-- 	id = "City",

	-- 	livingScale = 0.5,
	-- 	populationScale = 0.5,
	-- },
	-- {
	-- 	id = "Town",

	-- 	livingScale = 0.25,
	-- 	populationScale = 0.25
	-- },
	-- {
	-- 	id = "Dungeon",

	-- 	livingScale = -0.25,
	-- 	populationScale = 0.25,
	-- }
}

return CivilizationContentConfig
