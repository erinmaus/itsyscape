--------------------------------------------------------------------------------
-- Resources/Game/Props/GoredDragonStomachAcidFire/View.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Fire = Class(PropView)
Fire.MIN_FLICKER_TIME = 10 / 60
Fire.MAX_FLICKER_TIME = 20 / 60
Fire.MIN_ATTENUATION = 0.25
Fire.MAX_ATTENUATION = 1
Fire.MIN_COLOR_BRIGHTNESS = 0.5
Fire.MAX_COLOR_BRIGHTNESS = 1.0
Fire.COLOR = Color(1, 0.5, 0, 1)
Fire.HEIGHT = 1
Fire.WIND_RESISTANCE = 16

function Fire:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.flickerTime = 0
end

do
	local fireDirection = Vector()
	local targetWindRotation = Quaternion()
	local currentWindRotation = Quaternion()
	local normal = Vector()

	function Fire:_updateDirection(direction, speed)
		local position, layer = self:getProp():getPosition()
		local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

		local windDelta = self:getGameView():getRenderer():getTime() * windSpeed + position:getLength() * windSpeed
		windDelta = math.sin(windDelta / windPattern.x) * math.sin(windDelta / windPattern.y) * math.sin(windDelta / windPattern.z)
		local windMu = (windDelta + 1) / 2

		local min, max = self:getProp():getBounds()
		fireDirection:from(
			windDelta * windDirection.x,
			(max.y - min.y) / 2,
			windDelta * windDirection.z):normalize(fireDirection)

		Quaternion.fromVectors(Vector.UNIT_Y, fireDirection, targetWindRotation)
		Quaternion.IDENTITY:slerp(targetWindRotation, windMu, currentWindRotation):transformVector(Vector.UNIT_Y, normal)
		normal:normalize(normal)

		direction.speed[1] = windSpeed / 12 * speed
		direction.speed[2] = windSpeed / 12 * speed
		direction.direction[1] = normal.x
		direction.direction[2] = normal.y
		direction.direction[3] = normal.z
	end
end

function Fire:_getOuterParticleDefinition()
	self._outerParticleDefinition = self._outerParticleDefinition or {
		numParticles = 100,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.1 },
				position = { 0, 0.1, 0 },
				yRange = { 0, 0 },
				lifetime = { 2.75, 0.05 }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.1, 0.1 },
			},
			{
				type = "RandomColorEmitter",
				colors = self:getOuterColors()
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.2 }
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
			count = { 10, 15 },
			delay = { 1 / 10 }
		}
	}

	self:_updateDirection(self._outerParticleDefinition.emitters[2], 0.45)

	return self._outerParticleDefinition
end

function Fire:_getInnerParticleDefinition()
	self._innerParticleDefinition = self._innerParticleDefinition or {
		numParticles = 100,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.1 },
				position = { 0, 0, 0 },
				yRange = { 0, 0 },
				lifetime = { 2.5, 0.05 }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.1, 0.1 },
			},
			{
				type = "RandomColorEmitter",
				colors = self:getInnerColors()
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.15 }
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
			count = { 10, 15 },
			delay = { 1 / 10 }
		}
	}

	self:_updateDirection(self._innerParticleDefinition.emitters[2], 0.5)

	return self._innerParticleDefinition
end

function Fire:getOuterColors()
	return {
		{ Color.fromHexString("ffd52a"):get() },
		{ Color.fromHexString("ffd52a"):get() },
		{ Color.fromHexString("ffd52a"):get() },
		{ Color.fromHexString("ffd52a"):get() },
	}
end

function Fire:getInnerColors()
	return {
		{ 1, 0.4, 0.0, 0.0 },
		{ 0.9, 0.4, 0.0, 0.0 },
		{ 1, 0.5, 0.0, 0.0 },
		{ 0.9, 0.5, 0.0, 0.0 },
	}
end

function Fire:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queueEvent(function()
		self.outerFlames = ParticleSceneNode()
		self.outerFlames:initParticleSystemFromDef(self:_getOuterParticleDefinition(), resources)
		self.outerFlames:setParent(root)
		self.outerFlames:getMaterial():setAlpha(0.2)

		self.innerFlames = ParticleSceneNode()
		self.innerFlames:initParticleSystemFromDef(self:_getInnerParticleDefinition(), resources)
		self.innerFlames:setParent(root)
		self.innerFlames:getMaterial():setZBias(10)
		self.innerFlames:getMaterial():setAlpha(0.2)

		self.light = PointLightSceneNode()
		self.light:getTransform():setLocalTranslation(Vector(0, 0.5, 0.5))
		self.light:setParent(root)

		self.time = 0
		self.spawned = true
	end)
end

function Fire:flicker()
	if self.light then
		local flickerWidth = self.MAX_FLICKER_TIME - self.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + self.MIN_FLICKER_TIME
		local scale = self:getProp():getScale():getLength()

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = self.MAX_ATTENUATION * scale - self.MIN_ATTENUATION * scale
		local attenuation = love.math.random() * attenuationWidth + self.MAX_ATTENUATION * scale
		self.light:setAttenuation(attenuation)

		local brightnessWidth = self.MAX_COLOR_BRIGHTNESS - self.MIN_COLOR_BRIGHTNESS
		local brightness = love.math.random() * brightnessWidth + self.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness * self.COLOR.r, brightness * self.COLOR.g, brightness * self.COLOR.b, 1)
		self.light:setColor(color)
	end
end

function Fire:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.duration and state.duration < 0.5 then
		self.node:getTransform():setLocalScale(Vector(state.duration / 0.5))
	end
end

function Fire:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta

	if self.flickerTime < 0 then
		self:flicker()
	end

	if self.spawned then
		self.time = self.time + delta

		if self.outerFlames then
			self.outerFlames:initEmittersFromDef(self:_getOuterParticleDefinition().emitters)
		end

		if self.innerFlames then
			self.innerFlames:initEmittersFromDef(self:_getInnerParticleDefinition().emitters)
		end
	end
end

return Fire
