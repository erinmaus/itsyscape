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
local Vector = require "ItsyScape.Common.Math.Vector"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Mashina = require "ItsyScape.Mashina"

local COMBAT_TARGET = B.Reference("GoredDragon_TestAttackLogic", "COMBAT_TARGET")

local Punished = Mashina.Step {
	Mashina.Peep.OnPoke {
		event = "punished"
	},

	Mashina.Peep.IsAlive,

	Mashina.Player.Disable,

	Mashina.Peep.PlayAnimation {
		animation = "Dragon_Stunned",
		slot = "x-gored-dragon-stunned",
		priority = 10000
	},

	Mashina.Peep.SwapResource {
		type = "Peep",
		name = "GoredDragon_Stunned"
	},

	Mashina.Sequence {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Peep.DisengageCombatTarget {
					[COMBAT_TARGET] = B.Output.current_target
				},

				Mashina.Peep.Interrupt {
					everything = true,
				}
			}
		},

		Mashina.Peep.TimeOut {
			min_duration = 16,
			max_duration = 20
		},
	},

	Mashina.Function {
		func = function(mashina, state)
			local position = Utility.Peep.getPosition(mashina)
			local fireball = Utility.spawnPropAtPosition(mashina, "DragonFireball", position:get())
			if not fireball then
				return
			end

			fireball:getPeep():pushPoke("shoot", {
				dragon = mashina,
				peep = state[COMBAT_TARGET],
				weapon = Utility.Peep.getXWeapon(mashina:getDirector():getGameInstance(), "Dragon_ChargedDragonfyreHit"),
				position = Vector(0, -1, 0)
			})
		end
	},

	Mashina.Peep.SwapResource {
		type = "Peep",
		name = "GoredDragon"
	},

	Mashina.Player.Enable,

	Mashina.Peep.StopAnimation {
		slot = "x-gored-dragon-stunned"
	},

	Mashina.Success {
		Mashina.Peep.EngageCombatTarget {
			peep = COMBAT_TARGET
		}
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
