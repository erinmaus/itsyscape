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

		Mashina.Peep.TimeOut {
			min_duration = 2,
			max_duration = 4
		},

		Mashina.Repeat {
			Mashina.Step {
				Mashina.Peep.TimeOut {
					min_duration = 2,
					max_duration = 4
				},

				Mashina.Peep.PokeSelf {
					event = "attackShip"
				}
			}
		}
	}
}

return Tree
