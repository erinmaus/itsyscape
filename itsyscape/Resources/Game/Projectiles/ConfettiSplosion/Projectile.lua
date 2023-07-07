--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/ConfettiSplosion/Projectile.lua
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

local Splosion = Class(Projectile)

Splosion.PARTICLE_SYSTEM = {
	numParticles = 200,
	texture = "Resources/Game/Projectiles/ConfettiSplosion/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 5, 6 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("ffcc00", 0):get() },
				{ Color.fromHexString("c83737", 0):get() },
				{ Color.fromHexString("bcd35f", 0):get() },
				{ Color.fromHexString("80e5ff", 0):get() },
				{ Color.fromHexString("bc5fd3", 0):get() }
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
			type = "GravityPath",
			gravity = { 0, -10, 0 }
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

Splosion.DURATION = 1.5

function Splosion:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Splosion.PARTICLE_SYSTEM, resources)
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
	end
end

return Splosion
