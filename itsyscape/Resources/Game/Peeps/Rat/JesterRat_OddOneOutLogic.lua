--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Rat/JesterRat_OddOneOutLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.TimeOut {
			duration = 5
		},

		Mashina.Peep.Talk {
			message = "Three...",
			duration = 1.5
		},

		Mashina.Peep.TimeOut {
			duration = 1.5
		},

		Mashina.Peep.Talk {
			message = "Two...",
			duration = 1.5
		},

		Mashina.Peep.TimeOut {
			duration = 1.5
		},

		Mashina.Peep.Talk {
			message = "One...!",
			duration = 1.5
		},

		Mashina.Peep.TimeOut {
			duration = 1.5
		},

		Mashina.Peep.Talk {
			message = "Time's up! And they call me the fool?!"
		},

		Mashina.Peep.PokeSelf {
			poke = 'odd-one-out',
			event = 'stopMinigame'
		}
	}
}

return Tree
