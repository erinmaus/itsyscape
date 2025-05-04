--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_ChopLogic.lua
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

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Step {
			Mashina.Repeat {
				Mashina.Skills.GatherNearbyResource {
					action = "Mine",
					resource = "AzatiteOre"
				},

				Mashina.Invert {
					Mashina.Peep.TimeOut {
						min_duration = 10,
						max_duration = 20
					}
				}
			},

			Mashina.Repeat {
				Mashina.ParallelSequence {
					Mashina.Step {
						Mashina.Navigation.Wander,
						Mashina.Peep.Wait
					},

					Mashina.Invert {
						Mashina.Peep.TimeOut {
							min_duration = 10,
							max_duration = 30
						}
					}
				}
			}
		}
	}
}

return Tree
