--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_AttackCommon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Mashina = require "ItsyScape.Mashina"

local PLAYER = B.Reference("Tutorial_AttackCommon", "PLAYER")

local HEAL_HITPOINTS = 20

local HandleHealing = Mashina.Step {
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
			priority = 1001
		},

		Mashina.Peep.Heal {
			hitpoints = HEAL_HITPOINTS
		}
	}
}

local ORLANDO = B.Reference("Tutorial_AttackCommon", "ORLANDO")

local GetOrlando = Mashina.Sequence {
	Mashina.Peep.GetPlayer {
		[PLAYER] = B.Output.player
	},

	Mashina.Peep.FindNearbyPeep {
		filter = function(peep, _, state)
			local isInInstance = Probe.instance(Utility.Peep.getPlayerModel(state[GET_ORLANDO_PLAYER]))(peep)
			local isOrlando = Probe.namedMapObject("Orlando")(peep)

			return isOrlando and isInInstance
		end,

		[ORLANDO] = B.Output.result
	},
}

return {
	PLAYER = PLAYER,

	HEAL_HITPOINTS = HEAL_HITPOINTS,
	HandleHealing = HandleHealing

	ORLANDO = ORLANDO,
	GetOrlando = GetOrlando
}
