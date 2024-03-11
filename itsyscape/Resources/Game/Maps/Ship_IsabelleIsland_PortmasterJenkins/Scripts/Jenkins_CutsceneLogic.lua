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
	Mashina.Repeat {
		Mashina.Step {
			Mashina.Sailing.Sail {
				target = "Anchor_JenkinsShip_3",
				distance = DISTANCE
			},

			Mashina.Sailing.Sail {
				target = "Anchor_JenkinsShip_2",
				distance = DISTANCE
			},

			Mashina.Sailing.Sail {
				target = "Anchor_JenkinsShip_1",
				distance = DISTANCE
			}
		}
	}
}

return Tree
