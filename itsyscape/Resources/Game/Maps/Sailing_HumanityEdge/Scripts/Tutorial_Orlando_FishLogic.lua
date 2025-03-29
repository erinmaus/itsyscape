--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FishLogic.lua
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

local ITEMS_TO_KEEP = {
	["TerrifyingFishingRod"] = true
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Success {
			Mashina.Step {
				Mashina.Skills.Fishing.FishNearbyFish {
					resource = "LightningStormfish"
				},

				Mashina.Peep.Wait,

				Mashina.Peep.DropInventoryItem {
					item = function(item)
						return not ITEMS_TO_KEEP[item:getID()]
					end
				}
			}
		},

		Mashina.Peep.SetState {
			state = "tutorial-follow-player"
		}
	}
}

return Tree
