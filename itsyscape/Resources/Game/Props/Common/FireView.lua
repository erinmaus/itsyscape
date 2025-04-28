--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/FireView.lua
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
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local FireView = Class(PropView)
FireView.MIN_FLICKER_TIME = 10 / 60
FireView.MAX_FLICKER_TIME = 20 / 60
FireView.MIN_ATTENUATION = 2
FireView.MAX_ATTENUATION = 3.5
FireView.MIN_COLOR_BRIGHTNESS = 0.9
FireView.MAX_COLOR_BRIGHTNESS = 1.0
FireView.COLOR = Color(1, 0.5, 0, 1)
FireView.HEIGHT = 1

function FireView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.flickerTime = 0
end

function FireView:getTextureFilename()
	return Class.ABSTRACT()
end

function FireView:getResourcePath(resource)
	return string.format("Resources/Game/Props/Common/Fire/%s", resource)
end

function FireView:_updateDirection(direction, speed)
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

function FireView:_getInnerParticleDefinition()
	self._innerParticleDefinition = self._innerParticleDefinition or {
		numParticles = 50,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.125 },
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
				scale = { 0.25 }
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
			count = { 5, 10 },
			delay = { 1 / 10 }
		}
	}

	self:_updateDirection(self._innerParticleDefinition.emitters[2], 0.45)

	return self._innerParticleDefinition
end

function FireView:_getOuterParticleDefinition()
	self._outerParticleDefinition = self._outerParticleDefinition or {
		numParticles = 50,
		texture = "Resources/Game/Props/Common/Particle_Flame.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.25 },
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
				scale = { 0.25 }
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
			count = { 5, 10 },
			delay = { 1 / 10 }
		}
	}

	self:_updateDirection(self._outerParticleDefinition.emitters[2], 0.5)

	return self._outerParticleDefinition
end

function FireView:_getSmokeParticleDefinition()
	self._smokeParticleDefinition = self._smokeParticleDefinition or {
		numParticles = 25,
		texture = "Resources/Game/Props/Common/Particle_Smoke.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.125 },
				position = { 0, 2, 0 },
				yRange = { 0, 0 },
				lifetime = { 0.5, 3 },
				normal = { true }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.75, 1 },
			},
			{
				type = "RandomColorEmitter",
				colors = self:getSmokeColors()
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.4, 0.5 }
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
			delay = { 1 / 10 }
		}
	}

	self:_updateDirection(self._smokeParticleDefinition.emitters[2], 0.2)
	self._smokeParticleDefinition.emitters[1].position[1] = self._smokeParticleDefinition.emitters[2].direction[1] * self.HEIGHT
	self._smokeParticleDefinition.emitters[1].position[2] = self._smokeParticleDefinition.emitters[2].direction[2] * self.HEIGHT
	self._smokeParticleDefinition.emitters[1].position[3] = self._smokeParticleDefinition.emitters[2].direction[3] * self.HEIGHT

	return self._smokeParticleDefinition
end

function FireView:getSmokeColors()
	return {
		{ 0.2, 0.2, 0.2, 0.0 },
		{ 0.2, 0.2, 0.2, 0.0 },
		{ 0.2, 0.2, 0.2, 0.0 },
		{ 0.3, 0.3, 0.3, 0.0 },
		{ 0.1, 0.1, 0.1, 0.0 },
	}
end

function FireView:getInnerColors()
	return {
		{ Color.fromHexString("ffd52a"):get() },
		{ Color.fromHexString("ffd52a"):get() },
		{ Color.fromHexString("ffd52a"):get() },
		{ Color.fromHexString("ffd52a"):get() },
	}
end

function FireView:getOuterColors()
	return {
		{ 1, 0.4, 0.0, 0.0 },
		{ 0.9, 0.4, 0.0, 0.0 },
		{ 1, 0.5, 0.0, 0.0 },
		{ 0.9, 0.5, 0.0, 0.0 },
	}
end

function FireView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Fire.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				ModelResource,
				self:getResourcePath("Fire.lmodel"),
				function(model)
					self.model = model
				end,
				self.skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Idle.lanim"),
				function(animation)
					self.animation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.node:setModel(self.model)
				self.node:getMaterial():setTextures(self.texture)
				self.node:setParent(root)

				self.light = PointLightSceneNode()
				self.light:getTransform():setLocalTranslation(Vector(0, 0.5, 0.5))
				self.light:setParent(root)

				self.animation:computeFilteredTransforms(0, self.transforms)
				self.skeleton:getResource():applyBindPose(self.transforms)

				self.node:setTransforms(self.transforms)

				self.time = 0.0
				self.spawned = true
			end)
		end)
	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.outerFlames = ParticleSceneNode()
		self.outerFlames:initParticleSystemFromDef(self:_getOuterParticleDefinition(), resources)
		self.outerFlames:setParent(self.node)

		self.innerFlames = ParticleSceneNode()
		self.innerFlames:initParticleSystemFromDef(self:_getInnerParticleDefinition(), resources)
		self.innerFlames:setParent(self.node)

		self.smoke = ParticleSceneNode()
		self.smoke:getMaterial():setIsFullLit(false)
		self.smoke:initParticleSystemFromDef(self:_getSmokeParticleDefinition(), resources)
		self.smoke:setParent(self.node)
	end)
end

function FireView:flicker()
	if self.light then
		local flickerWidth = self.MAX_FLICKER_TIME - self.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + self.MIN_FLICKER_TIME

		local min, max = self:getProp():getBounds()
		local size = max - min
		local scale = 1.0 + size:getLength()
		local attenuationWidth = self.MAX_ATTENUATION - self.MIN_ATTENUATION
		local attenuation = love.math.random() * attenuationWidth + self.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = self.MAX_COLOR_BRIGHTNESS - self.MIN_COLOR_BRIGHTNESS
		local brightness = love.math.random() * brightnessWidth + self.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness * self.COLOR.r, brightness * self.COLOR.g, brightness * self.COLOR.b, 1)
		self.light:setColor(color)
	end
end

function FireView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.duration and state.duration < 0.5 then
		self.node:getTransform():setLocalScale(Vector(state.duration / 0.5))
	end
end

function FireView:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta

	if self.flickerTime < 0 then
		self:flicker()
	end

	if self.spawned then
		self.time = self.time + delta

		self.animation:computeFilteredTransforms(self.time, self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)

		if self.outerFlames then
			self.outerFlames:initEmittersFromDef(self:_getOuterParticleDefinition().emitters)
		end

		if self.innerFlames then
			self.innerFlames:initEmittersFromDef(self:_getInnerParticleDefinition().emitters)
		end

		if self.smoke then
			self.smoke:initEmittersFromDef(self:_getSmokeParticleDefinition().emitters)
		end
	end
end

return FireView
