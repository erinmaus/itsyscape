--------------------------------------------------------------------------------
-- Resources/Game/Peeps/RatKing/RatKing_HungryLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local TARGET = B.Reference("RatKing_HungryLogic", "TARGET")

local function ratProbe(p)
	local gameDB = p:getDirector():getGameDB()

	local resource = Utility.Peep.getResource(p)
	if not resource then
		return false
	end

	local tag = gameDB:getRecord("ResourceTag", {
		Value = "Rat",
		Resource = resource
	})

	if not tag then
		return false
	end

	local mapObject = Utility.Peep.getMapObject(p)
	if not mapObject then
		return false
	end

	local isInGroup = gameDB:getRecord("MapObjectGroup", {
		MapObjectGroup = "RatKing_Court",
		Map = Utility.Peep.getMapResource(p),
		MapObject = mapObject
	})

	if not isInGroup then
		return false
	end

	local status = p:getBehavior("CombatStatus")
	return status and not status.dead and status.currentHitpoints > 0
end

local SummonOrTargetSequence = Mashina.ParallelTry {
	Mashina.Sequence {
		Mashina.Peep.FindNearbyCombatTarget {
			filter = ratProbe,
			distance = 12,
			include_npcs = true,
			[TARGET] = B.Output.result
		},

		Mashina.Peep.Talk {
			message = "ENGAGED"
		}
	},

	Mashina.Step {
		Mashina.Peep.PokeSelf {
			event = "summon"
		},

		Mashina.Peep.Talk {
			message = "You think you've outsmarted me by slaying my court...?"
		},

		Mashina.Peep.Timeout {
			duration = 1
		},

		Mashina.Peep.FindNearbyCombatTarget {
			filter = ratProbe,
			distance = 12,
			include_npcs = true,
			[TARGET] = B.Output.result
		}
	}
}

local FightSequence = Mashina.Repeat {
	Mashina.Try {
		Mashina.Sequence {
			Mashina.Invert {
				Mashina.Peep.IsCombatTarget {
					target = TARGET
				}
			},

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET
			}
		},

		Mashina.Sequence {
			Mashina.Peep.IsCombatTarget {
				target = TARGET
			},

			Mashina.Invert {
				Mashina.Peep.IsDead
			}
		}
	}
}

local EatSequence = Mashina.Sequence {
	Mashina.Peep.Talk {
		message = "Yum!"
	},

	Mashina.Peep.PokeSelf {
		event = "eat",
		poke = function(_, state)
			return {
				target = state[TARGET]
			}
		end
	}
}

local AttackPlayerSequence = Mashina.Sequence {
	Mashina.Peep.FindNearbyCombatTarget {
		[TARGET] = B.Output.result
	},

	Mashina.Peep.EngageCombatTarget {
		peep = TARGET
	},

	Mashina.Peep.SetState {
		state = "attack"
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		SummonOrTargetSequence,
		FightSequence,
		EatSequence,
		AttackPlayerSequence,
	}
}

return Tree
