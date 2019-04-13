--------------------------------------------------------------------------------
-- Resources/Game/Peeps/RatKing/RatKing_AttackLogic.lua
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

local HITS = B.Reference("RatKing_AttackLogic", "HITS")
local ATTACK_POKE = B.Reference("RatKing_AttackLogic", "ATTACK_POKE")
local ATTACK_POKE_DAMAGE = B.Reference("RatKing_AttackLogic", "ATTACK_POKE_DAMAGE")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "Squeak!"
		},

		Mashina.Set {
			value = 0,
			[HITS] = B.Output.result
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.Step {
					Mashina.Peep.WasAttacked {
						[ATTACK_POKE] = B.Output.attack_poke
					},

					Mashina.Compute {
						input = ATTACK_POKE,
						func = function(poke)
							return poke:getDamage()
						end,
						[ATTACK_POKE_DAMAGE] = B.Output.output
					},

					Mashina.Add {
						left = ATTACK_POKE_DAMAGE,
						right = HITS,
						[HITS] = B.Output.result
					},

					Mashina.Compare.GreaterThanEqual {
						left = HITS,
						right = 10
					},

					Mashina.Peep.SetState {
						state = "hungry"
					}
				}
			}
		}
	}
}

return Tree
