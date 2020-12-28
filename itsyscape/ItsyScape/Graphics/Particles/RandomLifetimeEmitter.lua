--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RandomLifetimeEmitter.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ParticleEmitter = require "ItsyScape.Graphics.ParticleEmitter"

local RandomLifetimeEmitter = Class(ParticleEmitter)

function RandomLifetimeEmitter:new()
	ParticleEmitter.new(self)
	self:setLifetime()
end

function RandomLifetimeEmitter:setLifetime(min, max)
	self.minLifetime = min or 1
	self.maxLifetime = max or self.minLifetime
end

function RandomLifetimeEmitter:emitSingleParticle(particle)
	local lifetime = math.random() * (self.maxLifetime - self.minLifetime) + self.minLifetime

	particle.lifetime = lifetime
end

return RandomLifetimeEmitter
