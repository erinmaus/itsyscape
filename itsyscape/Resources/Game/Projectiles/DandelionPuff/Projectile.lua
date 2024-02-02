--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/DandelionPuff/Projectile.lua
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

local Puff = Class(Projectile)

Puff.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/DandelionPuff/Particle.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.25 },
			speed = { 4, 6 },
			position = { 0, 2.5, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.75, 1.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.5, 0.7 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -180, 180 },
			acceleration = { -120, 120 }
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
		count = { 10, 15 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Puff.DURATION = 2

function Puff:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Puff.PARTICLE_SYSTEM, resources)
end

function Puff:getDuration()
	return Puff.DURATION
end

function Puff:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource())
	end
end

function Puff:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end
end

return Puff
