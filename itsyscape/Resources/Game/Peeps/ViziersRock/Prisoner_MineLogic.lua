--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Prisoner_MineLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local BTreeBuilder = require "B.TreeBuilder"
local Mashina = require "ItsyScape.Mashina"

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.Wait,

		Mashina.Repeat {
			Mashina.Invert {
				Mashina.Peep.IsInventoryFull
			},

			Mashina.Step {
				Mashina.Try {
					Mashina.Skills.Mining.MineNearbyRock {
						resource = "CoalOre"
					},

					Mashina.Peep.SetState {
						state = "idle"
					}
				},

				Mashina.Peep.Wait,

				Mashina.Navigation.Wander {
					radial_distance = 3
				},

				Mashina.Peep.Wait,

				Mashina.Peep.TimeOut {
					min_duration = 0.5,
					max_duration = 1.5
				},
			},
		},

		Mashina.Peep.TimeOut {
			min_duration = 0.5,
			max_duration = 1.5
		},

		Mashina.Navigation.Wander {
			radial_distance = 2
		},

		Mashina.Peep.Wait,

		Mashina.Peep.SetState {
			state = "clear"
		}
	}
}

return Tree
