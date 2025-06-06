--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_Pirate/Scripts/CapnRaven_CthulhuLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local DISTANCE = 8

local TARGET = B.Reference("CapnRaven_ChaseLogic", "TARGET")
local OFFSET = B.Reference("CapnRaven_ChaseLogic", "OFFSET")

local Tree = BTreeBuilder.Node() {
	Mashina.Sequence {
		Mashina.Repeat {
			Mashina.Invert {
				Mashina.ParallelTry {
					Mashina.Peep.FindNearbyPeep {
						filters = {
							Probe.resource("Peep", "Cthulhu")
						},

						[TARGET] = B.Output.result
					},

					Mashina.Failure {
						Mashina.Sailing.Sail {
							direction = -0.25
						}
					}
				}
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Sequence {
					Mashina.Sailing.GetNearestOffset {
						target = TARGET,
						offsets = {
							Vector(24, 0, 0),
							Vector(-24, 0, 0),
							Vector(0, 0, 24),
							Vector(0, 0, -24)
						},

						[OFFSET] = B.Output.result
					},

					Mashina.Sailing.Sail {
						target = TARGET,
						distance = DISTANCE,
						offset = OFFSET
					}
				},

				Mashina.Success {
					Mashina.Sailing.FireCannons {
						target = TARGET,
						always = true
					}
				},

				Mashina.ParallelSequence {
					Mashina.Peep.TimeOut {
						duration = 5
					},

					Mashina.Sailing.Sail {
						target = TARGET,
						direction = 0
					}
				}
			}
		}
	}
}

return Tree
