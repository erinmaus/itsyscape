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
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local FollowPlayer = Mashina.Success {
	Mashina.Sequence {
		Mashina.Invert {
			Mashina.Navigation.TargetMoved {
				peep = CommonLogic.PLAYER
			}
		},

		Mashina.Step {
			Mashina.Navigation.WalkToPeep {
				peep = CommonLogic.PLAYER,
				distance = 2.5,
				as_close_as_possible = false
			},

			Mashina.Repeat {
				Mashina.Peep.Wait
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[CommonLogic.PLAYER] = B.Output.player
		},

		Mashina.ParallelTry {
			CommonLogic.IsAttacking,
			CommonLogic.AttackPlayerTarget,
			FollowPlayer
		}		
	}
}

return Tree
