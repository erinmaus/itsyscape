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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local TARGET = B.Reference("Tutorial_Orlando_GeneralAttackLogic", "TARGET")

local HEAL_HITPOINTS = 20

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
				power = "Tornado"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Decapitate"
			},

			Mashina.Peep.QueuePower {
				power = "Decapitate"
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Earthquake"
			},

			Mashina.Peep.QueuePower {
				power = "Earthquake"
			}
		}
	},

	Mashina.Peep.DidAttack
}

local HandleDefense = Mashina.Step {
	Mashina.Peep.WasAttacked,

	Mashina.Try {
		Mashina.Sequence {
			Mashina.Check {
				condition = function(mashina)
					local status = mashina:getBehavior(CombatStatusBehavior)
					if not status then
						return false
					end

					local hitpoints = status.currentHitpoints
					local maximumHitpoints = status.maximumHitpoints
					local thresholdHitpoints = math.max(maximumHitpoints - HEAL_HITPOINTS, math.ceil(maximumHitpoints / 2))

					return hitpoints < thresholdHitpoints
				end
			},

			Mashina.Peep.PlayAnimation {
				animation = "Human_ActionEat_1",
				priority = 1001
			},

			Mashina.Peep.Heal {
				hitpoints = HEAL_HITPOINTS
			}
		},

		Mashina.Sequence {
			Mashina.Peep.CanQueuePower {
				power = "Riposte"
			},

			Mashina.RandomCheck {
				chance = 0.25
			},

			Mashina.Peep.QueuePower {
				power = "Riposte"
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
				power = "Parry"
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
				power = "Deflect"
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
