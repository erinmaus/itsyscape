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
	Mashina.Step {
		Mashina.Navigation.WalkToTile {
			i = 16,
			j = 21
		},

		Mashina.Peep.Wait,

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Skills.Mining.MineNearbyRock {
					resource = "CopperOre"
				},

				Mashina.Peep.Wait,

				Mashina.Skills.Mining.MineNearbyRock {
					resource = "TinOre"
				},

				Mashina.Peep.Wait
			}
		}
	}
}

return Tree
