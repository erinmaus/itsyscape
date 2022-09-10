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
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local FireView = Class(PropView)
FireView.MIN_FLICKER_TIME = 10 / 60
FireView.MAX_FLICKER_TIME = 20 / 60
FireView.MIN_ATTENUATION = 0.5
FireView.MAX_ATTENUATION = 1.5
FireView.MIN_COLOR_BRIGHTNESS = 0.9
FireView.MAX_COLOR_BRIGHTNESS = 1.0

function FireView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.flickerTime = 0
	self.transforms = {}
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

				self.animation:computeTransforms(0, self.transforms)
				self.node:setTransforms(self.transforms)

				self.time = 0.0
				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Fire.lmodel"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.model = model
		end)
	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
end

function FireView:flicker()
	if self.light then
		local flickerWidth = FireView.MAX_FLICKER_TIME - FireView.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + FireView.MIN_FLICKER_TIME

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = FireView.MAX_ATTENUATION - FireView.MIN_ATTENUATION
		local attenuation = math.random() * attenuationWidth + FireView.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = FireView.MAX_COLOR_BRIGHTNESS - FireView.MIN_COLOR_BRIGHTNESS
		local brightness = math.random() * brightnessWidth + FireView.MAX_COLOR_BRIGHTNESS
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

		self.animation:computeTransforms(self.time, self.transforms)
		self.node:setTransforms(self.transforms)
	end
end

return FireView
