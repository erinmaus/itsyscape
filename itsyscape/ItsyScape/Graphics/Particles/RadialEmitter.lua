--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RadialEmitter.lua
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

local RadialEmitter = Class(ParticleEmitter)

function RadialEmitter:new()
	ParticleEmitter.new(self)
	self:setRadius()
	self:setSpeed()
	self:setAcceleration()
end

function RadialEmitter:setRadius(min, max)
	self.minRadius = min or 0
	self.maxRadius = max or 1
end

function RadialEmitter:setSpeed(min, max)
	self.minSpeed = min or 0
	self.maxSpeed = max or min or self.minSpeed
end

function RadialEmitter:setAcceleration(min, max)
	self.minAcceleration = min or 0
	self.maxAcceleration = max or min or self.minAcceleration
end

function RadialEmitter:emitSingleParticle(particle)
	local normal = Vector(
		math.random() *  2 - 1,
		math.random() *  2 - 1,
		math.random() *  2 - 1)
	local radius = math.random() * (self.maxRadius - self.minRadius) + self.minRadius
	local velocity = math.random() * (self.maxSpeed - self.minSpeed) + self.minSpeed
	local acceleration = math.random() * (self.maxAcceleration - self.minAcceleration) + self.minAcceleration

	particle.positionX = normal.x * radius
	particle.positionY = normal.y * radius
	particle.positionZ = normal.z * radius

	particle.velocityX = normal.x * velocity
	particle.velocityY = normal.y * velocity
	particle.velocityZ = normal.z * velocity

	particle.accelerationX = normal.x * acceleration
	particle.accelerationY = normal.y * acceleration
	particle.accelerationZ = normal.z * acceleration
end

return RadialEmitter
