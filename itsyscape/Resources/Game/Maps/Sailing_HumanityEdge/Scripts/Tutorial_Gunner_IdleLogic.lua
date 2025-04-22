--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_IdleLogic.lua
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

local TARGET = B.Reference("Tutorial_Gunner_IdleLogic", "TARGET")
local CANNON = B.Reference("Tutorial_Gunner_IdleLogic", "CANNON")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Mashina.Step {
				Mashina.Peep.FindNearbyCombatTarget {
					include_npcs = false,
					same_layer = false,
					distance = math.huge,
					[TARGET] = B.Output.result
				},

				-- Mashina.Peep.Talk {
				-- 	message = "got target"
				-- },

				Mashina.Peep.FindNearbyPeep {
					filter = function(p)
						return Class.hasInterface(p, ICannon)
					end,

					[CANNON] = B.Output.result
				},

				-- Mashina.Peep.Talk {
				-- 	message = "got cannon"
				-- },

				Mashina.Sailing.FireCannon {
					target = TARGET,
					cannon = CANNON
				},

				Mashina.Peep.TimeOut {
					min_duration = 10,
					max_duration = 15
				}
			}
		}
	}
}

return Tree
