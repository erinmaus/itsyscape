--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Orland.lua
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
		Mashina.Peep.PlayAnimation {
			animation = "Human_Run_Crazy_1",
			priority = math.huge,
			slot = "x-run"
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Navigation.PathFollow {
					tiles = {
						"Anchor_Sailor1_Left",
						"Anchor_Sailor2_Left",
						"Anchor_Sailor1_Right",
						"Anchor_Sailor2_Right"
					}
				},

				Mashina.Peep.Wait
			}
		}
	}
}

return Tree
