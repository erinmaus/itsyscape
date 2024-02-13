--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_Pirate/Scripts/CapnRaven_ChaseLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Vector = require "ItsyScape.Common.Math.Vector"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local DISTANCE = 16

local TARGET = B.Reference("CapnRaven_ChaseLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Peep.FindNearbyPeep {
			filters = {
				Probe.resource("Map", "Ship_IsabelleIsland_PortmasterJenkins")
			},

			[TARGET] = B.Output.result
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.RandomTry {
					Mashina.Sailing.Sail {
						target = TARGET,
						distance = DISTANCE,
						offset = Vector(0, 0, 32)
					},

					Mashina.Sailing.Sail {
						target = TARGET,
						distance = DISTANCE,
						offset = Vector(0, 0, -32)
					},
				},

				Mashina.Success {
					Mashina.Sailing.FireCannons
				},

				Mashina.Sailing.Sail {
					target = TARGET,
					distance = DISTANCE,
					offset = Vector(0, 0, 64)
				}
			}
		}
	}
}

return Tree
