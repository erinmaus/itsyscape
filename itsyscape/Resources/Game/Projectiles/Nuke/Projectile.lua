--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Nuke/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Nuke = Class(Projectile)

Nuke.PARTICLE_SYSTEM_TOP = {
	numParticles = 200,
	texture = "Resources/Game/Projectiles/Nuke/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 6, 8 },
			acceleration = { 0, 0 },
			yRange = { 0, 0.55 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1.5 }
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
		count = { 50, 75 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Nuke.PARTICLE_SYSTEM_BOTTOM = {
	numParticles = 200,
	texture = "Resources/Game/Projectiles/Nuke/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 2 },
			speed = { 0, 0 },
			acceleration = { 0, 0 },
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 4, 6 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1.5 }
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
		count = { 50, 75 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Nuke.DURATION = 2.5
Nuke.SPAWN_MUSHROOM_TOP_TIME = 0.4

function Nuke:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystemTop = ParticleSceneNode()
	self.particleSystemTop:initParticleSystemFromDef(Nuke.PARTICLE_SYSTEM_TOP, resources)
	self.particleSystemTop:getTransform():setLocalTranslation(Vector.UNIT_Y * 8)

	self.particleSystemBottom = ParticleSceneNode()
	self.particleSystemBottom:setParent(root)
	self.particleSystemBottom:initParticleSystemFromDef(Nuke.PARTICLE_SYSTEM_BOTTOM, resources)
end

function Nuke:getDuration()
	return Nuke.DURATION
end

function Nuke:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function Nuke:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		if self:getTime() > Nuke.SPAWN_MUSHROOM_TOP_TIME and
		   not self.particleSystemTop:getParent()
		then
			self.particleSystemTop:setParent(root)
		end
	end
end

return Nuke
