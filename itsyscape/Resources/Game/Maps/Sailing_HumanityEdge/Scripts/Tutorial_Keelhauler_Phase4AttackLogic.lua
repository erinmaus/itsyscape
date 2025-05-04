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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
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

local DeflectLaser = Mashina.Step {
	Mashina.Invert {
		Mashina.Peep.DidUsePower {
			power = "Keelhauler_Laser"
		}
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
	Mashina.Invert {
		Mashina.Peep.DidUsePower {
			power = "Keelhauler_LightningStrike"
		}
	},

	QueueLaser,

	Mashina.ParallelTry {
		DeflectLaser,

		Mashina.Peep.DidUsePower {
			power = "Keelhauler_Laser"
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

local AdvancePhase = Mashina.Success {
	Mashina.Step {
		Mashina.Check {
			condition = function(mashina)
				local status = mashina:getBehavior(CombatStatusBehavior)
				local targetHitpoints = status and math.floor(status.maximumHitpoints * (1 / 3) + 0.5)

				return status and status.currentHitpoints < targetHitpoints
			end
		},

		Mashina.Try {
			Mashina.Step {
				CommonAttackLogic.SwitchToOrlando,
				CommonAttackLogic.SwitchToStrongStyle,
				Mashina.Peep.DidAttack,

				CommonAttackLogic.BeginCharge,

				CommonLogic.GetOrlando,
				Mashina.Player.Disable {
					player = CommonLogic.PLAYER,
				},

				Mashina.Sequence {
					Mashina.Success {
						Mashina.Peep.DisengageCombatTarget,
					},

					Mashina.Player.Dialog {
						peep = CommonLogic.ORLANDO,
						player = CommonLogic.PLAYER,
						main = "quest_tutorial_fight_keelhauler.dodge_charge"
					}
				},

				Mashina.Player.Enable {
					player = CommonLogic.PLAYER,
				},

				CommonAttackLogic.Charge,
				CommonAttackLogic.EndCharge
			},

			CommonAttackLogic.EndCharge
		},

		Mashina.Peep.SetState {
			state = "attack-phase-5"
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		AdvancePhase,

		Mashina.Repeat {
			Mashina.Success {
				Mashina.ParallelSequence {
					AdvancePhase,
					CommonAttackLogic.SwitchToWeakStyle,
					CommonAttackLogic.SwitchTargets,
					Mashina.Success {
						Attack
					}
				}
			}
		}
	}
}

return Tree
