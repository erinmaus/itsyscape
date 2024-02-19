--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean/Scripts/UndeadSquid.lua
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
	Mashina.Step {
		Mashina.Peep.Talk {
			message = "Raaaaaaaa!",
			log = false
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Peep.TimeOut {
					min_duration = 2,
					max_duration = 4
				},

				Mashina.Success {
					Mashina.Sequence {
						Mashina.Peep.FindNearbyPeep {
							filters = {
								function(peep)
									local resource, resourceType = Utility.Peep.getResource(peep)
									if resource and 
									   (resource.name == "Ship_IsabelleIsland_PortmasterJenkins" or resource.name == "Ship_IsabelleIsland_Pirate") and
									   resourceType and resourceType.name == "Map"
									then
									   	return true
									end

									return false
								end
							},

							[TARGET] = B.Output.result
						},

						Mashina.Peep.PokeSelf {
							event = "attackShip",
							poke = TARGET
						}
					}
				}
			}
		}
	}
}

return Tree
