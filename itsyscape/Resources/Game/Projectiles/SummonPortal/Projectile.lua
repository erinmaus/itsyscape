--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/SummonPortal/Projectile.lua
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

local Summon = Class(Projectile)

Summon.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/SummonPortal/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 1 },
			speed = { 5, 7 },
			xRange = { 0, 0.125 },
			zRange = { 0, 0.125 },
			yRange = { 0.5, 0.25 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.75, 1 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.5, 0.75 }
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
		count = { 5, 10 },
		delay = { 1 / 20 },
		duration = { 4 }
	}
}

Summon.DURATION = 5

Summon.CLAMP_BOTTOM = true

Summon.COLOR_FROM = Color(0.9, 0.4, 0.0, 1.0)
Summon.COLOR_TO = Color(0.0, 0.8, 1.0, 1.0)

function Summon:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:initParticleSystemFromDef(Summon.PARTICLE_SYSTEM, resources)
	self.particleSystem:setParent(root)
end

function Summon:getDuration()
	return Summon.DURATION
end

function Summon:update(elapsed)
	Projectile.update(self, elapsed)

	local position = self:getTargetPosition(self:getSource())
	local root = self:getRoot()
	root:getTransform():setLocalTranslation(position)

	local colorDelta = math.abs(math.sin(love.timer.getTime() * math.pi))
	local color = Summon.COLOR_FROM:lerp(Summon.COLOR_TO, colorDelta)
	self.particleSystem:getMaterial():setColor(color)

	self:ready()
end

return Summon
