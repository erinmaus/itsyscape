--------------------------------------------------------------------------------
-- Resources/Game/Props/Stars_Default/View.lua
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
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"

local Stars = Class(PropView)

Stars.STAR_PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/Starfall/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 70, 80 },
			yRange = { 0.5, 0.75 },
			speed = { 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 1 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { math.huge }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.1, 0.2 }
		}
	},

	paths = {
		{
			type = "TwinklePath",
			speed = { math.pi / 8 },
			multiply = { false }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 500, 500 },
		delay = { 0.5 },
		duration = { 2 }
	}
}

Stars.GALAXY_PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/Starfall/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 74, 76 },
			yRange = { 0.5, 1 / 3 },
			xRange = { 0, 1 / 32 },
			speed = { 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("231942"):get() },
				{ Color.fromHexString("5e548e"):get() },
				{ Color.fromHexString("9f86c0"):get() },
				{ Color.fromHexString("be95c4"):get() },
				{ Color.fromHexString("e0b1cb"):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { math.huge }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.1, 0.2 }
		}
	},

	paths = {
		{
			type = "TwinklePath",
			speed = { math.pi / 8 },
			multiply = { false }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 250, 250 },
		delay = { 0.5 },
		duration = { 2 }
	}
}

function Stars:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.starParticles = ParticleSceneNode()
	self.starParticles:initParticleSystemFromDef(Stars.STAR_PARTICLE_SYSTEM, resources)
	self.starParticles:getMaterial():setIsTranslucent(true)
	self.starParticles:getMaterial():setIsZWriteDisabled(false)
	self.starParticles:getMaterial():setIsFullLit(true)
	self.starParticles:getMaterial():setOutlineThreshold(-1)
	self.starParticles:setParent(root)

	self.galaxyParticles = ParticleSceneNode()
	self.galaxyParticles:initParticleSystemFromDef(Stars.GALAXY_PARTICLE_SYSTEM, resources)
	self.galaxyParticles:getMaterial():setIsTranslucent(true)
	self.galaxyParticles:getMaterial():setIsZWriteDisabled(false)
	self.galaxyParticles:getMaterial():setIsFullLit(true)
	self.galaxyParticles:getMaterial():setOutlineThreshold(-1)
	self.galaxyParticles:getTransform():setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 3))
	self.galaxyParticles:setParent(root)
end

function Stars:getIsStatic()
	return false
end

function Stars:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.alpha then
		local alpha = (20 ^ state.alpha) / 20
		self.starParticles:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.galaxyParticles:getMaterial():setColor(Color(1, 1, 1, alpha))
	end
end

return Stars
