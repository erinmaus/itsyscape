--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Scripts/Rosalind.lua
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

local TARGET = B.Reference("Rosalind", "TARGET")

local Tree = BTreeBuilder.Node() {
	Mashina.Repeat {
		Mashina.Peep.FindNearbyCombatTarget {
			include_npcs = true,
			same_layer = false,
			distance = math.huge,

			filters = {
				Probe.resource("Peep", "IsabelleIsland_Port_UndeadSquid")
			},

			[TARGET] = B.Output.result
		},

		Mashina.Peep.EngageCombatTarget {
			peep = TARGET
		}
	}
}

return Tree
