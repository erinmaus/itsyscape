--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/FlameGreeble.lua
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
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local Greeble = require "Resources.Game.Props.Common.Greeble"

local FlameGreeble = Class(Greeble)

FlameGreeble.ATTACH_TO_ROOT = false

FlameGreeble.FLAME_SCALE = Vector(1):keep()
FlameGreeble.FLAME_OFFSET = Vector(0):keep()

FlameGreeble.PARTICLE_SCALE = 1

FlameGreeble.INNER_RADIUS = 0.125
FlameGreeble.OUTER_RADIUS = 0.25

FlameGreeble.INNER_FLAME_SPEED = 0.45
FlameGreeble.OUTER_FLAME_SPEED = 0.5

FlameGreeble.FLAME_HEIGHT = 1
FlameGreeble.FLAME_WIND_RESISTANCE = 2

FlameGreeble.SOFT = false

FlameGreeble.INNER_FLAME_COLORS = {
	Color.fromHexString("ffd52a"),
	Color.fromHexString("ffd52a"),
	Color.fromHexString("ffd52a"),
	Color.fromHexString("ffd52a"),
}

FlameGreeble.OUTER_FLAME_COLORS = {
	Color(1, 0.4, 0.0),
	Color(0.9, 0.4, 0.0),
	Color(1, 0.5, 0.0),
	Color(0.9, 0.5, 0.0),
}

FlameGreeble.LOCAL_DIRECTION = Vector(0, 1, 0)

do
	local fireDirection = Vector()
	local targetWindRotation = Quaternion()
	local currentWindRotation = Quaternion()
	local normal = Vector()

	function FlameGreeble:_updateDirection(direction, speed)
		local position, layer = self:getProp():getPosition()
		local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

		local windDelta = self:getGameView():getRenderer():getTime() * windSpeed + position:getLength() * windSpeed
		windDelta = math.sin(windDelta / windPattern.x) * math.sin(windDelta / windPattern.y) * math.sin(windDelta / windPattern.z)
		local windMu = (windDelta + 1) / 2

		fireDirection:from(
			windDelta * windDirection.x,
			self.FLAME_WIND_RESISTANCE,
			windDelta * windDirection.z):normalize(fireDirection)

		Quaternion.fromVectors(Vector.UNIT_Y, fireDirection, targetWindRotation)
		Quaternion.IDENTITY:slerp(targetWindRotation, windMu, currentWindRotation):transformVector(Vector.UNIT_Y, normal)
		normal:normalize(normal)

		direction.speed[1] = windSpeed / 3 * speed
		direction.speed[2] = windSpeed / 3 * speed
		direction.direction[1] = normal.x
		direction.direction[2] = normal.y
		direction.direction[3] = normal.z
	end
end

function FlameGreeble:_getInnerParticleDefinition()
	self._innerParticleDefinition = self._innerParticleDefinition or {
		numParticles = 200,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
		columns = 4,
		soft = self.SOFT,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, self.INNER_RADIUS * self.PARTICLE_SCALE },
				position = { 0, 0.1, 0 },
				yRange = { 0, 0 },
				lifetime = { 1.25, 0.15 }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.75, 1 },
			},
			{
				type = "RandomColorEmitter",
				colors = self:getInnerColors()
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.25 * self.PARTICLE_SCALE }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.2 },
				fadeOutPercent = { 0.8 },
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
			delay = { 1 / 30 }
		}
	}

	self:_updateDirection(self._innerParticleDefinition.emitters[2], self.INNER_FLAME_SPEED)

	return self._innerParticleDefinition
end

function FlameGreeble:_getOuterParticleDefinition()
	self._outerParticleDefinition = self._outerParticleDefinition or {
		numParticles = 200,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
		columns = 4,
		soft = self.SOFT,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, self.OUTER_RADIUS * self.PARTICLE_SCALE },
				position = { 0, 0, 0 },
				yRange = { 0, 0 },
				lifetime = { 1.5, 0.4 }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.75, 1 },
			},
			{
				type = "RandomColorEmitter",
				colors = self:getOuterColors()
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.25 * self.PARTICLE_SCALE }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.4 },
				fadeOutPercent = { 0.6 },
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
			delay = { 1 / 30 }
		}
	}

	self:_updateDirection(self._outerParticleDefinition.emitters[2], self.OUTER_FLAME_SPEED)

	return self._outerParticleDefinition
end

function FlameGreeble:getInnerColors()
	local r = {}
	for _, color in ipairs(self.INNER_FLAME_COLORS) do
		table.insert(r, { color.r, color.g, color.b, 0 })
	end

	return r
end

function FlameGreeble:getOuterColors()
	local r = {}
	for _, color in ipairs(self.OUTER_FLAME_COLORS) do
		table.insert(r, { color.r, color.g, color.b, 0 })
	end

	return r
end

function FlameGreeble:load()
	Greeble.load(self)

	local resources = self:getResources()

	local root
	if self.ATTACH_TO_ROOT then
		root = self:getGameView():getScene()
	else
		root = self:getRoot()
	end

	resources:queueEvent(function()
		self.outerFlames = ParticleSceneNode()
		self.outerFlames:initParticleSystemFromDef(self:_getOuterParticleDefinition(), resources)
		self.outerFlames:setParent(root)
		self.outerFlames:getTransform():setLocalScale(self.FLAME_SCALE)
		self.outerFlames:getTransform():setLocalTranslation(self.FLAME_OFFSET)

		self.innerFlames = ParticleSceneNode()
		self.innerFlames:initParticleSystemFromDef(self:_getInnerParticleDefinition(), resources)
		self.innerFlames:setParent(root)
		self.innerFlames:getTransform():setLocalScale(self.FLAME_SCALE)
		self.innerFlames:getTransform():setLocalTranslation(self.FLAME_OFFSET)
	end)
end

function FlameGreeble:remove()
	Greeble.remove(self)

	if self.outerFlames then
		self.outerFlames:setParent()
	end

	if self.innerFlames then
		self.innerFlames:setParent()
	end
end

function FlameGreeble:regreebilize(t, ...)
	Greeble.regreebilize(self, t, ...)

	self._outerParticleDefinition = nil
	self._innerParticleDefinition = nil

	self:_updateParticles()

	if self.outerFlames then
		self.outerFlames:getTransform():setLocalScale(self.FLAME_SCALE)
		self.outerFlames:getTransform():setLocalTranslation(self.FLAME_OFFSET)
	end

	if self.innerFlames then
		self.innerFlames:getTransform():setLocalScale(self.FLAME_SCALE)
		self.innerFlames:getTransform():setLocalTranslation(self.FLAME_OFFSET)
	end
end

function FlameGreeble:_updateParticles()
	if self.outerFlames then
		self.outerFlames:initEmittersFromDef(self:_getOuterParticleDefinition().emitters)
	end

	if self.innerFlames then
		self.innerFlames:initEmittersFromDef(self:_getInnerParticleDefinition().emitters)
	end
end

function FlameGreeble:updateLocalPosition(position)
	if not self.outerFlames then
		self:getResources():queueEvent(function()
			self.outerFlames:updateLocalPosition(position)
		end)
	else
		self.outerFlames:updateLocalPosition(position)
	end

	if not self.innerFlames then
		self:getResources():queueEvent(function()
			self.innerFlames:updateLocalPosition(position)
		end)
	else
		self.innerFlames:updateLocalPosition(position)
	end
end

function FlameGreeble:updateLocalDirection(direction)
	if not self.outerFlames then
		self:getResources():queueEvent(function()
			self.outerFlames:updateLocalDirection(direction)
		end)
	else
		self.outerFlames:updateLocalDirection(direction)
	end

	if not self.innerFlames then
		self:getResources():queueEvent(function()
			self.innerFlames:updateLocalDirection(direction)
		end)
	else
		self.innerFlames:updateLocalDirection(direction)
	end
end

function FlameGreeble:update(delta)
	Greeble.update(self, delta)

	self:_updateParticles()
end

return FlameGreeble
