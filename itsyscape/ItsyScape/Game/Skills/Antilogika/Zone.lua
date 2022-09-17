--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Zone.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local Zone = Class()

function Zone:new()
	self.curve = love.math.newBezierCurve(
		-1.0, -1.0,
		-1.0, 1.0,
		-1.0, 1.0,
		1.0, 1.0)
	self.amplitude = 4
end

function Zone:sample(x, y, z, w)
	local noise = NoiseBuilder.TERRAIN:sample4D(x or 0, y or 0, z or 0, w or 0)
	local clampedNoise = (noise + 1) / 2
	if clampedNoise > 1 then
		print('c', clampedNoise)
		c = 1
	elseif clampedNoise < 0 then
		print('<', clampedNoise)
		c = 0
	end

	return math.abs(self.curve:evaluate(clampedNoise)) * self.amplitude
end

return Zone
