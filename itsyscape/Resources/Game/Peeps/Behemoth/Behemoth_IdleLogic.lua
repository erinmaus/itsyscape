--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Behemoth/Behemoth_IdleLogic.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local BARREL_PROP = B.Reference("Behemoth_IdleLogic", "BARREL_PROP")
local BARREL_MIMIC = B.Reference("Behemoth_IdleLogic", "BARREL_MIMIC")
local BARREL_MIMIC_COUNT = B.Reference("Behemoth_IdleLogic", "BARREL_MIMIC_COUNT")
local MAP = B.Reference("Behemoth_IdleLogic", "MAP")

local MIN_BARREL_MIMIC_COUNT = 5

local EatBarrel = Mashina.Success {
	Mashina.Sequence {
		Mashina.Peep.FindNearbyPeep {
			filters = {
				Probe.resource("Prop", "EmptyRuins_DragonValley_Barrel")
			},

			[BARREL_PROP] = B.Output.result
		},

		Mashina.Step {
			Mashina.Navigation.WalkToPeep {
				peep = BARREL_PROP,
				distance = 0,
				as_close_as_possible = true
			},

			Mashina.Peep.Wait,

			Mashina.Peep.PokeSelf {
				event = "splodeBarrel",
				poke = BARREL_PROP
			}
		}
	}
}

local DropMimic = Mashina.Sequence {
	Mashina.Peep.FindNearbyPeep {
		filter = function(p, mashina)
			return Utility.Peep.getLayer(p) ~= Utility.Peep.getLayer(mashina)
		end,

		filters = {
			Probe.namedMapObject("BarrelMimic")
		},

		[BARREL_MIMIC] = B.Output.result
	},

	Mashina.Success {
		Mashina.Sequence {
			Mashina.Peep.FindNearbyPeep {
				random = true,
				filter = function(p, _, state)
					local portal = p:getBehavior(TeleportalBehavior)
					local resource = Utility.Peep.getResource(p)

					local isLayerMatch = portal and portal.layer == Utility.Peep.getLayer(state[BARREL_MIMIC])
					local isResourceMatch = resource and (resource.name == "BehemothMap" or resource.name == "BehemothMap_Climbable")

					return isLayerMatch and isResourceMatch
				end,

				[MAP] = B.Output.result
			},

			Mashina.Peep.PokeSelf {
				event = "drop",
				args = function(mashina, state)
					return state[MAP], state[BARREL_MIMIC]
				end
			}
		}
	}
}

local SpawnMimic = Mashina.Sequence {
	Mashina.Success {
		Mashina.Peep.FindNearbyPeep {
			filter = function(p, mashina)
				return Utility.Peep.getLayer(p) == Utility.Peep.getLayer(mashina)
			end,

			filters = {
				Probe.namedMapObject("BarrelMimic")
			},

			[BARREL_MIMIC_COUNT] = B.Output.count
		},
	},

	Mashina.Compare.LessThan {
		left = BARREL_MIMIC_COUNT,
		right = MIN_BARREL_MIMIC_COUNT
	},

	Mashina.Peep.FindNearbyPeep {
		random = true,
		filter = function(p)
			local resource = Utility.Peep.getResource(p)
			return resource and (resource.name == "BehemothMap" or resource.name == "BehemothMap_Climbable")
		end,

		[MAP] = B.Output.result
	},

	Mashina.Peep.PokeSelf {
		event = "shedMimic",
		args = function(mashina, state)
			return state[MAP], false, "BarrelMimic"
		end
	}
}

local ShedBarrelMimic = Mashina.Success {
	Mashina.Try {
		DropMimic,
		SpawnMimic
	}
}

local Wander = Mashina.Step {
	Mashina.Peep.TimeOut {
		min_duration = 4,
		max_duration = 8
	},

	Mashina.Navigation.Wander {
		radial_distance = 32
	},

	Mashina.Peep.Wait
}

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.ParallelSequence {
			EatBarrel,
			ShedBarrelMimic
		},

		Wander
	}
}

return Tree
