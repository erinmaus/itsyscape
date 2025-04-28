--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/StormFlare/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"

local Flare = Class(Projectile)

Flare.DURATION_OFFSET = 4

function Flare.FLARE_PARTICLE_SYSTEM(duration)
	return {
		numParticles = 200,
		texture = "Resources/Game/Projectiles/Common/Particle_Flame.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.25 },
				speed = { 1, 1.5 },
				acceleration = { 0, 0 },
				position = { 0, 1, 0 }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ Color.fromHexString("ffcc00", 0):get() },
					{ Color.fromHexString("ff9000", 0):get() },
					{ Color.fromHexString("c83737", 0):get() },
					{ Color.fromHexString("c83737", 0):get() },
					{ Color.fromHexString("c83737", 0):get() },
				}
			},
			{
				type = "RandomLifetimeEmitter",
				age = { 0.5, 1 }
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
				fadeInPercent = { 0.05 },
				fadeOutPercent = { 0.95 },
				tween = { 'sineEaseOut' }
			},
			{
				type = "GravityPath",
				gravity = { 0, -5, 0 }
			},
			{
				type = "TextureIndexPath",
				textures = { 1, 4 }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { 20, 30 },
			delay = { 1 / 30 },
			duration = { duration }
		}
	}
end

function Flare.SMOKE_PARTICLE_SYSTEM(duration)
	return {
		numParticles = 200,
		texture = "Resources/Game/Projectiles/Common/Particle_Smoke.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.125 },
				position = { 0, 1.5, 0 },
				yRange = { 0, 0 },
				lifetime = { 4, 1.5 },
				normal = { true }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.45, 0.45 },
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ 0.2, 0.2, 0.2, 0.0 },
					{ 0.2, 0.2, 0.2, 0.0 },
					{ 0.2, 0.2, 0.2, 0.0 },
					{ 0.3, 0.3, 0.3, 0.0 },
					{ 0.1, 0.1, 0.1, 0.0 },
				}
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.2, 0.3 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 },
				velocity = { 60, 120 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.01 },
				fadeOutPercent = { 0.99 },
				tween = { 'sineEaseOut' }
			},
			{
				type = "GravityPath",
				gravity = { 0, -0.5, 0 }
			},
			{
				type = "TextureIndexPath",
				textures = { 1, 4 }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { 5, 10 },
			delay = { 1 / 30 },
			duration = { duration }
		}
	}
end

Flare.UNITS_PER_SECOND = 4
Flare.MAX_SEGMENT_LENGTH = 0.25
Flare.MIN_SEGMENT_LENGTH = 0.5
Flare.MAX_JITTER_DISTANCE = 1.5

function Flare:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:getTransform():setLocalTranslation(Vector(0, 0.5, 0.5))
	self.light:setColor(Color(1, 0, 0))
	self.light:setAttenuation(5)
	self.light:setParent(root)

	self.fullPath = {}
	self.currentPath = {}
	self.previousNumSegments = 1
end

function Flare:poof()
	self.smoke:setParent(false)
	self.flare:setParent(false)
end

local function bezier3(a, b, c, delta)
	return (1 - delta) ^ 2 * a + (2 * (1 - delta)) * delta * b + delta ^ 2 * c
end

function Flare:generatePath(spawn, hit)
	local rng = love.math.newRandomGenerator()

	local a = spawn
	local c = hit
	local b
	do
		local position = Vector(rng:random(), rng:random(), rng:random()):getNormal()
		local length = math.sqrt(rng:random() * (hit - spawn):getLength())
		b = (spawn - hit) + position * length + hit
	end

	self.distance = 0
	local delta = 0
	while delta < 1 do
		local mu = (Flare.MAX_SEGMENT_LENGTH - Flare.MIN_SEGMENT_LENGTH) * rng:random() + Flare.MIN_SEGMENT_LENGTH

		local currentPoint
		do
			currentPoint = bezier3(a, b, c, delta)

			local normal = Vector(rng:random(), rng:random(), rng:random()):getNormal()
			local length = rng:random() * Flare.MAX_JITTER_DISTANCE * mu / Flare.MAX_SEGMENT_LENGTH
			local offset = normal * length

			currentPoint = currentPoint + offset

			self.distance = self.distance + length
		end

		table.insert(self.fullPath, currentPoint:keep())
		delta = delta + mu
	end

	self.baseDuration = self.distance / Flare.UNITS_PER_SECOND
end

function Flare:updatePath()
	local fractionalIndex = #self.fullPath * math.clamp(self:getTime() / self.baseDuration) + 1
	local currentIndex = math.min(math.floor(fractionalIndex), #self.fullPath - 1)
	local delta = fractionalIndex - currentIndex

	local a = self.fullPath[currentIndex]
	local b = self.fullPath[currentIndex + 1]
	local position = a:lerp(b, delta)

	self:getRoot():getTransform():setLocalTranslation(position)

	local absolutePosition = Vector.ZERO:transform(self:getRoot():getTransform():getGlobalDeltaTransform(0))
	self.flare:updateLocalPosition(absolutePosition)
	self.smoke:updateLocalPosition(absolutePosition)
	self.smoke:updateLocalDirection(a:direction(b))
end

function Flare:getDuration()
	return self.baseDuration + self.DURATION_OFFSET
end

function Flare:tick()
	if not (self.spawnPosition and self.hitPosition) then
		self.spawnPosition = self:getTargetPosition(self:getSource()):keep()
		self.hitPosition = self:getTargetPosition(self:getDestination()):keep()

		self:generatePath(self.spawnPosition, self.hitPosition)

		local resources = self:getResources()

		self.flare = ParticleSceneNode()
		self.flare:initParticleSystemFromDef(Flare.FLARE_PARTICLE_SYSTEM(self.baseDuration), resources)
		self.flare:setParent(self:getGameView():getScene())

		self.smoke = ParticleSceneNode()
		self.smoke:initParticleSystemFromDef(Flare.SMOKE_PARTICLE_SYSTEM(self.baseDuration), resources)
		self.smoke:setParent(self:getGameView():getScene())
		self.smoke:getMaterial():getIsFullLit(false)
	end
end

function Flare:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.hitPosition then
		self:updatePath()
		self:ready()
	end
end

return Flare
