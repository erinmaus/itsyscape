--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/WaterBlast/Projectile.lua
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

local WaterBlast = Class(Projectile)

WaterBlast.PARTICLE_SYSTEM = {
	numParticles = 80,
	texture = "Resources/Game/Projectiles/WaterBlast/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.5 },
			speed = { 2, 2.5 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("B8EBE6"):get() },
				{ Color.fromHexString("5FBCD3"):get() },
				{ Color.fromHexString("5FBCD3"):get() },
				{ Color.fromHexString("5FBCD3"):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.35, 0.45 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.4, 0.6 }
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
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 6, 12 },
		delay = { 0.125 },
		duration = { math.huge }
	}
}

WaterBlast.SPEED = 5

function WaterBlast:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function WaterBlast:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(WaterBlast.PARTICLE_SYSTEM, resources)

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(Color.fromHexString("5FBCD3"))
end

function WaterBlast:getDuration()
	return self.duration
end

function WaterBlast:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)

		local hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)
		self.duration = math.max((self.spawnPosition - hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function WaterBlast:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local rotation = Quaternion.lookAt(self.spawnPosition, hitPosition)

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local lookRotation = Quaternion.lookAt(self.spawnPosition, hitPosition)
		local rotation = lookRotation * xRotation

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)

		self.particleSystem:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.light:setAttenuation((1 - alpha) * 3 + 2)
	end
end

return WaterBlast
