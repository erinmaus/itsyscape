--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GoredDragon/GoredDragon_TestDisengageLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local Disengage = Mashina.Sequence {
	Mashina.Peep.EquipXWeapon {
		x_weapon = "Dragon_GoreVomit",
	},

	Mashina.Peep.StopAnimation {
		slot = "x-gored-dragon-stunned"
	},

	Mashina.Peep.DisengageCombatTarget,

	Mashina.Peep.Interrupt {
		everything = true,
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Disengage
		}
	}
}

return Tree
