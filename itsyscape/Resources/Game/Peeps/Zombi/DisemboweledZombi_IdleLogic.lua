--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Zombi/DisemboweledZombi_IdleLogic.lua
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

local TARGET = B.Reference("DisemboweledZombi_IdleLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = 4,
					line_of_sight = true,
					[TARGET] = B.Output.RESULT
				},

				Mashina.Peep.Interrupt,

				Mashina.Peep.EngageCombatTarget {
					peep = TARGET,
				}
			}
		},

		Mashina.Repeat {
			Mashina.Check {
				condition = function(_, state)
					return state[TARGET] == nil
				end
			},

			Mashina.Step {
				Mashina.Navigation.Wander {
					radial_distance = 2
				},

				Mashina.Peep.Wait,

				Mashina.Peep.TimeOut {
					min_duration = 4,
					max_duration = 5
				}
			}
		}
	}
}

return Tree
