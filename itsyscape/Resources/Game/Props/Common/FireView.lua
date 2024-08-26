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
FireView.MIN_ATTENUATION = 0.5
FireView.MAX_ATTENUATION = 1.5
FireView.MIN_COLOR_BRIGHTNESS = 0.9
FireView.MAX_COLOR_BRIGHTNESS = 1.0

FireView.FLAME = {
	numParticles = 50,
	texture = "Resources/Game/Props/Lamp_IsabelleTower/Flame.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 0.25 },
			position = { 0, 0.4, 0 },
			yRange = { 0, 0 },
			lifetime = { 1.5, 0.4 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.5, 0.5 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 },
			}
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.1 }
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
		delay = { 1 / 30 }
	}
}

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
		self.flames = ParticleSceneNode()
		self.flames:initParticleSystemFromDef(FireView.FLAME, resources)
		self.flames:setParent(self.node)
	end)
end

function FireView:flicker()
	if self.light then
		local flickerWidth = FireView.MAX_FLICKER_TIME - FireView.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + FireView.MIN_FLICKER_TIME

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = FireView.MAX_ATTENUATION - FireView.MIN_ATTENUATION
		local attenuation = love.math.random() * attenuationWidth + FireView.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = FireView.MAX_COLOR_BRIGHTNESS - FireView.MIN_COLOR_BRIGHTNESS
		local brightness = love.math.random() * brightnessWidth + FireView.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness, brightness, brightness, 1)
		self.light:setColor(color)
	end
end

function FireView:tick()
	PropView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end

	local state = self:getProp():getState()
	if state.duration and state.duration < 0.5 then
		self.node:getTransform():setLocalScale(Vector(state.duration / 0.5))
	end
end

function FireView:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta

	if self.spawned then
		self.time = self.time + delta

		self.animation:computeFilteredTransforms(self.time, self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)
	end
end

return FireView
