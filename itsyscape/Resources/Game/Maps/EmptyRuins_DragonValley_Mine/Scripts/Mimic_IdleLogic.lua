--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_DragonValley_Mine/Mimic_IdleLogic.lua
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

local TARGET = B.Reference("Mimic_IdleLogic", "TARGET")
local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = 16,
					same_layer = false,
					[TARGET] = B.Output.RESULT
				},

				Mashina.Peep.Interrupt,

				Mashina.Peep.EngageCombatTarget {
					peep = TARGET,
				},

				Mashina.Peep.SetState {
					state = 'attack'
				}
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Navigation.Wander {
					radial_distance = 6
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
