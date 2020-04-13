--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Skelemental/IronSkelemental_AttackLogic.lua
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
		Mashina.Step {
			Mashina.Success {
				Mashina.Sequence {
					Mashina.RandomCheck {
						chance = 0.5
					},

					Mashina.Peep.Talk {
						message = "*shiver*" 
					},

					Mashina.Peep.QueuePower {
						power = "Boom",
						clear_cool_down = true
					}
				}
			},

			Mashina.Peep.TimeOut {
				min_duration = 3,
				max_duration = 6
			}
		}
	}
}

return Tree
