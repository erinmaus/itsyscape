--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_KnightCommander_WaitLogic.lua
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
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"

local PLAYER = B.Reference("Tutorial_KnightCommander_WaitLogic", "PLAYER")

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

local YellAtNearbyPlayer = Mashina.Step {
	Mashina.Peep.FindNearbyPeep {
		distance = 8,

		filter = function(p, mashina)
			local player = p:getBehavior(PlayerBehavior)
			local instance = mashina:getBehavior(InstancedBehavior)
			return player and instance and player.playerID == instance.playerID
		end
	},

	Mashina.Peep.Talk {
		message = "Oi, you two! Get over here!",
		log = false
	},

	Mashina.Peep.TimeOut {
		duration = 10
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Mashina.ParallelTry {
				StandGuardAndLookStupid,
				YellAtNearbyPlayer
			}
		}
	}
}

return Tree
