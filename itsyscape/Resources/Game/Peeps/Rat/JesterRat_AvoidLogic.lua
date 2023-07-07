--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Rat/JesterRat_AvoidLogic.lua
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
	Mashina.ParallelSequence {
		Mashina.Sequence {
			Mashina.Peep.TimeOut {
				duration = 12
			},

			Mashina.Peep.PokeSelf {
				poke = 'avoid',
				event = 'stopMinigame'
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Peep.TimeOut {
					min_duration = 2,
					max_duration = 3
				},

				Mashina.Peep.PokeSelf {
					event = 'dropPresent'
				}
			}
		}
	}
}

return Tree
