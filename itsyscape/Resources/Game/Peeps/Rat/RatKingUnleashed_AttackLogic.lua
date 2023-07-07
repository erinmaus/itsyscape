--------------------------------------------------------------------------------
-- Resources/Game/Peeps/RatKing/RatKingUnleashed_AttackLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local JESTER = B.Reference("RatKingUnleashed_AttackLogic", "JESTER")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Success {
			Mashina.Sequence {
				Mashina.Invert {
					Mashina.Peep.FindNearbyPeep {
						filter = Probe.resource("Peep", "RatKingsJester"),
						distance = math.huge,
						[JESTER] = B.Output.result
					}
				},

				Mashina.Peep.TimeOut {
					min_duration = 4,
					max_duration = 8
				},

				Mashina.Peep.PokeSelf {
					event = "summonJester"
				}
			}
		}
	}
}

return Tree
