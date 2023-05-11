--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RandomRotationEmitter.lua
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

local RandomRotationEmitter = Class(ParticleEmitter)

function RandomRotationEmitter:new()
	ParticleEmitter.new(self)
	self:setRotation()
	self:setAcceleration()
	self:setVelocity()
end

function RandomRotationEmitter:setRotation(min, max)
	self.minRotation = math.rad(min or 0)
	self.maxRotation = math.rad(max or 0)
end

function RandomRotationEmitter:setAcceleration(min, max)
	self.minAcceleration = math.rad(min or 0)
	self.maxAcceleration = math.rad(max or 0)
end

function RandomRotationEmitter:setVelocity(min, max)
	self.minVelocity = math.rad(min or 0)
	self.maxVelocity = math.rad(max or 0)
end

function RandomRotationEmitter:emitSingleParticle(particle)
	local rotation = math.random() * (self.maxRotation - self.minRotation) + self.minRotation
	local acceleration = math.random() * (self.maxAcceleration - self.minAcceleration) + self.minAcceleration
	local velocity = math.random() * (self.maxVelocity - self.minVelocity) + self.minVelocity

	particle.rotation = rotation
	particle.rotationVelocity = velocity
	particle.rotationAcceleration = acceleration
end

return RandomRotationEmitter
