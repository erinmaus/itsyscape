--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/ShockwaveSplosion/Projectile.lua
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
	numParticles = 100,
	texture = "Resources/Game/Projectiles/ShockwaveSplosion/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			yRange = { 0, 0 },
			speed = { 7, 7.5 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("ffcc00", 0.0):get() },
				{ Color.fromHexString("ffcc00", 0.0):get() },
				{ Color.fromHexString("ff9900", 0.0):get() },
				{ Color.fromHexString("ff9900", 0.0):get() },
				{ Color.fromHexString("00ccff", 0.0):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1.25, 1.5 }
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
		count = { 50, 75 },
		delay = { 0.25 },
		duration = { 1.5 }
	}
}

Splosion.DURATION = 3

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
		self.spawnPosition = self:getTargetPosition(self:getDestination()):keep()
	end
end

function Splosion:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end
end

return Splosion
