--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FishLogic.lua
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

local NextQuestStep = Mashina.Sequence {
	Mashina.Peep.GetPlayer {
		[PLAYER] = B.Output.player
	},

	Mashina.Player.IsNextQuestStep {
		quest = "Tutorial",
		step = "Tutorial_FoundYendorianSquad",
		player = PLAYER
	},

	Mashina.Peep.SetState {
		state = "tutorial-follow-player"
	}
}

local StandGuardAndLookStupid = Mashina.Sequence {
	Mashina.Repeat {
		Mashina.Step {
			Mashina.Navigation.Face {
				direction = 1
			},

			Mashina.Peep.TimeOut {
				duration = 4,
			},

			Mashina.Navigation.Face {
				direction = -1
			},

			Mashina.Peep.TimeOut {
				duration = 4
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Navigation.WalkToAnchor {
			anchor = "Anchor_KnightCommander_StandGuard_Fish"
		},

		Mashina.Peep.Wait,

		Mashina.Try {
			NextQuestStep,
			StandGuardAndLookStupid
		}
	}
}

return Tree
