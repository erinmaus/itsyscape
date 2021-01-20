--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/BurstEmissionStrategy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local EmissionStrategy = require "ItsyScape.Graphics.EmissionStrategy"

local BurstEmissionStrategy = Class(EmissionStrategy)

function BurstEmissionStrategy:new()
	EmissionStrategy.new(self)

	self:setDelay()
end

function BurstEmissionStrategy:setDelay(min, max)
	min = min or 0
	max = max or min

	self.delay = math.random() * (max - min) + min
end

function BurstEmissionStrategy:update(delta, particleSystem)
	EmissionStrategy.update(self, delta, particleSystem)

	local previousDelay = self.delay
	local currentDelay = previousDelay - delta

	if self:running() and currentDelay < 0 and previousDelay > 0 then
		self:emit(particleSystem)
	end

	self.delay = currentDelay
end

return BurstEmissionStrategy
