--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/ChocoroachVomit/Projectile.lua
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

local ChocoroachVomit = Class(Arrow)

ChocoroachVomit.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/ChocoroachVomit/Particle.png",
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
				{ 0.9, 0.9, 0.6, 0.0 },
				{ 0.6, 0.8, 0.2, 0.0 },
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

ChocoroachVomit.SCALE_RANGE = 0.5
ChocoroachVomit.SCALE = 1

function ChocoroachVomit:load()
	Arrow.load(self)

	local resources = self:getResources()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:initParticleSystemFromDef(ChocoroachVomit.PARTICLE_SYSTEM, resources)
	self.particleSystem:setParent(self:getRoot())
end

function ChocoroachVomit:getTextureFilename()
	return "Resources/Game/Projectiles/ChocoroachVomit/Texture.png"
end

function ChocoroachVomit:update(delta)
	Arrow.update(self, delta)

	local root = self:getRoot()

	local time = self:getTime()
	local angle = time * math.pi * 4

	local scale = math.sin(angle) * ChocoroachVomit.SCALE_RANGE
	root:getTransform():setLocalScale(Vector(scale + ChocoroachVomit.SCALE))
	root:getTransform():setPreviousTransform(nil, nil, Vector(scale + ChocoroachVomit.SCALE))
end

return ChocoroachVomit
