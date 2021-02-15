--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GhostlyMinerForeman/GhostlyMinerForeman_IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local AGGRESSOR = B.Reference("GhostlyMinerForeman", "AGGRESSOR")
local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "WHO DARES DISTURB ME?" 
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.Sequence {
					Mashina.Peep.WasAttacked {
						took_damage = false,
						[AGGRESSOR] = B.Output.aggressor
					},

					Mashina.RandomCheck {
						chance = 1 / 2
					},

					Mashina.Peep.EngageCombatTarget {
						peep = AGGRESSOR
					},

					Mashina.Peep.Talk {
						message = "Maggot!"
					}
				}
			}
		}
	}
}

return Tree
