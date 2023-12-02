--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Prisoner_PrisonBreakLogic.lua
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

local LADDER = B.Reference("Prisoner", "LADDER")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.TimeOut {
			min_duration = 0.25,
			max_duration = 1.0
		},

		Mashina.RandomTry {
			Mashina.Peep.Talk {
				message = "See ya, pigs!",
			},

			Mashina.Peep.Talk {
				message = "Finally, I'm free!",
			},

			Mashina.Peep.Talk {
				message = "Suckers!",
			},

			Mashina.Peep.Talk {
				message = "Thank Bastiel! I'll never jaywalk again!",
			},

			Mashina.Peep.Talk {
				message = "Oh boy! Back to murderin'!",
			}
		},

		Mashina.Peep.FindNearbyMapObject {
			prop = "MetalLadder_ToPalace",
			[LADDER] = B.Output.RESULT
		},

		Mashina.Navigation.WalkToPeep {
			peep = LADDER,
			distance = 1.5,
			as_close_as_possible = true
		},

		Mashina.Peep.Wait,

		Mashina.Peep.TimeOut {
			min_duration = 0.25,
			max_duration = 1.0
		},

		Mashina.Peep.Poof
	}
}

return Tree

