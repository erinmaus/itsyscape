--------------------------------------------------------------------------------
-- ItsyScape/Graphics/EmissionStrategy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local EmissionStrategy = Class()

function EmissionStrategy:new()
	self:setDuration()
	self:setCount()

	self.time = 0
end

function EmissionStrategy:setCount(min, max)
	min = min or 1
	max = max or min

	self.minCount = math.min(min, max)
	self.maxCount = math.max(min, max)
end

function EmissionStrategy:rollCount()
	return math.random(self.minCount, self.maxCount)
end

function EmissionStrategy:emit(particleSystem)
	particleSystem:emit(self:rollCount())
end

function EmissionStrategy:setDuration(min, max)
	min = min or 1
	max = max or min

	if min == math.huge or max == math.huge then
		self.duration = math.huge
	else
		self.duration = math.random() * (max - min) + min
	end
end

function EmissionStrategy:update(delta, particleSystem)
	self.time = self.time + delta
end

function EmissionStrategy:getTime()
	return self.time
end

function EmissionStrategy:running()
	return self.time <= self.duration
end

return EmissionStrategy
