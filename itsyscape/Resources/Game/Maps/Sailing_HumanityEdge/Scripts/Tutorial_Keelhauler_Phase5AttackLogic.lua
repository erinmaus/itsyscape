--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Keelhauler_Phase3AttackLogic.lua
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
local CommonAttackLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_Keelhauler_CommonAttackLogic"

local QueueLightningStrike = Mashina.Sequence {
	Mashina.Peep.CanQueuePower {
		power = "Keelhauler_LightningStrike"
	},

	Mashina.Peep.QueuePower {
		power = "Keelhauler_LightningStrike",
		turns = 1
	}
}

local QueueLaser = Mashina.Sequence {
	Mashina.Peep.CanQueuePower {
		power = "Keelhauler_Laser"
	},

	Mashina.Peep.QueuePower {
		power = "Keelhauler_Laser",
		turns = 1
	}
}

local DeflectLightningStrike = Mashina.Step {
	Mashina.Invert {
		Mashina.Peep.DidUsePower {
			power = "Keelhauler_LightningStrike"
		}
	},

	QueueLaser,

	Mashina.Repeat {
		Mashina.Peep.DidAttack,

		Mashina.Invert {
			Mashina.Peep.HasQueuedPower
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

		Mashina.Peep.DidUsePower {
			power = "Keelhauler_LightningStrike"
		},

		Mashina.Peep.DidUsePower {
			power = "Keelhauler_Laser"
		}
	}
}

local Dash = Mashina.Sequence {
	Mashina.Step {
		Mashina.Peep.DidAttack,
		Mashina.Peep.DidAttack,

		Mashina.Invert {
			Mashina.RandomCheck {
				chance = 0.5
			}
		},

		Mashina.Try {
			Mashina.Step {
				CommonAttackLogic.BeginCharge,
				CommonAttackLogic.Charge,
				CommonAttackLogic.EndCharge
			},

			CommonAttackLogic.EndCharge
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_AGGRESSIVE
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.ParallelSequence {
					CommonAttackLogic.SwitchToStrongStyle,
					CommonAttackLogic.SwitchTargets,
					Mashina.Success {
						Mashina.ParallelTry {
							Attack,
							Dash
						}
					}
				}
			}
		}
	}
}

return Tree
