--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Particles.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Drawable = require "ItsyScape.UI.Drawable"

local Particles = Class(Drawable)

function Particles:new()
	Drawable.new(self)

	self.currentTextureFilename = false
	self.previousTextureFilename = false
	self.texture = false

	self.particleSystemProperties = {}
	self.isParticleSystemDirty = true

	self.particleSystem = false
	self.emits = {}

	self.tintColor = Color()

	self.overflow = true
	self:setIsClickThrough(true)
end

function Particles:setOverflow(value)
	self.overflow = not not value
end

function Particles:getOverflow()
	return self.overflow
end

function Particles:setTintColor(value)
	self.tintColor = value
end

function Particles:getTintColor()
	return self.tintColor
end

function Particles:setTexture(textureFilename)
	if textureFilename == self.currentTextureFilename then
		return
	end

	self.previousTextureFilename = self.currentTextureFilename
	self.currentTextureFilename = textureFilename
end

function Particles:getTexture()
	return self.currentTextureFilename
end

function Particles:updateParticleSystemProperties(properties)
	if self.particleSystem then
		self:_initParticleSystem(properties)
	else
		table.insert(self.particleSystemProperties, properties)
		self.isParticleSystemDirty = true
	end
end

function Particles:_initParticleSystem(particleSystemProperties)
	local particleSystem = self.particleSystem or love.graphics.newParticleSystem(self.texture)
	particleSystem:setTexture(self.texture)

	for attribute, value in pairs(particleSystemProperties) do
		local setAttributeFunc = particleSystem['set' .. attribute]

		if setAttributeFunc then
			setAttributeFunc(particleSystem, unpack(value))
		else
			Log.error("Attribute '%s' is not a particle attribute.", attribute)
		end
	end

	self.particleSystem = particleSystem
end

function Particles:emit(min, max)
	max = max or min or 100
	min = min or 1

	min, max = math.min(min, max), math.max(min, max)

	local count = love.math.random(min, max)
	if self.particleSystem then
		self.particleSystem:emit(count)
	else
		table.insert(self.emits, count)
	end
end

function Particles:update(delta)
	Drawable.update(self, delta)

	if self.particleSystem then
		self.particleSystem:update(delta)

		for _, count in ipairs(self.emits) do
			self.particleSystem:emit(count)
		end
		table.clear(self.emits)
	end
end

function Particles:draw(resources, state)
	if self.previousTextureFilename ~= self.currentTextureFilename then
		self.texture = false

		if self.currentTextureFilename then
			self.texture = resources:load(love.graphics.newImage, self.currentTextureFilename)
			self.previousTextureFilename = self.currentTextureFilename
		end
	end

	if not self.texture then
		return
	end

	if self.isParticleSystemDirty then
		for _, properties in ipairs(self.particleSystemProperties) do
			self:_initParticleSystem(properties)
		end
		table.clear(self.particleSystemProperties)

		self.isParticleSystemDirty = false
	end

	love.graphics.push("all")
	if not self:getOverflow() then
		itsyrealm.graphics.applyPseudoScissor()
	end

	love.graphics.setColor(self.tintColor:get())
	itsyrealm.graphics.uncachedDraw(self.particleSystem)

	if not self:getOverflow() then
		itsyrealm.graphics.resetPseudoScissor()
	end
	love.graphics.pop()
end

return Particles
