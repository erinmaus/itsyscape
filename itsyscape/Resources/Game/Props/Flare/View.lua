--------------------------------------------------------------------------------
-- Resources/Game/Props/Flare/View.lua
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

local Flare = Class(PropView)
Flare.MIN_FLICKER_TIME = 10 / 60
Flare.MAX_FLICKER_TIME = 20 / 60
Flare.MIN_ATTENUATION = 5
Flare.MAX_ATTENUATION = 10
Flare.MIN_COLOR_BRIGHTNESS = 0.9
Flare.MAX_COLOR_BRIGHTNESS = 1.0
Flare.COLOR = Color(1, 0, 0)
Flare.OFFSET = -0.5

function Flare:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.flickerTime = 0
end

function Flare:_updateDirection(direction, speed)
	local position, layer = self.prop:getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	local windDelta = self:getGameView():getRenderer():getTime() * windSpeed + position:getLength() * windSpeed
	windDelta = math.sin(windDelta / windPattern.x) * math.sin(windDelta / windPattern.y) * math.sin(windDelta / windPattern.z)
	local windMu = (windDelta + 1) / 2

	local fireDirection = Vector(windDelta * windDirection.x, 1, windDelta * windDirection.z):getNormal()

	local currentWindRotation = Quaternion()
	local targetWindRotation = Quaternion.lookAt(Vector(0), fireDirection, Vector.UNIT_Y)
	local normal = currentWindRotation:slerp(targetWindRotation, windMu):transformVector(Vector.UNIT_Y)

	direction.speed[1] = windSpeed / 3 * speed
	direction.speed[2] = windSpeed / 3 * speed
	direction.direction[1] = normal.x
	direction.direction[2] = normal.y
	direction.direction[3] = normal.z
end

function Flare:_getFlareParticleDefinition()
	self._flareDefinition = self._flareDefinition or {
		numParticles = 200,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
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
				colors = self:getFlareColors()
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
			delay = { 1 / 20 },
			duration = { math.huge }
		}
	}
 
	return self._flareDefinition
end

function Flare:_getSmokeParticleDefinition()
	self._smokeParticleDefinition = self._smokeParticleDefinition or {
		numParticles = 200,
		texture = "Resources/Game/Props/Common/Particle_Smoke.png",
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
				colors = self:getSmokeColors()
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
			delay = { 1 / 30 }
		}
	}

	self:_updateDirection(self._smokeParticleDefinition.emitters[2], 0.2)
	self._smokeParticleDefinition.emitters[2].direction[2] = -self._smokeParticleDefinition.emitters[2].direction[2]
	self._smokeParticleDefinition.emitters[1].position[1] = self._smokeParticleDefinition.emitters[2].direction[1] * self.OFFSET
	self._smokeParticleDefinition.emitters[1].position[2] = self._smokeParticleDefinition.emitters[2].direction[2] * self.OFFSET
	self._smokeParticleDefinition.emitters[1].position[3] = self._smokeParticleDefinition.emitters[2].direction[3] * self.OFFSET

	return self._smokeParticleDefinition
end

function Flare:getFlareColors()
	return {
		{ Color.fromHexString("ffcc00", 0):get() },
		{ Color.fromHexString("ff9000", 0):get() },
		{ Color.fromHexString("c83737", 0):get() },
		{ Color.fromHexString("c83737", 0):get() },
		{ Color.fromHexString("c83737", 0):get() },
	}
end

function Flare:getSmokeColors()
	return {
		{ 0.2, 0.2, 0.2, 0.0 },
		{ 0.2, 0.2, 0.2, 0.0 },
		{ 0.2, 0.2, 0.2, 0.0 },
		{ 0.3, 0.3, 0.3, 0.0 },
		{ 0.1, 0.1, 0.1, 0.0 },
	}
end

function Flare:getIsStatic()
	return false
end

function Flare:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queueEvent(function()
		self.flare = ParticleSceneNode()
		self.flare:initParticleSystemFromDef(self:_getFlareParticleDefinition(), resources)
		self.flare:setParent(self:getGameView():getScene())

		self.smoke = ParticleSceneNode()
		self.smoke:initParticleSystemFromDef(self:_getSmokeParticleDefinition(), resources)
		self.smoke:setParent(self:getGameView():getScene())
		self.smoke:getMaterial():getIsFullLit(false)

		self.light = PointLightSceneNode()
		self.light:getTransform():setLocalTranslation(Vector(0, 0.5, 0.5))
		self.light:setParent(root)

		self.time = 0
		self.spawned = true
	end)
end

function Flare:remove()
	if self.flare then
		self.flare:setParent(false)
	end

	if self.smoke then
		self.smoke:setParent(false)
	end
end

function Flare:flicker()
	if self.light then
		local flickerWidth = self.MAX_FLICKER_TIME - self.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + self.MIN_FLICKER_TIME

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = self.MAX_ATTENUATION - self.MIN_ATTENUATION
		local attenuation = love.math.random() * attenuationWidth + self.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = self.MAX_COLOR_BRIGHTNESS - self.MIN_COLOR_BRIGHTNESS
		local brightness = love.math.random() * brightnessWidth + self.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness * self.COLOR.r, brightness * self.COLOR.g, brightness * self.COLOR.b, 1)
		self.light:setColor(color)
	end
end

function Flare:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta

	if self.flickerTime < 0 then
		self:flicker()
	end

	if self.spawned then
		self.time = self.time + delta

		local position = Vector.ZERO:transform(self:getRoot():getTransform():getGlobalDeltaTransform(_APP:getFrameDelta()))

		if self.flare then
			self.flare:initEmittersFromDef(self:_getFlareParticleDefinition().emitters)
			self.flare:updateLocalPosition(position)
		end

		if self.smoke then
			self.smoke:initEmittersFromDef(self:_getSmokeParticleDefinition().emitters)
			self.smoke:updateLocalPosition(position)
		end
	end
end

return Flare
