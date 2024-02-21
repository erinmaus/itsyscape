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

local PIRATE_TARGET = B.Reference("Cthulhu", "PIRATE_TARGET")
local JENKINS_TARGET = B.Reference("Cthulhu", "JENKINS_TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.TimeOut {
			duration = 4
		},

		Mashina.Peep.Talk {
			message = "Urm'yth rh'lr rh'sylk..."
		},

		Mashina.Repeat {
			Mashina.ParallelSequence {
				Mashina.Step {
					Mashina.Peep.FindNearbyPeep {
						filters = {
							Probe.resource("Map", "Ship_IsabelleIsland_Pirate")
						},

						[PIRATE_TARGET] = B.Output.result
					},

					Mashina.RandomTry {
						Mashina.Peep.FireProjectile {
							destination = PIRATE_TARGET,
							offset = Vector(-40, 5, 20),
							projectile = "Starfall"
						},

						Mashina.Peep.FireProjectile {
							destination = PIRATE_TARGET,
							offset = Vector(-40, 5, -20),
							projectile = "Starfall"
						},

						Mashina.Peep.FireProjectile {
							destination = PIRATE_TARGET,
							offset = Vector(0, 5, 0),
							projectile = "DecayingBolt"
						},

						Mashina.Peep.FireProjectile {
							destination = PIRATE_TARGET,
							offset = Vector(0, 5, 0),
							projectile = "DecayingBolt"
						}
					},

					Mashina.Peep.TimeOut {
						min_duration = 8,
						max_duration = 12
					}
				},

				Mashina.Step {
					Mashina.Peep.FindNearbyPeep {
						filters = {
							Probe.resource("Map", "Ship_IsabelleIsland_PortmasterJenkins")
						},

						[JENKINS_TARGET] = B.Output.result
					},

					Mashina.RandomTry {
						Mashina.Peep.FireProjectile {
							destination = JENKINS_TARGET,
							offset = Vector(-40, 5, 20),
							projectile = "Starfall"
						},

						Mashina.Peep.FireProjectile {
							destination = JENKINS_TARGET,
							offset = Vector(-40, 5, -20),
							projectile = "Starfall"
						},

						Mashina.Peep.FireProjectile {
							destination = JENKINS_TARGET,
							offset = Vector(0, 5, 0),
							projectile = "DecayingBolt"
						},

						Mashina.Peep.FireProjectile {
							destination = JENKINS_TARGET,
							offset = Vector(0, 5, 0),
							projectile = "DecayingBolt"
						}
					},

					Mashina.Peep.TimeOut {
						min_duration = 8,
						max_duration = 12
					}
				}
			}
		}
	}
}

return Tree
