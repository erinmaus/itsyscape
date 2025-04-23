--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua
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
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local QueueLightningStrike = Mashina.Step {
	Mashina.Peep.CanQueuePower {
		power = "Keelhauler_LightningStrike"
	},

	Mashina.Peep.QueuePower {
		power = "Keelhauler_LightningStrike",
		turns = 1
	}
}

local QueueLaser = Mashina.Step {
	Mashina.Peep.CanQueuePower {
		power = "Keelhauler_Laser"
	},

	Mashina.Peep.QueuePower {
		power = "Keelhauler_Laser",
		turns = 1
	}
}

local DeflectLaser = Mashina.Step {
	Mashina.Peep.OnPoke {
		event = "powerDeflected",
	},

	CommonLogic.GetOrlando,

	Mashina.Player.Disable {
		player = CommonLogic.PLAYER
	},

	Mashina.Player.Dialog {
		peep = CommonLogic.ORLANDO,
		player = CommonLogic.PLAYER,
		main = "quest_tutorial_fight_keelhauler.deflected_both_attacks"
	},

	Mashina.Player.Enable {
		player = CommonLogic.PLAYER
	}
}

local DeflectLightningStrike = Mashina.Step {
	Mashina.Peep.OnPoke {
		event = "powerDeflected"
	},

	QueueLaser,

	Mashina.ParallelTry {
		DeflectLaser,

		Mashina.Peep.OnPoke {
			event = "powerActivated"
		}
	}
}

local Attack = Mashina.Step {
	Mashina.Peep.HasZeal {
		zeal = 0.5,
	},

	QueueLightningStrike,

	Mashina.ParallelTry {
		DeflectLightningStrike,

		Mashina.Peep.OnPoke {
			event = "powerActivated"
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Repeat {
			Mashina.Success {
				Attack
			}
		}
	}
}

return Tree
