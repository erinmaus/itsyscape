--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Tinkerer_BoneBlast/Projectile.lua
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

local BoneBlast = Class(Projectile)

BoneBlast.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/Tinkerer_BoneBlast/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 1 },
			speed = { 0 },
			acceleration = { 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 }, 
			speed = { 5, 7 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.5, 1.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.45 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { -45, -45 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.3 },
			fadeOutPercent = { 0.95 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "GravityPath",
			gravity = { 0, -15, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 15 },
		delay = { 1 / 16 },
		duration = { 0.75 }
	}
}

BoneBlast.DURATION = 2

function BoneBlast:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(BoneBlast.PARTICLE_SYSTEM, resources)
end

function BoneBlast:getDuration()
	return BoneBlast.DURATION
end

function BoneBlast:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function BoneBlast:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end
end

return BoneBlast
