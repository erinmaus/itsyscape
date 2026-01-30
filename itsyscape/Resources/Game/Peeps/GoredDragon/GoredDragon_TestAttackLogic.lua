--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GoredDragon/GoredDragon_TestAttackLogic.lua
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

local Punished = Mashina.Step {
	Mashina.Peep.OnPoke {
		event = "punished"
	},

	Mashina.Player.Disable,

	Mashina.Peep.PlayAnimation {
		animation = "Dragon_Stunned",
		slot = "x-gored-dragon-stunned",
		priority = 10000
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.Interrupt {
					everything = true,
				},

				Mashina.Peep.DisengageCombatTarget
			}
		},

		Mashina.Peep.TimeOut {
			min_duration = 6,
			max_duration = 8
		},
	},

	Mashina.Player.Enable,

	Mashina.Peep.StopAnimation {
		slot = "x-gored-dragon-stunned"
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Peep.EquipXWeapon {
			x_weapon = "Dragon_ChargedDragonfyre",
		},

		Mashina.Repeat {
			Mashina.Success {
				Punished
			}
		}
	}
}

return Tree
