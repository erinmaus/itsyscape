--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_AttackCommon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local PLAYER = B.Reference("Tutorial_CommonLogic", "PLAYER")
local PLAYER_TARGET = B.Reference("Tutorial_CommonLogic", "PLAYER_TARGET")

local GetPlayer = Mashina.Peep.GetPlayer {
	[PLAYER] = B.Output.player
}

local AttackPlayerTarget = Mashina.Step {
	Mashina.Invert {
		Mashina.Player.IsNextQuestStep {
			player = PLAYER,
			quest = "Tutorial",
			step = "Tutorial_Combat"
		}
	},

	Mashina.Peep.DidAttack {
		peep = PLAYER,
		[PLAYER_TARGET] = B.Output.target
	},

	Mashina.Peep.EngageCombatTarget {
		peep = PLAYER_TARGET
	},

	Mashina.Peep.Wait
}

local IsAttacking = Mashina.Sequence {
	Mashina.ParallelTry {
		Mashina.Peep.DidAttack,
		Mashina.Peep.WasAttacked,
		Mashina.Peep.HasCombatTarget
	},

	Mashina.Peep.SetState {
		state = "tutorial-general-attack"
	}
}

local HEAL_HITPOINTS = 20
local Heal = Mashina.Step {
	Mashina.Peep.WasAttacked,

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
			priority = 500
		},

		Mashina.Peep.Heal {
			hitpoints = HEAL_HITPOINTS
		}
	}
}

local ORLANDO = B.Reference("Tutorial_CommonLogic", "ORLANDO")

local GetOrlando = Mashina.Sequence {
	Mashina.Peep.GetPlayer {
		[PLAYER] = B.Output.player
	},

	Mashina.Peep.FindNearbyPeep {
		include_self = true,

		filter = function(peep, _, state)
			local isInInstance = Probe.instance(Utility.Peep.getPlayerModel(state[PLAYER]))(peep)
			local isOrlando = Probe.namedMapObject("Orlando")(peep)

			return isOrlando and isInInstance
		end,

		[ORLANDO] = B.Output.result
	},
}

local KNIGHT_COMMANDER = B.Reference("Tutorial_CommonLogic", "KNIGHT_COMMANDER")

local GetKnightCommander = Mashina.Sequence {
	Mashina.Peep.GetPlayer {
		[PLAYER] = B.Output.player
	},

	Mashina.Peep.FindNearbyPeep {
		filter = function(peep, _, state)
			local isInInstance = Probe.instance(Utility.Peep.getPlayerModel(state[PLAYER]))(peep)
			local isOrlando = Probe.namedMapObject("KnightCommander")(peep)

			return isOrlando and isInInstance
		end,

		[KNIGHT_COMMANDER] = B.Output.result
	},
}

local DID_YIELD = B.Reference("Tutorial_CommonLogic", "DID_YIELD")

local DidYieldDuringCombatTutorial = Mashina.Step {
	Mashina.Peep.HasCombatTarget {
		peep = PLAYER
	},

	Mashina.Repeat {
		Mashina.Peep.HasCombatTarget {
			peep = PLAYER
		}
	},

	Mashina.Success {
		Mashina.Peep.DisengageCombatTarget
	},

	GetOrlando,

	Mashina.Player.Disable {
		player = PLAYER
	},

	Mashina.Player.Dialog {
		peep = ORLANDO,
		player = PLAYER,
		main = "quest_tutorial_combat.incorrect_yield"
	},

	Mashina.Player.Enable {
		player = PLAYER
	},

	Mashina.Set {
		value = true,
		[DID_YIELD] = B.Output.result
	}
}

local IsYielding = Mashina.Sequence {
	Mashina.Check {
		condition = DID_YIELD
	},

	Mashina.Repeat {
		Mashina.Invert {
			Mashina.Sequence {
				Mashina.Peep.HasCombatTarget {
					peep = PLAYER,
					[PLAYER_TARGET] = B.Output.target					
				},

				Mashina.Check {
					condition = function(mashina, state)
						return state[PLAYER_TARGET] == mashina
					end
				}
			}
		}
	},

	Mashina.Set {
		value = false,
		[DID_YIELD] = B.Output.result
	}
}

return {
	PLAYER = PLAYER,
	PLAYER_TARGET = PLAYER_TARGET,

	GetPlayer = GetPlayer,

	AttackPlayerTarget = AttackPlayerTarget,
	IsAttacking = IsAttacking,

	HEAL_HITPOINTS = HEAL_HITPOINTS,
	Heal = Heal,

	ORLANDO = ORLANDO,
	GetOrlando = GetOrlando,

	KNIGHT_COMMANDER = KNIGHT_COMMANDER,
	GetKnightCommander = GetKnightCommander,

	DID_YIELD = DID_YIELD,
	DidYieldDuringCombatTutorial = DidYieldDuringCombatTutorial,
	IsYielding = IsYielding
}
