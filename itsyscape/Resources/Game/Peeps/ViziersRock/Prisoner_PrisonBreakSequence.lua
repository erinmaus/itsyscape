--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/Prisoner_PrisonBreakCommon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Mashina = require "ItsyScape.Mashina"

local GUARD = B.Reference("Prisoner_PrisonBreakCommon", "GUARD")
return Mashina.Try {
	Mashina.Sequence {
		Mashina.Peep.FindNearbyMapObject {
			prop = "Knight2",
			[GUARD] = B.Output.RESULT
		},

		Mashina.Peep.IsAlive {
			peep = GUARD,
		}
	},

	Mashina.Sequence {
		Mashina.Peep.FindNearbyMapObject {
			prop = "Guard1",
			[GUARD] = B.Output.RESULT
		},

		Mashina.Peep.IsAlive {
			peep = GUARD,
		}
	},

	Mashina.Sequence {
		Mashina.Peep.FindNearbyMapObject {
			prop = "Guard2",
			[GUARD] = B.Output.RESULT
		},

		Mashina.Peep.IsAlive {
			peep = GUARD,
		}
	},

	Mashina.Sequence {
		Mashina.Peep.FindNearbyMapObject {
			prop = "Guard3",
			[GUARD] = B.Output.RESULT
		},

		Mashina.Peep.IsAlive {
			peep = GUARD,
		}
	},

	Mashina.Peep.SetState {
		state = "prison-break"
	}
}
