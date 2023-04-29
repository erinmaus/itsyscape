--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_MineLogic.lua
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
	Mashina.Repeat {
		Mashina.Step {
			Mashina.Skills.GatherNearbyResource {
				action = "Chop",
				resource = "CommonLogs"
			},

			Mashina.Peep.Wait,

			Mashina.Peep.Talk {
				message = "TIMBER!",
				log = false
			},

			Mashina.Peep.TimeOut {
				min_duration = 1,
				max_duration = 2
			},

			Mashina.Repeat {
				Mashina.Step {
					Mashina.Peep.PokeInventoryItem {
						action = "Light",
						item = "CommonLogs"
					},

					Mashina.Peep.Wait,

					Mashina.Peep.TimeOut {
						min_duration = 1,
						max_duration = 2
					}
				}
			}
		}
	}
}

return Tree
