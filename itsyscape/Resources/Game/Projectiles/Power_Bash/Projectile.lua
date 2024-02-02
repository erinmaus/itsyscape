--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Bash/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Bash = Class(Projectile)

Bash.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/Power_Bash/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 2, 3 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.5, 0.75 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -180, 180 }
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
			type = "GravityPath",
			gravity = { 0, -5, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 15 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Bash.DURATION = 1.5

function Bash:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Bash.PARTICLE_SYSTEM, resources)
end

function Bash:getDuration()
	return Bash.DURATION
end

function Bash:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function Bash:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end
end

return Bash
