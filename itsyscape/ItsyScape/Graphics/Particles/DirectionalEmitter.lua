--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/DirectionalEmitter.lua
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

local DirectionalEmitter = Class(ParticleEmitter)

function DirectionalEmitter:new()
	ParticleEmitter.new(self)
	self:setDirection()
	self:setSpeed()
end

function DirectionalEmitter:setDirection(x, y, z)
	self.direction = Vector(x, y, z):getNormal()
end

function DirectionalEmitter:setSpeed(min, max)
	self.minSpeed = min or 0
	self.maxSpeed = max or self.minSpeed
end

function DirectionalEmitter:emitSingleParticle(particle)
	local speed = math.random() * (self.maxSpeed - self.minSpeed) + self.minSpeed
	particle.velocityX = self.direction.x * speed
	particle.velocityY = self.direction.y * speed
	particle.velocityZ = self.direction.z * speed
end

return DirectionalEmitter
