--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AggressiveIdleLogic.lua
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
local CombatCortex2 = require "ItsyScape.Peep.Cortexes.CombatCortex2"

local TARGET = B.Reference("Tutorial_Yenderhound_AggressiveIdleLogic", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Try {	
		Mashina.Sequence {
			Mashina.Peep.FindNearbyCombatTarget {
				distance = 8,

				-- We don't want to gang up on a potential target in the tutorial.
				filter = function(peep)
					local hits = peep:getDirector():probe(
						peep:getLayerName(),
						Probe.hasTarget(peep))

					return #hits == 0
				end,

				[TARGET] = B.Output.RESULT
			},

			Mashina.Peep.Interrupt {
				queue = CombatCortex2.QUEUE
			},

			-- Mashina.Peep.PlayAnimation {
			-- 	animation = "Dog_Bark"
			-- },

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET
			},

			Mashina.Peep.SetState {
				state = "attack"
			}
		},

		Mashina.Sequence {
			Mashina.Check {
				condition = TARGET
			},

			Mashina.Peep.EngageCombatTarget {
				peep = TARGET
			},

			Mashina.Peep.SetState {
				state = "attack"
			}
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Navigation.Wander,
				Mashina.Peep.Wait
			}
		}
	}
}

return Tree
