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
local Mashina = require "ItsyScape.Mashina"
local Probe = require "ItsyScape.Peep.Probe"

local BARREL = B.Reference("Behemoth_IdleLogic", "BARREL")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Sequence {
			Mashina.Peep.FindNearbyPeep {
				filters = {
					Probe.resource("Prop", "EmptyRuins_DragonValley_Barrel")
				},

				[BARREL] = B.Output.result
			},

			Mashina.Step {
				Mashina.Navigation.WalkToPeep {
					peep = BARREL,
					distance = 0,
					as_close_as_possible = true
				},

				Mashina.Peep.Wait,

				Mashina.Peep.PokeSelf {
					event = "splodeBarrel",
					poke = BARREL
				}
			}
		},

		Mashina.Step {
			Mashina.Peep.TimeOut {
				min_duration = 4,
				max_duration = 8
			},

			Mashina.Navigation.Wander {
				radial_distance = 32
			},

			Mashina.Peep.Wait
		}
	}
}

return Tree
