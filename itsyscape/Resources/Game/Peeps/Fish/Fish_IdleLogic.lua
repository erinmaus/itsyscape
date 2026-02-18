--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Fish/BaseFish.lua
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

local WanderWait = Mashina.Step {
	Mashina.Navigation.Wander {
		radial_distance = 16,
		min_radial_distance = 4
	},

	Mashina.Peep.Wait
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			WanderWait
		}
	}
}

return Tree
