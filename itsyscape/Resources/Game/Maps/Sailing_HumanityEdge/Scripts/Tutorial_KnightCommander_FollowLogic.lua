--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_KnightCommander_FollowLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Utility = require "ItsyScape.Game.Utility"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local PLAYER = B.Reference("Tutorial_KnightCommander_FollowLogic", "PLAYER")
local ORLANDO = B.Reference("Tutorial_KnightCommander_FollowLogic", "ORLANDO")
local PLAYER_TARGET = B.Reference("Tutorial_KnightCommander_FollowLogic", "PLAYER_TARGET")

local FollowOrlando = Mashina.Success {
	Mashina.Sequence {
		Mashina.Invert {
			Mashina.Navigation.TargetMoved {
				peep = ORLANDO
			}
		},

		Mashina.Step {
			Mashina.Navigation.WalkToPeep {
				peep = ORLANDO,
				distance = 2.5,
				as_close_as_possible = false
			},

			Mashina.Repeat {
				Mashina.Peep.Wait
			}
		}
	}
}

local IsAttacking = Mashina.Sequence {
	Mashina.ParallelTry {
		Mashina.Peep.DidAttack,
		Mashina.Peep.WasAttacked,
		Mashina.Peep.HasCombatTarget
	},

	Mashina.Peep.SetState {
		state = "tutorial-general-attack"
	}
}

local IsPlayerAttacking = Mashina.Sequence {
	Mashina.Peep.DidAttack {
		peep = PLAYER,
		[PLAYER_TARGET] = B.Output.target
	},

	Mashina.Peep.EngageCombatTarget {
		peep = PLAYER_TARGET
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Peep.FindNearbyPeep {
			filter = function(peep, _, state)
				local isInInstance = Probe.instance(Utility.Peep.getPlayerModel(state[PLAYER]))(peep)
				local isOrlando = Probe.namedMapObject("Orlando")(peep)

				return isOrlando and isInInstance
			end,

			[ORLANDO] = B.Output.result
		},

		Mashina.ParallelTry {
			IsAttacking,
			IsPlayerAttacking,
			FollowOrlando
		}		
	}
}

return Tree
