--------------------------------------------------------------------------------
-- Resources/Game/Peeps/UndeadSquid/SewerSpiderMatriarch_AttackLogic.lua
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
local Mashina = require "ItsyScape.Mashina"
local Effect = require "ItsyScape.Peep.Effect"

local PREVIOUS_HEALTH = B.Reference("SewerSpiderMatriarch_AttackLogic", "PREVIOUS_HEALTH")
local CURRENT_HEALTH = B.Reference("SewerSpiderMatriarch_AttackLogic", "CURRENT_HEALTH")
local SPIDER_TARGET = B.Reference("SewerSpiderMatriarch_AttackLogic", "SPIDER_TARGET")
local SUMMONED_SPIDERS = B.Reference("SewerSpiderMatriarch_AttackLogic", "SUMMONED_SPIDERS")
local SPIDER_DAMAGE = B.Reference("SewerSpiderMatriarch_AttackLogic", "SPIDER_DAMAGE")
local TOTAL_SPIDER_DAMAGE = B.Reference("SewerSpiderMatriarch_AttackLogic", "TOTAL_SPIDER_DAMAGE")
local ATTACKER = B.Reference("SewerSpiderMatriarch_AttackLogic", "ATTACKER")

local IdleLoop = Mashina.Repeat {
	Mashina.Check {
		condition = function(mashina, state)
			return state[ATTACKER] == nil
		end
	},

	Mashina.ParallelTry {
		Mashina.Sequence {
			Mashina.Try {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = 8,
					[ATTACKER] = B.Output.result
				},

				Mashina.Peep.WasAttacked {
					[ATTACKER] = B.Output.aggressor
				}
			},

			Mashina.Peep.EngageCombatTarget {
				peep = ATTACKER
			},

			Mashina.Peep.PokeSelf {
				event = "boss"
			}
		},

		Mashina.Step {
			Mashina.Navigation.Wander {
				min_radial_distance = 4,
				radial_distance = 6
			},

			Mashina.Peep.Wait
		}
	}
}

local SummonSpidersMechanic = Mashina.Step {
	Mashina.Invert {
		Mashina.Check {
			condition = SUMMONED_SPIDERS
		}
	},

	Mashina.Check {
		condition = function(mashina)
			local status = mashina:getBehavior("CombatStatus")
			return status.currentPrayer == 0
		end
	},

	Mashina.Set {
		value = true,
		[SUMMONED_SPIDERS] = B.Output.result
	},

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.PokeSelf {
		event = "summonSpiders",
		poke = 3
	},

	Mashina.Peep.DidAttack,

	Mashina.Repeat {
		Mashina.Step {
			Mashina.Peep.FindNearbyCombatTarget {
				filter = function(p)
					local r = Utility.Peep.getResource(p)
					return r and r.name == "SewerSpider"
				end,
				distance = 24,
				include_npcs = true,
				[SPIDER_TARGET] = B.Output.result
			},

			Mashina.Peep.EngageCombatTarget {
				peep = SPIDER_TARGET
			},

			Mashina.Repeat {
				Mashina.Invert {
					Mashina.Peep.IsDead {
						peep = SPIDER_TARGET
					}
				},

				Mashina.Peep.DidAttack {
					[SPIDER_DAMAGE] = B.Output.damage
				},

				Mashina.Add {
					left = TOTAL_SPIDER_DAMAGE,
					right = SPIDER_DAMAGE,
					[TOTAL_SPIDER_DAMAGE] = B.Output.result
				}
			}
		}
	},

	Mashina.Get {
		value = function(mashina, state)
			local totalPrayerPoints = state[TOTAL_SPIDER_DAMAGE] or 0

			local status = mashina:getBehavior("CombatStatus")
			status.currentPrayer = status.currentPrayer + totalPrayerPoints
		end
	},

	Mashina.Peep.ActivatePrayer {
		prayer = "WayOfTheWarrior"
	},

	Mashina.Peep.ActivatePrayer {
		prayer = "BastielsGaze"
	},

	Mashina.Peep.ActivatePrayer {
		prayer = "PathOfLight"
	},

	Mashina.Peep.PokeSelf {
		event = "switchTarget"
	}
}

local WeakenMechanic = Mashina.Step {
	Mashina.Peep.CanQueuePower {
		power = "Weaken"
	},

	Mashina.Peep.QueuePower {
		power = "Weaken"
	},

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.TimeOut {
		duration = 60
	},

	Mashina.Peep.PokeSelf {
		event = "switchTarget"
	}
}

local IronSkinSequence = Mashina.Sequence {
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

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.QueuePower {
		power = "IronSkin"
	}
}

local AbsorbSequence = Mashina.Sequence {
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

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.QueuePower {
		power = "Absorb"
	}
}

local GravitySequence = Mashina.Step {
	Mashina.Check {
		condition = function(mashina, state)
			local status = mashina:getBehavior("CombatStatus")
			local currentHealth = state[CURRENT_HEALTH]
			local previousHealth = state[PREVIOUS_HEALTH]

			if status then
				local tenthMaximumHitPoints = status.maximumHitpoints * (3 / 4)
				if currentHealth < tenthMaximumHitPoints and previousHealth > tenthMaximumHitPoints then
					return true
				end
			end

			return false
		end
	},

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.Notify {
		instance = true,
		message = "You feel a gravity well beginning to form!"
	},

	Mashina.Peep.DidAttack,

	Mashina.Peep.QueuePower {
		power = "Gravity"
	}
}

local MeditateSequence = Mashina.Sequence {
	Mashina.Peep.HasEffect {
		effect_type = require "ItsyScape.Peep.Effects.MovementEffect",
		buff_type = Effect.BUFF_TYPE_NEGATIVE
	},

	Mashina.Peep.CanQueuePower {
		power = "Meditate"
	},

	Mashina.Peep.TimeOut {
		duration = 5
	},

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.QueuePower {
		power = "Meditate"
	}
}

local FreedomSequence = Mashina.Sequence {
	Mashina.Peep.HasEffect {
		buff_type = Effect.BUFF_TYPE_NEGATIVE
	},

	Mashina.Try {
		Mashina.Invert {
			Mashina.Peep.HasEffect {
				effect_type = require "ItsyScape.Peep.Effects.MovementEffect",
				buff_type = Effect.BUFF_TYPE_NEGATIVE
			}
		},

		Mashina.Invert {
			Mashina.Peep.CanQueuePower {
				power = "Meditate"
			}
		}
	},

	Mashina.Peep.TimeOut {
		duration = 5
	},

	Mashina.Peep.PlayAnimation {
		filename = "Resources/Game/Animations/Spider_Special/Script.lua",
		priority = 2000
	},

	Mashina.Peep.QueuePower {
		power = "Freedom"
	}
}

local PowersMechanic = Mashina.Step {
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

	Mashina.Success {
		Mashina.ParallelTry {
			IronSkinSequence,
			AbsorbSequence,
			GravitySequence,
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

		IdleLoop,

		Mashina.Peep.ActivatePrayer {
			prayer = "MetalSkin"
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "TimeErosion"
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "PathOfLight"
		},

		Mashina.Repeat {
			Mashina.Success {
				SummonSpidersMechanic
			},

			Mashina.ParallelSequence {
				Mashina.Success {
					WeakenMechanic
				},

				Mashina.Success {
					PowersMechanic
				}
			}
		}
	}
}

return Tree
