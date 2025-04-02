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

local HandleDefense = Mashina.RandomTry {
	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Riposte"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Riposte",
			turns = 2
		}
	},

	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Parry"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Parry",
			turns = 2
		}
	},

	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Deflect"
		},

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Deflect",
			turns = 2
		}
	}
}

local HandleOffense = Mashina.RandomTry {
	Mashina.Sequence {
		Mashina.Peep.CanQueuePower {
			power = "Tornado"
		},

		Mashina.RandomCheck {
			chance = 0.5
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

		Mashina.RandomCheck {
			chance = 0.5
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

		Mashina.RandomCheck {
			chance = 0.5
		},

		Mashina.Peep.QueuePower {
			power = "Earthquake",
			turns = 1
		}
	}
}

local HandlePowers = Mashina.Step {
	Mashina.Peep.DidAttack,

	Mashina.ParallelTry {
		Mashina.Sequence {
			Mashina.Peep.OnPoke {
				event = "heal"
			},

			HandleDefense
		},

		HandleOffense
	},

	Mashina.Peep.OnPoke {
		event = "powerActivated"
	}
}

local HandleHealing = Mashina.Step {
	Mashina.Peep.WasAttacked,
	CommonLogic.Heal
}

local AttackOrDefend = Mashina.ParallelTry {
	DidKillTarget,
	HandlePowers,
	Mashina.Failure {
		HandleHealing
	}
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
