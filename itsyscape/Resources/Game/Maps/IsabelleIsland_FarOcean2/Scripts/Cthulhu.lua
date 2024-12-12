--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean2/Scripts/Cthulhu.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Mashina = require "ItsyScape.Mashina"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"

local TARGET = B.Reference("Cthulhu", "TARGET")
local OFFSET = B.Reference("Cthulhu", "OFFSET")

local DISTANCE = 4

-- local FindTargetTry = Mashina.RandomTry {
-- 	Mashina.Peep.FindNearbyPeep {
-- 		filters = {
-- 			Probe.resource("Map", "Ship_IsabelleIsland_PortmasterJenkins")
-- 		},

-- 		[TARGET] = B.Output.result
-- 	},

-- 	Mashina.Peep.FindNearbyPeep {
-- 		filters = {
-- 			Probe.resource("Map", "Ship_IsabelleIsland_Pirate")
-- 		},

-- 		[TARGET] = B.Output.result
-- 	}
-- }

local FindTargetTry = Mashina.Peep.FindNearbyPeep {
	filters = {
		Probe.resource("Map", "Test_Ship")
	},

	[TARGET] = B.Output.result
}

local SwimSequence = Mashina.Sequence {
	Mashina.Sailing.GetNearestOffset {
		target = TARGET,
		offsets = {
			Ray(Vector(16, 0, -16), -Vector.UNIT_Z),
			Ray(Vector(-16, 0, -16), -Vector.UNIT_Z),
			Ray(Vector(16, 0, -32), -Vector.UNIT_Z),
			Ray(Vector(-16, 0, -32), -Vector.UNIT_Z),
		},
		[OFFSET] = B.Output.result
	},

	Mashina.Sailing.Swim {
		target = TARGET,
		offset = OFFSET,
		distance = DISTANCE
	}
}

local AttackSequence =  Mashina.Step {
	Mashina.Peep.PlayAnimation {
		animation = "Cthulhu_Attack",
		slot = "combat",
		priority = 1000
	},

	Mashina.Peep.LookAt {
		target = TARGET
	},

	Mashina.Peep.Talk {
		message = "Urm'yth rh'lr rh'sylk...",
		duration = 4,
		log = false
	},

	Mashina.RandomTry {
		Mashina.Peep.FireProjectile {
			destination = TARGET,
			offset = Vector(-40, 5, 20),
			projectile = "Starfall"
		},

		Mashina.Peep.FireProjectile {
			destination = TARGET,
			offset = Vector(-40, 5, -20),
			projectile = "Starfall"
		},

		Mashina.Peep.FireProjectile {
			destination = TARGET,
			offset = Vector(0, 5, 0),
			projectile = "DecayingBolt"
		},

		Mashina.Peep.FireProjectile {
			destination = TARGET,
			offset = Vector(0, 5, 0),
			projectile = "DecayingBolt"
		}
	},

	Mashina.Peep.TimeOut {
		min_duration = 4,
		max_duration = 8
	}
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "Urm'yth rh'lr rh'sylk...",
			duration = 4
		},

		-- Mashina.Peep.FindNearbyPeep {
		-- 	filters = {
		-- 		Probe.resource("Map", "Ship_IsabelleIsland_PortmasterJenkins")
		-- 	},

		-- 	[TARGET] = B.Output.result
		-- },

		-- Mashina.Peep.TimeOut {
		-- 	duration = 2
		-- },

		-- Mashina.Peep.PlayAnimation {
		-- 	animation = "Cthulhu_Attack",
		-- 	slot = "combat",
		-- 	priority = 1000
		-- },

		-- Mashina.Peep.TimeOut {
		-- 	duration = 2,
		-- },

		-- Mashina.Peep.FireProjectile {
		-- 	destination = TARGET,
		-- 	offset = Vector(-40, 5, 0),
		-- 	projectile = "Starfall"
		-- },

		-- Mashina.Peep.TimeOut {
		-- 	duration = 10,
		-- },

		Mashina.Repeat {
			Mashina.Step {
				FindTargetTry,

				Mashina.Step {
					SwimSequence,
					AttackSequence
				}
			}
		}
	}
}

return Tree
