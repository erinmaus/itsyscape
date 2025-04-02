--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_GeneralAttackLogic.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local CommonLogic = require "Resources.Game.Maps.Sailing_HumanityEdge.Scripts.Tutorial_CommonLogic"

local TARGET = B.Reference("Tutorial_Orlando_GeneralAttackLogic", "TARGET")

local DidKillTarget = Mashina.Sequence {
	Mashina.Invert {
		Mashina.Peep.HasCombatTarget,
	},

	Mashina.Peep.SetState {
		state = "tutorial-follow-player"
	}
}

local HandleOffense = Mashina.Step {
	Mashina.Peep.DidAttack,

	Mashina.RandomTry {
		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Tornado"
			},

			Mashina.Peep.QueuePower {
				power = "Tornado",
				turns = 1
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Decapitate"
			},

			Mashina.Peep.QueuePower {
				power = "Decapitate",
				turns = 1
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Earthquake"
			},

			Mashina.Peep.QueuePower {
				power = "Earthquake",
				turns = 1
			}
		}
	},

	Mashina.Peep.DidAttack
}

local HandleDefense = Mashina.Step {
	Mashina.Peep.WasAttacked,

	Mashina.Try {
		CommonLogic.Heal,

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Riposte"
			},

			Mashina.RandomCheck {
				chance = 0.25
			},

			Mashina.Peep.QueuePower {
				power = "Riposte",
				turns = 1
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Parry"
			},

			Mashina.RandomCheck {
				chance = 0.25
			},

			Mashina.Peep.QueuePower {
				power = "Parry",
				turns = 1
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Deflect"
			},
 
			Mashina.RandomCheck {
				chance = 0.25
			},

			Mashina.Peep.QueuePower {
				power = "Deflect",
				turns = 1
			}
		}
	},

	Mashina.Peep.WasAttacked
}

local AttackOrDefend = Mashina.ParallelTry {
	DidKillTarget,
	HandleDefense,
	HandleOffense
}

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.SetStance {
			stance = Weapon.STANCE_CONTROLLED
		},

		Mashina.Repeat {
			Mashina.Success {
				AttackOrDefend
			}
		}
	}
}

return Tree
