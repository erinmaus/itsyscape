--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Svalbard/SpecialLogic.lua
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

local ATTACK_MAX_WAIT = 5

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.PokeSelf {
			event = "equipRandomSpecialWeapon"
		},

		Mashina.Repeat {
			Mashina.Invert {
				Mashina.ParallelTry {
					Mashina.Peep.DidAttack,
					Mashina.Peep.TimeOut {
						duration = ATTACK_MAX_WAIT
					}
				}
			}
		},

		Mashina.Peep.TimeOut {
			duration = 2
		},

		Mashina.Peep.PokeSelf {
			event = "equipRandomWeapon"
		},

		Mashina.Peep.SetState {
			state = "attack"
		}
	}
}

return Tree
