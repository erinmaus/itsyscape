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

local MIN_DURATION = B.Reference("Fish_ReelLogic", "MIN_DURATION")
local MAX_DURATION = B.Reference("Fish_ReelLogic", "MAX_DURATION")

local Reel = Mashina.Step {
	Mashina.Peep.PlayAnimation {
		animation = "Fish_Reel",
		slot = "fish",
		priority = 500
	},

	Mashina.Sequence {
		Mashina.Peep.GetArgument {
			key = "reel-min-duration",
			default = 1,
			[MIN_DURATION] = B.Output.result
		},

		Mashina.Peep.GetArgument {
			key = "reel-max-duration",
			default = 2,
			[MAX_DURATION] = B.Output.result
		},

		Mashina.Peep.TimeOut {
			min_duration = MIN_DURATION,
			max_duration = MAX_DURATION
		}
	},

	Mashina.Peep.StopAnimation {
		slot = "fish"
	},

	Mashina.Peep.SetState {
		state = "idle"
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.Interrupt {
				everything = true
			}
		},
	},

	Mashina.Repeat {
		Mashina.Success {
			Reel
		}
	}
}

return Tree
