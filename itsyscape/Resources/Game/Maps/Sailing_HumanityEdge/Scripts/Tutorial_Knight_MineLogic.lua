--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_ChopLogic.lua
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

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Mashina.Try {
				Mashina.Step {
					Mashina.Skills.GatherNearbyResource {
						action = "Mine",
						resource = "AzatiteOre"
					},

					Mashina.Peep.Wait
				}
			},

			Mashina.Step {
				Mashina.Navigation.Wander,
				Mashina.Peep.Wait
			}
		}
	}
}

return Tree
