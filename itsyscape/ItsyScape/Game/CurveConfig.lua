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

local function solvePlus(self, c)
	return math.floor((-self.B + math.sqrt(self.B ^ 2 - 4 * self.A * (self.C - c))) / (2 * self.A))
end

local function solveMinus(self, c)
	return math.floor((-self.B - math.sqrt(self.B ^ 2 - 4 * self.A * (self.C - c))) / (2 * self.A))
end

local CurveConfig = {
	CombatXP = {
		A = 0.0035,
		B = -0.05,
		C = 8,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	},

	HealthXP = {
		A = 0.000025,
		B = 1.25,
		C = 2,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	},

	SkillXP = {
		A = 0.0005,
		B = 0.05,
		C = 7.75,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	},

	StyleBonus = {
		A = 0.025,
		B = 2,
		C = 10,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	},

	StrengthBonus = {
		A = 0.01,
		B = 1.5,
		C = 5,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	},

	ArmorDamageReduction = {
		A = 0.009,
		B = 1.25,
		C = 10,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	},

	DefenseDamageReduction = {
		A = 0.002,
		B = 0.07,
		C = -0.025,
		evaluate = evaluate,
		solveMinus = solveMinus,
		solvePlus = solvePlus
	}
}

return CurveConfig
