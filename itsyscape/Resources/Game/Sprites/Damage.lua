--------------------------------------------------------------------------------
-- Resources/Game/Sprites/Damage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Damage = Class(Sprite)
Damage.SPRING_TIME = 0.25
Damage.LIFE = 1
Damage.PARTICLES = {
	['none'] = {
		{
			EmissionArea = { 'none', 0, 0 },
			Direction = { math.rad(180) },
			Spread = { math.rad(20) },
			LinearAcceleration = { 0, 32, 0, 48 },
			ParticleLifetime = { 0.5, 1 },
			Sizes = { 1, 0.5 },
			Speed = { 32, 128 },
			Rotation = { math.rad(0), math.rad(360) },
			Colors = {
				{ 1, 0.15, 0.15, 0 },
				{ 1, 0.15, 0.15, 1 },
				{ 0.8, 0.15, 0.15, 1 },
				{ 0.7, 0.2, 0.2, 1 },
				{ 0.7, 0.2, 0.2, 0 },
			},

			min = 25,
			max = 200
		},
		{
			EmissionArea = { 'none', 0, 0 },
			Direction = { math.rad(190) },
			Spread = { math.rad(10) },
			LinearAcceleration = { 0, 32, 0, 48 },
			ParticleLifetime = { 0.5, 0.75 },
			Sizes = { 0.75, 0.25 },
			Speed = { 64, 96 },
			Colors = {
				{ 0.5, 0.15, 0.15, 0 },
				{ 0.5, 0.25, 0.25, 1 },
				{ 0.5, 0.25, 0.25, 1 },
				{ 0.5, 0.25, 0.25, 0 }
			},

			min = 15,
			max = 80
		},
		{
			EmissionArea = { 'none', 0, 0 },
			Direction = { math.rad(135) },
			Spread = { math.rad(45) },
			LinearAcceleration = { 0, 48, 0, 64 },
			ParticleLifetime = { 0.5, 1 },
			Sizes = { 0.5, 0.0 },
			Speed = { 160, 196 },
			Colors = {
				{ 0.8, 0.25, 0.25, 1 }
			},

			min = 5,
			max = 20
		},

		x = 48,
		y = 16
	},
	['heal'] = {
		{
			EmissionArea = { 'ellipse', 8, 1 },
			Direction = { math.rad(0) },
			Spread = { math.rad(90) },
			LinearAcceleration = { 0, -128, 0, -160 },
			ParticleLifetime = { 0.5, 1 },
			Sizes = { 1, 0 },
			Speed = { -16, -32 },
			Colors = {
				{ 1, 1, 1, 0 },
				{ 1, 1, 1, 1 },
				{ 1, 1, 1, 1 },
				{ 1, 1, 1, 0 }
			},

			min = 20,
			max = 40
		},
		x = 8,
		y = 16
	},
	['block'] = {
		{
			EmissionArea = { 'ellipse', 8, 1 },
			Spread = { math.rad(360) },
			RadialAcceleration = { math.rad(0), math.rad(360) },
			ParticleLifetime = { 0.5, 1 },
			Sizes = { 0, 1 },
			Speed = { -16, -32 },
			Colors = {
				{ 1, 1, 1, 0 },
				{ 1, 1, 1, 1 },
				{ 1, 1, 1, 1 },
				{ 1, 1, 1, 0 }
			},

			min = 20,
			max = 20
		},
		x = 8,
		y = 16
	}
}

Damage.MIN_PARTICLES = 30
Damage.MAX_PARTICLES = 100

function Damage:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@24",
		function(font)
			self.font = font
		end)

	self.ready = false
end

function Damage:spawn(damageType, damage)
	self.damage = damage
	self.damageType = damageType or 'none'

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		TextureResource,
		string.format("Resources/Game/Sprites/Damage/%s.png", self.damageType),
		function(texture)
			self.texture = texture:getResource()

			local particleSystems = Damage.PARTICLES[self.damageType] or Damage.PARTICLES['none']
			local scale = math.min(math.max(self.damage / 100, 0), 1)

			self.particleSystems = {}
			for i = 1, #particleSystems do
				local particleSystem = love.graphics.newParticleSystem(
					self.texture, particleSystems.max)

				for attribute, value in pairs(particleSystems[i]) do
					local setAttributeFunc = particleSystem['set' .. attribute]

					if setAttributeFunc then
						setAttributeFunc(particleSystem, unpack(value))
					end
				end

				local scaledMinParticles = math.max(math.random() * scale, particleSystems[i].min)
				local scaledMaxParticles = particleSystems[i].max * scale
				local numParticles = math.random(scaledMinParticles, scaledMaxParticles)
				particleSystem:emit(numParticles)

				table.insert(self.particleSystems, particleSystem)
			end

			self.offsetX = particleSystems.x
			self.offsetY = particleSystems.y
		end)
	resources:queueEvent(function()
		self.ready = true
	end)
end

function Damage:isDone(time)
	return time > Damage.LIFE
end

function Damage:draw(position, time)
	if not self.ready then
		return
	end

	local delta
	do
		local previousTime = self.time or time
		self.time = time

		delta = time - previousTime
	end

	if self.particleSystems then
		for i = 1, #self.particleSystems do
			local particleSystem = self.particleSystems[i]
			particleSystem:update(delta)

			love.graphics.draw(particleSystem, position.x + self.offsetX, position.y + self.offsetY)
		end
	end

	local font = self.font:getResource()
	local text = tostring(self.damage)

	love.graphics.setFont(font)
	do
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.printf(
			text,
			position.x + 2,
			position.y + 2,
			font:getWidth(text),
			'center')
	end

	do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(
			text,
			position.x,
			position.y,
			font:getWidth(text),
			'center')
	end
end

return Damage
