--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

local TARGET = B.Reference("Tutorial_Pirate_IdleLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.ParallelTry {
		Mashina.Step {
			Mashina.Peep.FindNearbyCombatTarget {
				include_npcs = true,

				filter = function(peep)
					return not (peep:hasBehavior(PlayerBehavior) or peep:hasBehavior(FollowerBehavior))
				end,

				[TARGET] = B.Output.result
			},

			Mashina.Peep.TimeOut {
				min_duration = 0.5,
				max_duration = 1.5
			},

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET
			},

			Mashina.Peep.SetState {
				state = "attack"
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Navigation.Wander,
				Mashina.Peep.Wait
			}
		}
	}
}

return Tree
