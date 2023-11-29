--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Knight_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local Effect = require "ItsyScape.Peep.Effect"

local PREVIOUS_HEALTH = B.Reference("Knight_AttackLogic", "PREVIOUS_HEALTH")
local CURRENT_HEALTH = B.Reference("Knight_AttackLogic", "CURRENT_HEALTH")

local RiposteSequence = Mashina.Sequence {
	Mashina.Check {
		condition = function(mashina, state)
			local status = mashina:getBehavior("CombatStatus")
			local currentHealth = state[CURRENT_HEALTH]
			local previousHealth = state[PREVIOUS_HEALTH]

			if status then
				local halfMaximumHitPoints = status.maximumHitpoints / 2
				if currentHealth < halfMaximumHitPoints and previousHealth > halfMaximumHitPoints then
					return true
				end
			end

			return false
		end
	},

	Mashina.Peep.QueuePower {
		power = "Riposte",
		require_no_cooldown = true
	},

	Mashina.Peep.Talk {
		message = "En garde!"
	}
}

local ParrySequence = Mashina.Step {
	Mashina.Check {
		condition = function(mashina, state)
			local status = mashina:getBehavior("CombatStatus")
			local currentHealth = state[CURRENT_HEALTH]
			local previousHealth = state[PREVIOUS_HEALTH]

			if status then
				local quarterMaximumHitPoints = status.maximumHitpoints / 4
				if currentHealth < quarterMaximumHitPoints and previousHealth > quarterMaximumHitPoints then
					return true
				end
			end

			return false
		end
	},

	Mashina.Peep.QueuePower {
		power = "Parry",
		require_no_cooldown = true
	},

	Mashina.Peep.Talk {
		message = "I will not go down so easily!"
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.QueuePower {
		power = "Decapitate",
		require_no_cooldown = true
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.Talk {
		message = "Your head will roll!"
	}
}

local MeditateSequence = Mashina.Sequence {
	Mashina.Peep.HasEffect {
		effect_type = require "ItsyScape.Peep.Effects.MovementEffect",
		buff_type = Effect.BUFF_TYPE_NEGATIVE,
		min_duration = 10
	},

	Mashina.Peep.CanQueuePower {
		power = "Meditate"
	},

	Mashina.Step {
		Mashina.Peep.TimeOut {
			duration = 2
		},

		Mashina.Peep.QueuePower {
			power = "Meditate"
		},

		Mashina.Peep.Talk {
			message = "You think you can stop me in my tracks so easily?!"
		}
	}
}

local FreedomSequence = Mashina.Sequence {
	Mashina.Peep.HasEffect {
		buff_type = Effect.BUFF_TYPE_NEGATIVE,
		min_duration = 10
	},

	Mashina.Try {
		Mashina.Invert {
			Mashina.Peep.HasEffect {
				effect_type = require "ItsyScape.Peep.Effects.MovementEffect",
				buff_type = Effect.BUFF_TYPE_NEGATIVE,
				min_duration = 10
			}
		},

		Mashina.Invert {
			Mashina.Peep.CanQueuePower {
				power = "Meditate"
			}
		}
	},

	Mashina.Peep.CanQueuePower {
		power = "Freedom"
	},

	Mashina.Step {
		Mashina.Peep.TimeOut {
			duration = 2
		},

		Mashina.Peep.QueuePower {
			power = "Freedom"
		},

		Mashina.Peep.Talk {
			message = "I will not suffer your cowardly effects!"
		}
	}
}

local EarthquakeSequence = Mashina.Step {
	Mashina.Peep.CanQueuePower {
		power = "Earthquake"
	},

	Mashina.Peep.TimeOut {
		min_duration = 2,
		max_duration = 4
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.QueuePower {
		power = "Earthquake",
		require_no_cooldown = true
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.Talk {
		message = "Eart dirt, clod!"
	}
}

local TornadoSequence = Mashina.Step {
	Mashina.Peep.CanQueuePower {
		power = "Tornado"
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.TimeOut {
		min_duration = 2,
		max_duration = 4
	},

	Mashina.Peep.QueuePower {
		power = "Tornado",
		require_no_cooldown = true
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.Talk {
		message = "For the Vizier-King! For the Realm!"
	}
}

local PowerMechanic = Mashina.ParallelSequence {
	Mashina.Success {
		Mashina.Sequence {
			Mashina.ParallelTry {
				Mashina.Peep.WasAttacked,
				Mashina.Peep.WasHealed,
			},

			Mashina.Set {
				value = CURRENT_HEALTH,
				[PREVIOUS_HEALTH] = B.Output.result
			},

			Mashina.Get {
				value = function(mashina, state)
					local status = mashina:getBehavior("CombatStatus")
					return (status and status.currentHitpoints) or 1
				end,

				[CURRENT_HEALTH] = B.Output.result
			}
		},
	},

	Mashina.Success {
		Mashina.ParallelTry {
			Mashina.RandomTry {
				EarthquakeSequence,
				TornadoSequence
			},

			ParrySequence,
			RiposteSequence,
			MeditateSequence,
			FreedomSequence
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Get {
			value = function(mashina, state)
				local status = mashina:getBehavior("CombatStatus")
				return (status and status.currentHitpoints) or 1
			end,

			[CURRENT_HEALTH] = B.Output.result
		},
	},

	Mashina.Peep.ActivatePrayer {
		prayer = "WayOfTheWarrior"
	},

	Mashina.Peep.ActivatePrayer {
		prayer = "BastielsGaze"
	},

	Mashina.Peep.QueuePower {
		power = "Counter"
	},

	Mashina.Repeat {
		Mashina.Success {
			Mashina.ParallelSequence {
				PowerMechanic
			}
		}
	}
}

return Tree
