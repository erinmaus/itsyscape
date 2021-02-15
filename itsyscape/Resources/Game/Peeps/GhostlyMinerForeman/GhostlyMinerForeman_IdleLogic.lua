--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GhostlyMinerForeman/GhostlyMinerForeman_IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local TARGET = B.Reference("GhostlyMinerForeman", "TARGET")
local Tree = BTreeBuilder.Node() {
	Mashina.Try {
		Mashina.Sequence {
			Mashina.Peep.FindNearbyCombatTarget {
				distance = 4,
				[TARGET] = B.Output.RESULT
			},

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET,
			},

			Mashina.Peep.PokeSelf {
				event = "boss"
			},

			Mashina.Peep.SetState {
				state = 'attack'
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Navigation.Wander {
					radial_distance = 2
				},

				Mashina.Peep.Wait,

				Mashina.Peep.TimeOut {
					min_duration = 2,
					max_duration = 3
				}
			}
		}
	}
}

return Tree
