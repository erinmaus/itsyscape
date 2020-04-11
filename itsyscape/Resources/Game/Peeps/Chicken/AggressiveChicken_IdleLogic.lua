--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Chicken/AgressiveChicken_IdleLogic.lua
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

local TARGET = B.Reference("AgressiveChicken_Idle", "TARGET")
local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = 4,
					[TARGET] = B.Output.RESULT
				},

				Mashina.Peep.EngageCombatTarget {
					peep = TARGET,
				},

				Mashina.Peep.SetState {
					state = 'attack'
				}
			}
		},

		Mashina.Step {
			Mashina.Navigation.Wander {
				radial_distance = 4
			},

			Mashina.Peep.Wait,

			Mashina.Peep.TimeOut {
				min_duration = 2,
				max_duration = 4
			},

			Mashina.Peep.Talk {
				message = "Bwak bwak bwak!"
			}
		}
	}
}

return Tree
