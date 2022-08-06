--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_BindShadow/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local BindShadow = Class(Projectile)

BindShadow.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/SnipeSplosion/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 1 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 3, 6 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.0, 0.0, 0.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.25 }
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
			type = "SizePath",
			fadeInPercent = { 0 },
			fadeOutPercent = { 0.8 },
			size = { 0.5 },
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

BindShadow.DURATION = 1.5

function BindShadow:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(BindShadow.PARTICLE_SYSTEM, resources)
end

function BindShadow:getDuration()
	return BindShadow.DURATION
end

function BindShadow:tick()
	if not self.spawnPosition then
		local destination = self:getDestination()

		local min, max = destination:getBounds()
		self.spawnPosition = Vector(
			(max.x - min.x) / 2 + min.x,
			min.y - 1,
			(max.z - min.z) / 2 + min.z)
	end
end

function BindShadow:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)
	end
end

return BindShadow
