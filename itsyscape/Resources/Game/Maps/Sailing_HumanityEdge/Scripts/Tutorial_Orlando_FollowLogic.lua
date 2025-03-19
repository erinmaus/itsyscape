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

local Tree = BTreeBuilder().Node() {
	Mashina.Repeat {
		Mashina.Peep.GetPlayer {
			[PLAYER] = B.Output.player
		},

		Mashina.Try {
			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Player.IsNextQuestStep {
						player = PLAYER,
						quest = "Tutorial",
						step = "Tutorial_EquippedItems"
					}
				}

				Mashina.Peep.SetState {
					state = false
				}
			},

			Mashina.Peep.FaceAway {
				target = PLAYER
			}
		}
	}
}

return Tree
