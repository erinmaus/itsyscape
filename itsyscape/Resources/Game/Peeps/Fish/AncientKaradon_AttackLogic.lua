--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Fish/AncientKaradon_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local Effect = require "ItsyScape.Peep.Effect"

local PREVIOUS_HEALTH = B.Reference("AncientKaradon_AttackLogic", "PREVIOUS_HEALTH")
local CURRENT_HEALTH = B.Reference("AncientKaradon_AttackLogic", "CURRENT_HEALTH")

local NEXT_THRESHOLD = B.Reference("AncientKaradon_AttackLogic", "NEXT_THRESHOLD")
local THRESHOLD_STEP = 100

local DiveMechanic = Mashina.Step {
	Mashina.Try {
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
	},

	Mashina.Check {
		condition = function(mashina, state)
			local currentHealth = state[CURRENT_HEALTH]
			local previousHealth = state[PREVIOUS_HEALTH]
			local nextThreshold = state[NEXT_THRESHOLD]

			if not nextThreshold then
				local status = mashina:getBehavior("CombatStatus")
				nextThreshold = status.maximumHitpoints - THRESHOLD_STEP
			end

			local hitThreshold = false
			if currentHealth < previousHealth then
				if currentHealth < nextThreshold then
					nextThreshold = currentHealth - THRESHOLD_STEP
					hitThreshold = true
				end
			end

			state[NEXT_THRESHOLD] = nextThreshold

			return hitThreshold
		end
	},

	Mashina.Invert {
		Mashina.Peep.IsDead
	},

	Mashina.Peep.PokeSelf {
		event = "dive"
	}
}

local PowersMechanic = Mashina.ParallelTry {
	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_MAGIC
		},

		Mashina.Step {
			Mashina.Peep.DidAttack,

			Mashina.RandomCheck {
				chance = 1 / 3
			},

			Mashina.RandomSequence {
				Mashina.Peep.QueuePower {
					power = "IceBarrage",
					require_no_cooldown = true
				},

				Mashina.Peep.QueuePower {
					power = "BindShadow",
					require_no_cooldown = true
				},
			},

			Mashina.Peep.DidAttack
		}
	},

	Mashina.Sequence {
		Mashina.Peep.IsCombatStyle {
			style = Weapon.STYLE_ARCHERY
		},

		Mashina.Step {
			Mashina.Peep.DidAttack,

			Mashina.RandomCheck {
				chance = 1 / 3
			},

			Mashina.RandomSequence {
				Mashina.Peep.QueuePower {
					power = "Shockwave",
					require_no_cooldown = true
				},

				Mashina.Peep.QueuePower {
					power = "Snipe",
					require_no_cooldown = true
				},
			},

			Mashina.Peep.DidAttack
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

		Mashina.Repeat {
			Mashina.Success {
				Mashina.ParallelSequence {
					DiveMechanic,
					PowersMechanic
				}
			}
		}
	}
}

return Tree
