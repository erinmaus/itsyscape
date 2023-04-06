--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/FireStrike/Projectile.lua
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

local FireStrike = Class(Projectile)

FireStrike.FIRE_PARTICLE_SYSTEM = {
	numParticles = 100,
	texture = "Resources/Game/Projectiles/FireStrike/Fire.png",
	columns = 4,

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
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 1.0, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.3, 0.4 }
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
		count = { 4, 6 },
		delay = { 1 / 30 },
		duration = { math.huge }
	}
}

FireStrike.SMOKE_PARTICLE_SYSTEM = {
	numParticles = 40,
	texture = "Resources/Game/Projectiles/FireStrike/Smoke.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.125 },
			speed = { 2, 3 },
			acceleration = { -1, -2 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.5, 1.5 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.5, 0.4, 0.4 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 1.0, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.6, 0.7 }
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
		count = { 2, 4 },
		delay = { 1 / 30 },
		duration = { 2 }
	}
}

FireStrike.SPEED = 6

function FireStrike:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function FireStrike:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.fireParticleSystem = ParticleSceneNode()
	self.fireParticleSystem:setParent(root)
	self.fireParticleSystem:initParticleSystemFromDef(FireStrike.FIRE_PARTICLE_SYSTEM, resources)

	self.smokeParticleSystem = ParticleSceneNode()
	self.smokeParticleSystem:setParent(root)
	self.smokeParticleSystem:initParticleSystemFromDef(FireStrike.SMOKE_PARTICLE_SYSTEM, resources)

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(Color(1, 0.4, 0.0))
end

function FireStrike:getDuration()
	return self.duration
end

function FireStrike:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)

		local hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)
		self.duration = math.max((self.spawnPosition - hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function FireStrike:update(elapsed)
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

		local fireParticleSystem = self.fireParticleSystem:getParticleSystem()
		if fireParticleSystem then
			fireParticleSystem:updateEmittersLocalPosition(position)
		end

		local smokeParticleSystem = self.smokeParticleSystem:getParticleSystem()
		if smokeParticleSystem then
			smokeParticleSystem:updateEmittersLocalPosition(position + Vector.UNIT_Y)
		end

		self.fireParticleSystem:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.smokeParticleSystem:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.light:setAttenuation((1 - alpha) * 3 + 2)
	end
end

return FireStrike
