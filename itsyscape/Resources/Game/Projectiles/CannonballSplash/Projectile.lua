--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/CannonballSplash/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Splash = Class(Projectile)

Splash.INNER_SPLASH = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/CannonballSplash/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 1 },
			position = { 0, 0.1, 0 },
			yRange = { 0, 0 },
			lifetime = { 2, 1 },
			normal = { true }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 10, 13 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("87CDDE", 0):get() },
				{ Color.fromHexString("87CDDE", 0):get() },
				{ Color.fromHexString("FFFFFF", 0):get() },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1.25 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 60, 120 }
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
		},
		{
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 5, 10 },
		delay = { 1 / 10 },
		duration = { 1 }
	}
}

Splash.OUTER_SPLASH = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/CannonballSplash/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 2 },
			position = { 0, 0, 0 },
			yRange = { 0, 0 },
			lifetime = { 1, 0.5 },
			normal = { true }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 7, 11 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("87CDDE", 0):get() },
				{ Color.fromHexString("87CDDE", 0):get() },
				{ Color.fromHexString("FFFFFF", 0):get() },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1.25 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 60, 120 }
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
		},
		{
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 5, 10 },
		delay = { 1 / 10 },
		duration = { 1 }
	}
}

Splash.DURATION = 10

function Splash:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.innerParticleSystem = ParticleSceneNode()
	self.innerParticleSystem:setParent(root)
	self.innerParticleSystem:initParticleSystemFromDef(Splash.INNER_SPLASH, resources)
	self.innerParticleSystem:getMaterial():setIsFullLit(false)

	self.outerParticleSystem = ParticleSceneNode()
	self.outerParticleSystem:setParent(root)
	self.outerParticleSystem:initParticleSystemFromDef(Splash.OUTER_SPLASH, resources)
	self.outerParticleSystem:getMaterial():setIsFullLit(false)
end

function Splash:getDuration()
	return Splash.DURATION
end

function Splash:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function Splash:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end
end

return Splash
