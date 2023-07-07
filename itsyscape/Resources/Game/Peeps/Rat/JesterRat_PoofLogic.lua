--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Rat/JesterRat_PoofLogic.lua
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
		Mashina.Peep.PlayAnimation {
			filename = "Resources/Game/Animations/FX_Despawn/Script.lua",
			priority = math.huge,
			force = true
		},

		Mashina.Peep.TimeOut {
			duration = 1
		},

		Mashina.Peep.PokeSelf {
			event = 'despawn'
		}
	}
}

return Tree
