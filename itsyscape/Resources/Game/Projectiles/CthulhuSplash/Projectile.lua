--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/CthulhuSplash/Projectile.lua
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

Splash.PARTICLE_SYSTEM = {
	numParticles = 300,
	texture = "Resources/Game/Projectiles/CthulhuSplash/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 10 },
			speed = { 10, 12 },
			yRange = { 0, 0.25 }
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
		},
		{
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 50, 100 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Splash.DURATION = 1.5

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
	end
end

return Splash
