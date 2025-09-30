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
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local PLAYER = B.Reference("Tutorial_KnightCommander_FollowLogic", "PLAYER")
local ORLANDO = B.Reference("Tutorial_KnightCommander_FollowLogic", "ORLANDO")
local PLAYER_TARGET = B.Reference("Tutorial_KnightCommander_FollowLogic", "PLAYER_TARGET")

local FollowOrlando = Mashina.Success {
	Mashina.Sequence {
		Mashina.Invert {
			Mashina.Navigation.TargetMoved {
				peep = CommonLogic.ORLANDO
			}
		},

		Mashina.Step {
			Mashina.Navigation.WalkToPeep {
				peep = CommonLogic.ORLANDO,
				distance = 2.5,
				as_close_as_possible = false
			},

			Mashina.Peep.Wait,

			Mashina.Repeat {
				Mashina.Success {
					CommonLogic.AvoidCrowding
				}
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[CommonLogic.PLAYER] = B.Output.player
		},

		CommonLogic.GetOrlando,

		Mashina.ParallelTry {
			CommonLogic.IsAttacking,
			CommonLogic.AttackPlayerTarget,
			FollowOrlando
		}		
	}
}

return Tree
