--------------------------------------------------------------------------------
-- Resources/Game/Peeps/RatKing/RatKing_IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local ChambersCommon = require "Resources.Game.Peeps.HighChambersYendor.Common"

local TARGET = B.Reference("RatKing_Idle", "TARGET")
local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Sequence {
			Mashina.Peep.FindNearbyCombatTarget {
				filter = ChambersCommon.targetPlayer,
				distance = 3,
				[TARGET] = B.Output.RESULT
			},

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET,
			},

			Mashina.Peep.PokeSelf {
				event = "boss"
			},

			Mashina.Peep.SetState {
				state = 'attack'
			}
		}
	}
}

return Tree
