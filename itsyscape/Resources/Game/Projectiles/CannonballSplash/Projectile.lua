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
			radius = { 0, 0.15 },
			position = { 0, 0.1, 0 },
			yRange = { 0, 0 },
			lifetime = { 1.25, 0.15 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.45, 0.45 },
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
		duration = { 0.25 }
	}
}

Splash.OUTER_SPLASH = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/CannonballSplash/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 0.25 },
			position = { 0, 0, 0 },
			yRange = { 0, 0 },
			lifetime = { 1.5, 0.4 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.45, 0.45 },
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
		duration = { 0.25 }
	}
}

Splash.DURATION = 3

function Splash:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Splash.PARTICLE_SYSTEM, resources)
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
