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
local Probe = require "ItsyScape.Peep.Probe"

local TARGET_FIRE = B.Reference("Tutorial_Orlando_ChopLogic", "TARGET_FIRE")

local ITEMS_TO_KEEP = {
	["TerrifyingFishingRod"] = true,
	["Tinderbox"] = true,
	["ItsyHatchet"] = true
}

local Tree = BTreeBuilder.Node() {
	Mashina.Step {
		Mashina.Success {
			Mashina.Step {
				Mashina.Skills.GatherNearbyResource {
					action = "Chop",
					resource = "BalsaLogs"
				},

				Mashina.Peep.Wait,

				Mashina.Peep.TimeOut {
					duration = 1
				},

				Mashina.Peep.PokeInventoryItem {
					action  = "Light",
					item = "BalsaLogs"
				},

				Mashina.Peep.Wait,

				Mashina.Peep.FindNearbyPeep {
					filter = Probe.resource("Prop", "BalsaFire"),
					[TARGET_FIRE] = B.Output.result
				},

				Mashina.Peep.PokeOther {
					peep = TARGET_FIRE,
					event = "tweakDuration",
					poke = math.huge
				},

				Mashina.Peep.TimeOut {
					duration = 1
				},

				Mashina.Repeat {
					Mashina.Step {
						Mashina.Peep.DropInventoryItem {
							count = 1,
							item = function(item)
								return not ITEMS_TO_KEEP[item:getID()]
							end
						},

						Mashina.Peep.TimeOut {
							duration = 1
						}
					}
				}
			}
		},

		Mashina.Peep.SetState {
			state = "tutorial-follow-player"
		}
	}
}

return Tree
