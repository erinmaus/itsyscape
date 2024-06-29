--------------------------------------------------------------------------------
-- Resources/Game/Props/MoonDebrisRing_Default/View.lua
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
local PropView = require "ItsyScape.Graphics.PropView"

local MoonDebrisRing = Class(PropView)

MoonDebrisRing.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/MoonDebrisRing_Default/Particle.png",
	columns = 2,
	rows = 2,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 64, 69 },
			speed = { 0, 0 },
			yRange = { 0, 1 / 16 },
			acceleration = { 0, 0 },
			normal = { true }
		},
		{
			type = "RandomLifetimeEmitter",
			age = { math.huge }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -20, 20 }

		},
		{
			type = "RandomTextureIndex",
			textures = { 1, 4 }
		}
	},

	paths = {},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 132, 132 },
		delay = { 0.25 },
		duration = { 2 }
	}
}

function MoonDebrisRing:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(MoonDebrisRing.PARTICLE_SYSTEM, resources)
	self.particles:getMaterial():setIsZWriteDisabled(false)
	self.particles:getMaterial():setIsFullLit(true)
	self.particles:setParent(root)
end

function MoonDebrisRing:getIsStatic()
	return false
end

function MoonDebrisRing:tick()
	PropView.tick(self)

	local offset = self:getProp():getState().offset or 0
	local y = Quaternion.fromAxisAngle(Vector.UNIT_Y, (love.timer.getTime() + offset) * (math.pi / 1024))
	local z = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 3)

	self:getRoot():getTransform():setLocalRotation((z * y):getNormal())
end

return MoonDebrisRing
