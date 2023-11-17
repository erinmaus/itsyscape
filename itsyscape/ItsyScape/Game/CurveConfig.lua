--------------------------------------------------------------------------------
-- ItsyScape/Game/CurveConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local function evaluate(self, input)
	return math.floor(self.A * input ^ 2 + self.B * input + self.C)
end

local CurveConfig = {
	CombatXP = {
		A = 0.0035,
		B = -0.05,
		C = 8,
		evaluate = evaluate
	},

	HealthXP = {
		A = 0.000025,
		B = 1.25,
		C = 2,
		evaluate = evaluate
	},

	SkillXP = {
		A = 0.0005,
		B = 0.05,
		C = 7.75,
		evaluate = evaluate
	},

	StyleBonus = {
		A = 0.025,
		B = 2,
		C = 10,
		evaluate = evaluate
	},

	StrengthBonus = {
		A = 0.01,
		B = 1.5,
		C = 5,
		evaluate = evaluate
	}
}

return CurveConfig
