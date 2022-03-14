--------------------------------------------------------------------------------
-- Resources/Game/Peeps/MagmaSnail/MagmaSnail_IdleLogic.lua
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
local MagmaSnail = require "Resources.Game.Peeps.MagmaSnail.MagmaSnail"

local TARGET = B.Reference("MagmaSnail_IdleLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.ParallelTry {
		Mashina.Sequence {
			Mashina.Peep.FindNearbyCombatTarget {
				filter = MagmaSnail.probeForIronItem,
				distance = 4,
				[TARGET] = B.Output.RESULT
			},

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET,
			},

			Mashina.Peep.SetState {
				state = 'attack'
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Navigation.Wander,

				Mashina.Peep.Wait,

				Mashina.Peep.TimeOut {
					min_duration = 1,
					max_duration = 2
				}
			}
		}
	},
}

return Tree
