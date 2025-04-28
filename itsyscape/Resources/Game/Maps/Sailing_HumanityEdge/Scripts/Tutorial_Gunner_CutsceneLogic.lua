--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_CutsceneLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Class = require "ItsyScape.Common.Class"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"
local ICannon = require "ItsyScape.Game.Skills.ICannon"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local TARGET = B.Reference("Tutorial_Gunner_CutsceneLogic", "TARGET")
local CANNON = B.Reference("Tutorial_Gunner_CutsceneLogic", "CANNON")

local Intro = Mashina.Step {
	CommonLogic.GetPlayer,

	Mashina.Peep.FindNearbyPeep {
		filter = function(p)
			return Class.hasInterface(p, ICannon)
		end,

		[CANNON] = B.Output.result
	},

	Mashina.Success {
		Mashina.Sailing.AimCannon {
			target = CommonLogic.PLAYER,
			cannon = CANNON
		},
	}

	Mashina.Repeat {
		Mashina.Success {
			Mashina.Sailing.AimCannon {
				target = TARGET,
				cannon = CANNON,
				steady = true
			}
		},

		Mashina.Invert {
			Mashina.Peep.TimeOut {
				duration = 2
			}
		}
	},

	Mashina.Peep.FireCannon {
		cannon = CANNON
	},

	Mashina.Peep.TimeOut {
		duration = 1,
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Intro
		},

		Mashina.Peep.SetState {
			state = "gun-yendorians"
		}
	}
}

return Tree
