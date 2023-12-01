--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Prisoner_ClearLogic.lua
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

local KNIGHT = B.Reference("Prisoner", "KNIGHT")

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Peep.FindNearbyMapObject {
			prop = "Knight2",
			[KNIGHT] = B.Output.RESULT
		},

		Mashina.Navigation.WalkToPeep {
			peep = KNIGHT,
			distance = 1.5,
			as_close_as_possible = false
		},

		Mashina.Repeat {
			Mashina.Success {
				Mashina.Sequence {
					Mashina.Navigation.TargetMoved {
						peep = KNIGHT
					},

					Mashina.Navigation.WalkToPeep {
						peep = KNIGHT,
						distance = 1.5,
						as_close_as_possible = false
					}
				}
			},

			Mashina.Invert {
				Mashina.Peep.Wait
			}
		},

		Mashina.RandomTry {
			Mashina.Peep.Talk {
				message = "Here ya go."
			},

			Mashina.Step {
				Mashina.Peep.Talk {
					message = "Pig!"
				},

				Mashina.Peep.TimeOut {
					duration = 0.5
				},

				Mashina.Peep.Talk {
					peep = KNIGHT,
					message = "Hold your tongue, maggot!"
				}
			},

			Mashina.Peep.Talk {
				message = "..."
			},
		},

		Mashina.Peep.Consume {
			item = true,
			quantity = math.huge
		},

		Mashina.Peep.TimeOut {
			min_duration = 0.5,
			max_duration = 1.5
		},

		Mashina.Peep.SetState {
			state = "mine"
		}
	}
}

return Tree
