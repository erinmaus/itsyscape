--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_SmeltLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Skills.CraftViaNearbyProp {
			prop = "Furnace_Default",
			action = "Smelt",
			resource = "BronzeBar"
		},

		Mashina.Peep.Wait,

		Mashina.Success {
			Mashina.Skills.CraftViaNearbyProp {
				prop = "Furnace_Default",
				action = "Smelt",
				resource = "CopperBar"
			},
		},

		Mashina.Peep.Wait,

		Mashina.Success {
			Mashina.Skills.CraftViaNearbyProp {
				prop = "Furnace_Default",
				action = "Smelt",
				resource = "TinBar"
			},
		},

		Mashina.Peep.Wait,

		Mashina.Peep.SetState {
			state = "deposit"
		}
	}
}

return Tree
