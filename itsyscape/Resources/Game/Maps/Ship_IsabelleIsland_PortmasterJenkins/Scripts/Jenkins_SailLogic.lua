--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Jenkins_CutsceneLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local DISTANCE = 8

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Sailing.Sail {
			target = "Anchor_JenkinsShip_Flee1",
			distance = DISTANCE
		},

		Mashina.Sailing.Sail {
			target = "Anchor_JenkinsShip_Flee2",
			distance = DISTANCE
		},

		Mashina.Repeat {
			Mashina.Sailing.Sail {
				direction = 0
			},
		}
	}
}

return Tree
