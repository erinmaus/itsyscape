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
Zone.DEFAULT_CURVE = {
	0.0, 0.0,
	0.5, 0.5,
	1.0, 1.0
}

function Zone:new(t)
	t = t or {}

	self.curve = love.math.newBezierCurve(unpack(t.curve or Zone.DEFAULT_CURVE))
	self.amplitude = t.amplitude or 1
	self.tileSetID = t.tileSetID or "Draft"
end

function Zone:getCurve()
	return self.curve
end

function Zone:getAmplitude()
	return self.amplitude
end

function Zone:getTileSetID()
	return self.tileSetID
end

function Zone:sample(x, y, z, w)
	local noise = NoiseBuilder.TERRAIN:sample4D(x or 0, y or 0, z or 0, w or 0)
	local clampedNoise = math.min(math.max((noise + 1) / 2, 0), 1)

	return math.abs(self.curve:evaluate(clampedNoise)) * self.amplitude
end

return Zone
