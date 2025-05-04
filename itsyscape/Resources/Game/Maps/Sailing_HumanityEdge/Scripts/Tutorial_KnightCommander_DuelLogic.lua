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
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local Referee = Mashina.Repeat {
	CommonLogic.GetOrlando,

	Mashina.ParallelTry {
		Mashina.Step {
			Mashina.Peep.DidAttack {
				peep = CommonLogic.PLAYER
			},

			Mashina.Navigation.Face {
				target = CommonLogic.PLAYER
			}
		},

		Mashina.Step {
			Mashina.Peep.DidAttack {
				peep = CommonLogic.ORLANDO
			},

			Mashina.Navigation.Face {
				target = CommonLogic.ORLANDO
			}
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Referee
}

return Tree
