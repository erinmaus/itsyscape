--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AttackLogic.lua
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
	Mashina.Peep.HasZeal {
		zeal = 0.5,
	},

	Mashina.RandomTry {
		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MAGIC
			},

			Mashina.Peep.CanQueuePower {
				power = "BindShadow"
			},

			Mashina.Peep.QueuePower {
				turns = 1,
				power = "BindShadow"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_ARCHERY
			},

			Mashina.Peep.CanQueuePower {
				power = "Snipe"
			},

			Mashina.Peep.QueuePower {
				turns = 1,
				power = "Snipe"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatStyle {
				style = Weapon.STYLE_MELEE
			},

			Mashina.Peep.CanQueuePower {
				power = "Backstab"
			},

			Mashina.Peep.QueuePower {
				turns = 1,
				power = "Backstab"
			}
		}
	},

	Mashina.Peep.DidUsePower
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			UseRite
		}
	}
}

return Tree
