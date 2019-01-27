--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_TradeLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local PEEP = B.Reference("Miner", "PEEP")
local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.FindNearbyMapObject {
			prop = "Chest",
			[PEEP] = B.Output.RESULT
		},

		Mashina.Navigation.WalkToPeep {
			peep = PEEP,
			distance = 1.5
		},

		Mashina.Peep.Wait,

		Mashina.Peep.Trade {
			item = "BronzeBar",
			quantity = math.huge,
			target = PEEP,
		},

		Mashina.Peep.Trade {
			item = "CopperBar",
			quantity = math.huge,
			target = PEEP,
		},

		Mashina.Peep.Trade {
			item = "TinBar",
			quantity = math.huge,
			target = PEEP,
		},

		Mashina.Peep.SetState {
			state = "mine"
		}
	}
}

return Tree
