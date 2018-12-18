--------------------------------------------------------------------------------
-- Resources/Game/Peeps/UndeadSquid/UndeadSquid_SpawnLogic.lua
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
				min_radial_distance = 8,
				radial_distance = 32,
				wander_j = false
			},

			Mashina.Peep.Wait,

			Mashina.Navigation.Face {
				direction = 1
			},

			Mashina.Peep.TimeOut {
				min_duration = 2,
				max_duration = 3
			}
		}
	}
}

return Tree
