--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AttackLogic.lua
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
	Mashina.ParallelTry {
		Mashina.Peep.Sequence {
			Mashina.Peep.HasTarget {
				[TARGET] = B.Output.target
			},

			Mashina.Check {
				condition = function(_, state)
					local target = state[TARGET]
					local target = peep:getDirector():probe(
						target:getLayerName(),
						Probe.hasTarget(target))

					return #hits == 1
				end
			},

			Mashina.Peep.Interrupt {
				queue = CombatCortex2.QUEUE
			},

			Mashina.Peep.DisengageCombatTarget,

			Mashina.Peep.SetState {
				state = "idle"
			}
		}
	},

	Mashina.Peep.DidAttack
}
