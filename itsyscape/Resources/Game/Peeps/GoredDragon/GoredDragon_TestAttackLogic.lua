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

local PLAYER = B.Reference("GoredDragon_TestDragonfyreLogic", "PLAYER")

local GetPlayer = Mashina.Peep.GetPlayer {
	[PLAYER] = B.Output.player
}

local AttackPlayer = Mashina.Sequence {
	GetPlayer,

	Mashina.Peep.EngageCombatTarget {
		peep = PLAYER
	}
}

local PrepareForCombat = Mashina.Sequence {
	Mashina.Peep.SetStance {
		stance = Weapon.STANCE_CONTROLLED
	},

	Mashina.Peep.EquipXWeapon {
		x_weapon = "Dragon_GoreVomit",
	},
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		AttackPlayer,

		Mashina.Repeat {
			Mashina.Success {
				PrepareForCombat
			}
		}
	}
}

return Tree
