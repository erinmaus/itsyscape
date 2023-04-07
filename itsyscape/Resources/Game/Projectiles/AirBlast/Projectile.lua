--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/AirBlast/Projectile.lua
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
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local AirBlast = Class(Projectile)

AirBlast.PARTICLE_SYSTEM = {
	numParticles = 100,
	texture = "Resources/Game/Projectiles/AirBlast/Particle.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.25 },
			speed = { 1.5, 2.5 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 1.0, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.3, 0.4 }
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
		count = { 4, 6 },
		delay = { 1 / 30 },
		duration = { math.huge }
	}
}

AirBlast.SEGMENT_LENGTH  = 1 / 25
AirBlast.RADIUS = 0.5

AirBlast.SPEED = 8

AirBlast.ALPHA_MULTIPLIER = 1.75

function AirBlast:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.airWave = LightBeamSceneNode()
	self.airWave:setParent(root)
	self.airWave:setBeamSize(0.25)
	self.airWave:getMaterial():setIsFullLit(true)
	self.airWave:getMaterial():setColor(Color(1))

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(AirBlast.PARTICLE_SYSTEM, resources)

	self.fullPath = {}
	self.currentPath = {}
	self.previousNumSegments = 1
end

function AirBlast:generatePath(spawn, hit)
	local crowDistance = (spawn - hit):getLength()
	local totalDistance = 2 * math.pi * AirBlast.RADIUS * (crowDistance / AirBlast.RADIUS)

	local currentDistance = 0
	while currentDistance < totalDistance do
		local delta = currentDistance / crowDistance

		local position = Vector(
			math.cos(delta * math.pi * 2) * (AirBlast.RADIUS),
			math.sin(delta * math.pi * 2) * (AirBlast.RADIUS),
			-currentDistance / totalDistance * crowDistance)
		table.insert(self.fullPath, position)

		currentDistance = currentDistance + AirBlast.SEGMENT_LENGTH
	end
end

function AirBlast:updatePath()
	local numSegments = math.min(math.floor(#self.fullPath * self:getDelta()) + 1, #self.fullPath)

	for i = self.previousNumSegments + 1, numSegments do
		local a = self.fullPath[i - 1]
		local b = self.fullPath[i]

		table.insert(self.currentPath, {
			a = { a:get() },
			b = { b:get() }
		})
		self.previousNumSegments = self.previousNumSegments + 1

		self.lastPosition = b
	end

	self.airWave:buildSeamless(self.currentPath)
end

function AirBlast:getDuration()
	return self.duration or math.huge
end

function AirBlast:tick()
	if not self.spawnPosition then
		self.hitPosition = self:getTargetPosition(self:getDestination())
		self.spawnPosition = self:getTargetPosition(self:getSource())

		self:generatePath(self.spawnPosition, self.hitPosition)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function AirBlast:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.hitPosition then
		self:updatePath()

		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * AirBlast.ALPHA_MULTIPLIER
		alpha = math.min(alpha, 1)

		local rotation = Quaternion.lookAt(self.spawnPosition, self.hitPosition)

		self.airWave:getTransform():setLocalRotation(rotation)
		self.airWave:getTransform():setLocalTranslation(self.spawnPosition)
		self.airWave:getMaterial():setColor(Color(1, 1, 1, alpha))

		if self.lastPosition then
			local particleSystem = self.particleSystem:getParticleSystem()
			if particleSystem then
				local position = self.spawnPosition + rotation:transformVector(self.lastPosition)
				particleSystem:updateEmittersLocalPosition(position)
			end
		end
	end
end

return AirBlast
