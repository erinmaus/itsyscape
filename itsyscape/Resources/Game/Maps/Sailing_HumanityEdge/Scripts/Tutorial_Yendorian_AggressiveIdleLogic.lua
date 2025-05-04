--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AggressiveIdleLogic.lua
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

local TARGET = B.Reference("Tutorial_YendorianScout_IdleLogic", "TARGET")

local Engage = Mashina.Sequence {
	Mashina.Peep.FindNearbyCombatTarget {
		distance = 8,
		[TARGET] = B.Output.result
	},

	Mashina.Peep.EngageCombatTarget {
		peep = TARGET
	},

	Mashina.Peep.SetState {
		state = "attack"
	}
}

local Wander = Mashina.Step {
	Mashina.Navigation.Wander {
		radial_distance = 2
	},

	Mashina.Peep.Wait,

	Mashina.Peep.TimeOut {
		min_duration = 2,
		max_duration = 4
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Mashina.ParallelTry {
				Engage,
				Wander
			}
		}
	}
}

return Tree
