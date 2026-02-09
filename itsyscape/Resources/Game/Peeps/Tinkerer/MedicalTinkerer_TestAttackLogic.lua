--------------------------------------------------------------------------------
-- Resources/Game/Peeps/MedicalTinkerer/MedicalTinkerer_TestFlyLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"

local UseRite = Mashina.Step {
	Mashina.Peep.CanQueuePower {
		power = "Decapitate"
	},

	Mashina.Peep.QueuePower {
		power = "Decapitate"
	},

	Mashina.Success {
		Mashina.Peep.DidUsePower
	},

	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack,
	Mashina.Peep.DidAttack
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Step {
			Mashina.Try {
				Mashina.Peep.IsFlying,
				Mashina.Peep.Fly
			},

			Mashina.Success {
				Mashina.Peep.ApplyEffect {
					singular = true,
					effect = "Favored"
				}
			},

			Mashina.Repeat {
				Mashina.Success {
					UseRite
				}
			}
		}
	}
}

return Tree
