--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SimpleParticleEmitter.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local ParticleEmitter = require "ItsyScape.Graphics.ParticleEmitter"
local SphericalParticleShape = require "ItsyScape.Graphics.SphericalParticleShape"

local SimpleParticleEmitter = Class(ParticleEmitter)

function SimpleParticleEmitter:new(shape, anchor)
	ParticleEmitter.new(self)

	self.shape = shape or SphericalParticleShape()
	self.anchor = anchor or Vector.ZERO

	self:setLifetime()
	self:setColor(1, 1, 1, 1)
	self:setSpeed()
	self:setDirection()
end

function SimpleParticleEmitter:emitSingleParticle(particle)
	ParticleEmitter.emitSingleParticle(self, particle)

	local x, y, z = (self.shape:getPosition() + self:getAnchor()):get()
	particle.positionX = x
	particle.positionY = y
	particle.positionZ = z

	particle.lifetime = math.random() * (self.maxLifetime - self.minLifetime) + self.minLifetime

	local speed = math.random() * (self.maxSpeed - self.minSpeed) + self.minSpeed
	particle.velocityX, particle.velocityY, particle.velocityZ = (speed * self.direction):get()

	particle.colorRed, particle.colorGreen, particle.colorBlue, particle.colorAlpha = self.color:get()
end

function SimpleParticleEmitter:setAnchor(value)
	self.anchor = anchor or self.anchor
end

function SimpleParticleEmitter:getAnchor()
	return self.anchor
end

function SimpleParticleEmitter:setLifetime(min, max)
	self.minLifetime = min or 0
	self.maxLifetime = max or 1
end

function SimpleParticleEmitter:getLifetime()
	return self.minLifetime, self.maxLifetime
end

function SimpleParticleEmitter:setColor(red, green, blue, alpha)
	self.color = Color(red, green, blue, alpha)
end

function SimpleParticleEmitter:getColor()
	return self.color
end

function SimpleParticleEmitter:setSpeed(min, max)
	self.minSpeed = min or 0
	self.maxSpeed = max or 0
end

function SimpleParticleEmitter:getSpeed()
	return self.minSpeed, self.maxSpeed
end

function SimpleParticleEmitter:setDirection(x, y, z)
	self.direction = Vector(x, y, z)
end

function SimpleParticleEmitter:getDirection()
	return self.direction
end

return SimpleParticleEmitter
