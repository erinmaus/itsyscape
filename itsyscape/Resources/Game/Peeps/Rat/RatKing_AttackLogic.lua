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

local TARGET_ATTACKS = B.Reference("RatKing_AttackLogic", "TARGET_ATTACKS")
local CURRENT_ATTACKS = B.Reference("RatKing_AttackLogic", "CURRENT_ATTACKS")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "Squeak!"
		},

		Mashina.Set {
			value = 0,
			[CURRENT_ATTACKS] = B.Output.result
		},

		Mashina.Random {
			min = 5,
			max = 7,
			[TARGET_ATTACKS] = B.Output.result
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.Step {
					Mashina.Peep.DidAttack,

					Mashina.Add {
						left = CURRENT_ATTACKS,
						right = 1,
						[CURRENT_ATTACKS] = B.Output.result
					},

					Mashina.Compare.GreaterThanEqual {
						left = CURRENT_ATTACKS,
						right = TARGET_ATTACKS
					},

					Mashina.Peep.Talk {
						message = "Hungry...! I must feast!"
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
