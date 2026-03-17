--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GoredDragon/GoredDragon_TestEatPlayerLogic.lua
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

local PLAYER = B.Reference("GoredDragon_TestEatPlayerLogic", "PLAYER")

local GetPlayer = Mashina.Peep.GetPlayer {
	[PLAYER] = B.Output.player
}

local EatPlayer = Mashina.Step {
	GetPlayer,

	Mashina.Success {
		Mashina.Peep.Interrupt {
			peep = PLAYER,
			everything = true
		}
	},

	Mashina.Player.Disable {
		player = PLAYER
	},

	Mashina.Peep.FireProjectile {
		destination = PLAYER,
		projectile = "DragonEat"
	},

	Mashina.Peep.TimeOut {
		duration = 2,
	},

	Mashina.Player.Enable {
		player = PLAYER
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Success {
			Mashina.Peep.DisengageCombatTarget,
		},

		EatPlayer
	}
}

return Tree
