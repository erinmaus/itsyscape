--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/EarthBlast/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"

local EarthBlast = Class(Projectile)
EarthBlast.SPEED = 5

EarthBlast.PARTICLE_SYSTEM = {
	numParticles = 80,
	texture = "Resources/Game/Projectiles/EarthBlast/Particle.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.25 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 0, -1 },
			speed = { 2.5, 3.5 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color(0.67, 0.78, 0.21):get() },
				{ Color(0.67, 0.78, 0.21):get() },
				{ Color(0.67, 0.78, 0.21):get() },
				{ Color(0.67, 0.78, 0.21):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 1.0, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.6, 0.8 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 30, 60 },
			acceleration = { -40, -20 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 4, 6 },
		delay = { 1 / 20 },
		duration = { math.huge }
	}
}

function EarthBlast:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function EarthBlast:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)
	self.quad:getTransform():setLocalScale(Vector(1.5))

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(EarthBlast.PARTICLE_SYSTEM, resources)

	self.light = PointLightSceneNode()
	self.light:setParent(self.quad)
	self.light:setColor(Color(0.67, 0.78, 0.21))

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/EarthBlast/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function EarthBlast:getDuration()
	return self.duration
end

function EarthBlast:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = (self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)):keep()
		self.hitPosition = (self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)):keep()

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function EarthBlast:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.hitPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(self.hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * 2 * self:getTime())
		local lookRotation = Quaternion.lookAt(self.spawnPosition, self.hitPosition)
		local rotation = lookRotation * yRotation * xRotation

		self.quad:getTransform():setLocalTranslation(position)
		self.quad:getTransform():setLocalRotation(rotation)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.particleSystem:getMaterial():setColor(Color(1, 1, 1, alpha))

		if self.particleSystem:getIsReady() then
			self.particleSystem:updateLocalPosition(position)
		end

		self.light:setAttenuation((1 - alpha) * 3 + 2)

		self:ready()
	end
end

return EarthBlast
