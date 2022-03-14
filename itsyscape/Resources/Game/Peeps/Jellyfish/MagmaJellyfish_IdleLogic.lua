--------------------------------------------------------------------------------
-- Resources/Game/Peeps/MagmaJellyfish/MagmaJellyfish_IdleLogic.lua
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

local TARGET = B.Reference("MagmaJellyfish_IdleLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.ParallelTry {
			Mashina.Step {
				Mashina.Peep.FindNearbyCombatTarget {
					distance = 1.5,
					[TARGET] = B.Output.result
				},

				Mashina.Peep.PokeSelf {
					event = "explode",
					poke = TARGET
				},

				Mashina.Peep.TimeOut {
					duration = 3
				}
			},

			Mashina.Step {
				Mashina.Navigation.Wander {
					min_radial_distance = 8,
					radial_distance = 32
				},

				Mashina.Peep.Wait,

				Mashina.Peep.TimeOut {
					min_duration = 1,
					max_duration = 2
				},
			}
		}
	}
}

return Tree
