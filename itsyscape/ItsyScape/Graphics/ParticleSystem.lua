--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleSystem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local ParticleSystem = Class()
ParticleSystem.DEFAULT_PARTICLES = 50

function ParticleSystem:new(numParticles)
	self.freeParticles = {}
	self.particles = {}
	self:resize(numParticles or ParticleSystem.DEFAULT_PARTICLES)

	self.paths = {}
	self.emitters = {}
	self.emissionStrategy = false
end

function ParticleSystem:addPath(path)
	table.insert(self.paths, path)
end

function ParticleSystem:addEmitter(emitter)
	table.insert(self.emitters, emitter)
end

function ParticleSystem:updateEmittersLocalPosition(localPosition)
	for i = 1, #self.emitters do
		self.emitters[i]:updateLocalPosition(localPosition)
	end
end

function ParticleSystem:setEmissionStrategy(strategy)
	self.emissionStrategy = strategy or false
end

function ParticleSystem:emit(count)
	count = math.min(count, #self.freeParticles)

	while count > 0 do
		local particleIndex = table.remove(self.freeParticles)
		local particle = self.particles[particleIndex]

		for i = 1, #self.emitters do
			self.emitters[i]:emitSingleParticle(particle)
		end

		count = count - 1
	end
end

function ParticleSystem:update(delta)
	if self.emissionStrategy then
		self.emissionStrategy:update(delta, self)
	end

	for i = 1, #self.particles do
		local p = self.particles[i]
		local isAlive = p.age < p.lifetime

		if isAlive then
			p.velocityX = p.velocityX + p.accelerationX * delta
			p.velocityY = p.velocityY + p.accelerationY * delta
			p.velocityZ = p.velocityZ + p.accelerationZ * delta

			p.positionX = p.positionX + p.velocityX * delta
			p.positionY = p.positionY + p.velocityY * delta
			p.positionZ = p.positionZ + p.velocityZ * delta

			p.rotationVelocity = p.rotationVelocity + p.rotationAcceleration * delta

			p.rotation = p.rotation + p.rotationVelocity * delta

			p.age = math.min(p.age + delta, p.lifetime)

			for j = 1, #self.paths do
				self.paths[j]:update(p, delta)
			end
		end
	end
end

function ParticleSystem:length()
	return #self.particles
end

function ParticleSystem:get(index)
	return self.particles[index]
end

function ParticleSystem:resize(numParticles)
	local currentNumParticles = #self.particles
	if numParticles > currentNumParticles then
		local numNewParticles = numParticles - currentNumParticles
		for i = 1, numNewParticles do
			table.insert(self.particles, self:_newParticle())
			table.insert(self.freeParticles, #self.particles)
		end
	else
		Log.error("Can't resize particles to a smaller size.")
	end
end

function ParticleSystem:_newParticle()
	return {
		positionX = 0, positionY = 0, positionZ = 0,
		velocityX = 0, velocityY = 0, velocityZ = 0,
		accelerationX = 0, accelerationY = 0, accelerationZ = 0,
		rotation = 0, rotationAcceleration = 0, rotationVelocity = 0,
		scaleX = 1, scaleY = 1,
		lifetime = 0, age = 0,
		textureIndex = 1,
		colorRed = 1, colorGreen = 1, colorBlue = 1, colorAlpha = 1
	}
end

return ParticleSystem
