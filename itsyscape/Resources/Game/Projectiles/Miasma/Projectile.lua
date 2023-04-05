--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Miasma/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Miasma = Class(Projectile)

Miasma.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/Miasma/Smoke.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.125 },
			speed = { 2, 3 },
			acceleration = { -1, -2 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.5, 1.5 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.4, 0.4, 0.4, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 1.0, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.6, 0.7 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 30, 60 },
			acceleration = { -40, -20 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 5, 10 },
		delay = { 0.125 },
		duration = { 2 }
	}
}

Miasma.DURATION = 2

function Miasma:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystemNode = ParticleSceneNode()
	self.particleSystemNode:setParent(root)
	self.particleSystemNode:initParticleSystemFromDef(Miasma.PARTICLE_SYSTEM, resources)
end

function Miasma:getDuration()
	return Miasma.DURATION
end

function Miasma:update(elapsed)
	Projectile.update(self, elapsed)

	local spawnPosition = self:getTargetPosition(self:getDestination())

	local particleSystem = self.particleSystemNode:getParticleSystem()
	if particleSystem then
		particleSystem:updateEmittersLocalPosition(spawnPosition)
	end
end

return Miasma
