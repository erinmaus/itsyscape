--------------------------------------------------------------------------------
-- Resources/Game/Peeps/RatKing/RatKing_HungryLogic.lua
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
local Probe = require "ItsyScape.Peep.Probe"

local TARGET = B.Reference("RatKing_HungryLogic", "TARGET")
local ATTACK_POKE = B.Reference("RatKing_HungryLogic", "ATTACK_POKE")
local ATTACK_POKE_DAMAGE = B.Reference("RatKing_HungryLogic", "ATTACK_POKE_DAMAGE")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Success {
			Mashina.Step {
				Mashina.Peep.FindNearbyCombatTarget {
					filter = Probe.resource("Peep", "HighChambersYendor_Rat"),
					include_npcs = true,
					[TARGET] = B.Output.result
				},

				Mashina.Navigation.WalkToPeep {
					peep = TARGET
				},

				Mashina.Peep.Wait,

				Mashina.Peep.Talk {
					message = "Yum!"
				},

				Mashina.Peep.PokeSelf {
					event = "eat",
					poke = function(_, state)
						return {
							target = state[TARGET]
						}
					end
				},

				Mashina.Peep.TimeOut {
					min_duration = 1,
					max_duration = 1.5
				}
			}
		},

		Mashina.Peep.FindNearbyCombatTarget {
			[TARGET] = B.Output.result
		},

		Mashina.Peep.EngageCombatTarget {
			peep = TARGET
		},

		Mashina.Peep.SetState {
			state = "attack"
		}
	}
}

return Tree
