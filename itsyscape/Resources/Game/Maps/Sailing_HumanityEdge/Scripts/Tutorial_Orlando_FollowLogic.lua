--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FollowLogic.lua
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

local PLAYER = B.Reference("Tutorial_Orlando_FollowLogic", "PLAYER")
local PLAYER_TARGET = B.Reference("Tutorial_Orlando_FollowLogic", "PLAYER_TARGET")

local FollowPlayer = Mashina.Success {
	Mashina.Sequence {
		Mashina.Invert {
			Mashina.Navigation.TargetMoved {
				peep = PLAYER
			}
		},

		Mashina.Step {
			Mashina.Navigation.WalkToPeep {
				peep = PLAYER,
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

		Mashina.ParallelTry {
			IsAttacking,
			IsPlayerAttacking,
			FollowPlayer
		}		
	}
}

return Tree
