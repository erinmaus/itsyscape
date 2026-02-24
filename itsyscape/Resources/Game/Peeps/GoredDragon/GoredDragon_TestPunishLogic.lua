--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GoredDragon/GoredDragon_TestDragonfyreLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Vector = require "ItsyScape.Common.Math.Vector"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Mashina = require "ItsyScape.Mashina"

local PLAYER = B.Reference("GoredDragon_TestPunishLogic", "PLAYER")

local GetPlayer = Mashina.Peep.GetPlayer {
	[PLAYER] = B.Output.player
}

local Punished = Mashina.Step {
	Mashina.Peep.IsAlive,

	Mashina.Player.Disable,

	Mashina.Peep.Flash {
		sprite = "Punish",
		arguments = { "Archery" }
	},

	Mashina.Peep.PlayAnimation {
		animation = "Dragon_Stunned",
		slot = "x-gored-dragon-stunned",
		priority = 10000
	},

	Mashina.Peep.TimeOut {
		duration = 0.25,
	},

	Mashina.Peep.FireProjectile {
		projectile = "Power_Decapitate",
		source = PLAYER,
	},

	Mashina.Peep.SwapResource {
		type = "Peep",
		name = "GoredDragon_Stunned"
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.DisengageCombatTarget,

				Mashina.Peep.Interrupt {
					everything = true,
				}
			}
		},

		Mashina.Step {
			Mashina.Peep.TimeOut {
				min_duration = 8,
				max_duration = 8
			},
		}
	},

	Mashina.Peep.SwapResource {
		type = "Peep",
		name = "GoredDragon"
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
			x_weapon = "Dragon_GoreVomit",
		},

		GetPlayer,
		Punished
	}
}

return Tree
