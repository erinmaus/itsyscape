--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MagmaSnailRock/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Arrow = require "Resources.Game.Projectiles.Common.Arrow"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local MagmaSnailRock = Class(Arrow)

MagmaSnailRock.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/MagmaSnailRock/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 1, 2 },
			acceleration = { 0, 0 }
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
		count = { 2, 5 },
		delay = { 0.125 },
		duration = { 0.5 }
	}
}

function MagmaSnailRock:load()
	Arrow.load(self)

	local resources = self:getResources()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:initParticleSystemFromDef(MagmaSnailRock.PARTICLE_SYSTEM, resources)
	self.particleSystem:setParent(self:getRoot())

	self.quad:getTransform():setLocalScale(Vector.ONE)
end

function MagmaSnailRock:getTextureFilename()
	return "Resources/Game/Projectiles/MagmaSnailRock/Texture.png"
end

function MagmaSnailRock:update(delta)
	Arrow.update(self, delta)

	local root = self:getRoot()

	local time = self:getTime()
	local angle = time * math.pi * 4

	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
	root:getTransform():setLocalRotation(rotation)
	root:getTransform():setPreviousTransform(nil, rotation)
end

return MagmaSnailRock
