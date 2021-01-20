--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RandomDelayEmissionStrategy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local EmissionStrategy = require "ItsyScape.Graphics.EmissionStrategy"

local RandomDelayEmissionStrategy = Class(EmissionStrategy)

function RandomDelayEmissionStrategy:new()
	EmissionStrategy.new(self)

	self:setDelay()
	self.currentDelay = 0
end

function RandomDelayEmissionStrategy:setDelay(min, max)
	self.minDelay = min or 0
	self.maxDelay = max or self.minDelay
	self.currentDelay = math.random() * (self.maxDelay - self.minDelay) + self.minDelay
end

function RandomDelayEmissionStrategy:update(delta, particleSystem)
	EmissionStrategy.update(self, delta, particleSystem)

	if self:running() then
		self.currentDelay = self.currentDelay - delta
		if self.currentDelay <= 0 then
			self.currentDelay = math.random() * (self.maxDelay - self.minDelay) + self.minDelay
			self:emit(particleSystem)
		end
	end
end

return RandomDelayEmissionStrategy
