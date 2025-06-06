--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MagmaJellyfishSplosion/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Splosion = Class(Projectile)

Splosion.PARTICLE_SYSTEM_FIRE = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/MagmaJellyfishSplosion/Particle_Fire.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 3, 4 },
			acceleration = { 0, 0 }
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
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.3 },
			fadeOutPercent = { 0.7 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 30, 50 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Splosion.PARTICLE_SYSTEM_SMOKE = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/MagmaJellyfishSplosion/Particle_Smoke.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 3, 4 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.3 },
			fadeOutPercent = { 0.7 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 30, 50 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Splosion.DURATION = 1.5

function Splosion:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystemFire = ParticleSceneNode()
	self.particleSystemFire:setParent(root)
	self.particleSystemFire:initParticleSystemFromDef(Splosion.PARTICLE_SYSTEM_FIRE, resources)

	self.particleSystemSmoke = ParticleSceneNode()
	self.particleSystemSmoke:setParent(root)
	self.particleSystemSmoke:initParticleSystemFromDef(Splosion.PARTICLE_SYSTEM_SMOKE, resources)
end

function Splosion:getDuration()
	return Splosion.DURATION
end

function Splosion:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function Splosion:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)
		root:getTransform():setPreviousTransform(self.spawnPosition)

		self:ready()
	end
end

return Splosion
