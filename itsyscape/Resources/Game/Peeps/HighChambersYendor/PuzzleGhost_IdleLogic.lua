--------------------------------------------------------------------------------
-- Resources/Game/Peeps/HighChambersYendor/PuzzleGhost_IdleLogic.lua
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
				radial_distance = 3
			},

			Mashina.Peep.Wait,

			Mashina.RandomSequence {
				Mashina.Peep.Talk {
					message = "This darkness... It soothes my soul.",
					log = false
				},

				Mashina.Peep.Talk {
					message = "No light... No light...!",
					log = false
				},

				Mashina.Peep.Talk {
					message = "I hate the sun... I hate fire... I hate light...",
					log = false
				}
			},

			Mashina.Peep.TimeOut {
				min_duration = 2,
				max_duration = 4
			},
		}
	}
}

return Tree
