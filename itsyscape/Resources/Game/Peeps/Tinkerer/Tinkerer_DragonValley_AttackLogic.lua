--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Tinkerer/Tinkerer_DragonValley_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local AGGRESSOR = B.Reference("Tinkerer", "AGGRESSOR")
local PRAYER = B.Reference("Tinkerer", "PRAYER")
local NUM_HITS = B.Reference("Tinkerer", "NUM_HITS")

local POWER_THRESHOLD = 4

local DamageSequence = Mashina.Success {
	Mashina.Sequence {
		Mashina.Try {
			Mashina.Check {
				condition = function(_, state)
					return state[AGGRESSOR]
				end
			},

			Mashina.Peep.WasAttacked {
				took_damage = true,
				[AGGRESSOR] = B.Output.aggressor
			},
		},

		Mashina.Peep.DidAttack,

		Mashina.Set {
			value = function(_, state)
				local aggressor = state[AGGRESSOR]
				local weapon = Utility.Peep.getEquippedWeapon(aggressor, true)
				if weapon and Class.isCompatibleType(weapon, Weapon) then
					local style = weapon:getStyle()

					if style == Weapon.STYLE_MAGIC then
						return "PrisiumsProtection"
					elseif style == Weapon.STYLE_ARCHERY then
						return "BastielsBarricade"
					elseif style == Weapon.STYLE_MELEE then
						return "GammonsGrace"
					else
						return "MetalSkin"
					end
				end
			end,

			[PRAYER] = B.Output.result
		},

		Mashina.Set {
			value = false,
			[AGGRESSOR] = B.Output.result
		},

		Mashina.Invert {
			Mashina.Peep.HasEffect {
				effect_type = PRAYER
			}
		},

		Mashina.Peep.ActivatePrayer {
			prayer = PRAYER,
			toggle
		}
	}
}

local AttackWaitSequence = Mashina.Success {
	Mashina.Sequence {
		Mashina.Repeat {
			Mashina.Peep.DidAttack,

			Mashina.Add {
				left = NUM_HITS,
				right = 1,

				[NUM_HITS] = B.Output.result
			},

			Mashina.Invert {
				Mashina.Compare.GreaterThanEqual {
					left = NUM_HITS,
					right = POWER_THRESHOLD
				}
			}
		},

		Mashina.Try {
			Mashina.Peep.CanQueuePower {
				power = "Shockwave"
			},

			Mashina.Peep.CanQueuePower {
				power = "Headshot"
			},

			Mashina.Peep.CanQueuePower {
				power = "SoulStrike"
			},

			Mashina.Peep.CanQueuePower {
				power = "Snipe"
			},

			Mashina.Peep.CanQueuePower {
				power = "Hesitate"	
			}
		},

		Mashina.Peep.PlayAnimation {
			slot = "x-attack",
			filename = "Resources/Game/Animations/Tinkerer_Special_Attack/Script.lua",
			priority = 1500
		},

		Mashina.Peep.Talk {
			message = "Caw! Let's see how you like this!"
		}
	}
}

local AttackSequence = Mashina.Success {
	Mashina.Step {
		AttackWaitSequence,

		Mashina.RandomTry {
			Mashina.Peep.QueuePower {
				require_no_cooldown = true,
				power = "Shockwave"
			},


			Mashina.Peep.QueuePower {
				require_no_cooldown = true,
				power = "Headshot"
			},

			Mashina.Peep.QueuePower {
				require_no_cooldown = true,
				power = "SoulStrike"
			},

			Mashina.Peep.QueuePower {
				require_no_cooldown = true,
				power = "Snipe"
			},

			Mashina.Peep.QueuePower {
				require_no_cooldown = true,
				power = "Hesitate"
			}
		},

		Mashina.Peep.DidAttack,

		Mashina.Set {
			value = 0,
			[NUM_HITS] = B.Output.result
		}
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.ActivatePrayer {
			prayer = "PathOfLight"
		},

		Mashina.Peep.ActivatePrayer {
			prayer = "GammonsReckoning"
		},

		Mashina.Repeat {
			Mashina.ParallelSequence {
				DamageSequence,
				AttackSequence
			}
		}
	}
}

return Tree
