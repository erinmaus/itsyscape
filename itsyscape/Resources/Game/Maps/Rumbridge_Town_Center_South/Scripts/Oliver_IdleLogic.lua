--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Town_Center_South/Scripts/Oliver_IdleLogic.lua
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
			Mashina.Navigation.Wander {
				radial_distance = 5
			},

			Mashina.Peep.Wait,

			Mashina.Peep.TimeOut {
				min_duration = 4,
				max_duration = 8
			}
		}
	}
}

return Tree
