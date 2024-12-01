--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/SailView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local SailView = Class(PropView)

SailView.SIZE_CLASS_GALLEON    = "Galleon"
SailView.SIZE_CLASS_BRIGANTINE = "Brigantine"
SailView.SIZE_CLASS_SLOOP      = "Sloop"

SailView.POSITION_TYPE_FORE = "Fore"
SailView.POSITION_TYPE_MAIN = "Main"
SailView.POSITION_TYPE_REAR = "Rear"

SailView.HOIST_ANIMATION_DURATION = 0.5

function SailView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.power = 0
	self.hoisted = true
	self.hoistedTime = self.HOIST_ANIMATION_DURATION
end

function SailView:getSizeClass()
	return Class.ABSTRACT()
end

function SailView:getPositionType()
	return Class.ABSTRACT()
end

function SailView:getCommonResourcePath(filename)
	return string.format("ItsyScape/Resources/Game/SailingItems/Common/Sail/Sail_%s_%s_%s", self:getSizeClass(), self:getPositionType(), filename)
end

function SailView:getTextureResourcePath(filename)
	local state = self:getShipState()

	local resource = state and state.resource
	resource = resource or "Sail_Common"

	return string.format("ItsyScape/Resources/Game/SailingItems/%s/%s", filename)
end

function SailView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.sailNode = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getCommonResourcePath("Skeleton.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				ModelResource,
				self:getCommonResourcePath("Model.lmodel"),
				function(model)
					self.sailModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getCommonResourcePath("Animation_Wind.lanim"),
				function(animation)
					self.windAnimation = animation
				end)
			resources:queue(
				SkeletonAnimationResource,
				self:getCommonResourcePath("Animation_Hoisted.lanim"),
				function(animation)
					self.hoistedAnimation = animation
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.sailNode:getMaterial():setShader(self.sailShader)
				self.sailNode:setModel(self.sailModel)
				self.sailNode:setParent(root)
				self.sailNode:setTransforms(self.transforms)

				local state = self:getShipState()
				if state and state.sailsHoisted then
					self.hoisted = true
				else
					self.hoisted = false
				end

				self.spawned = true
				self:updateAnimation(0)
			end)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/SailModel",
		function(shader)
			self.sailShader = shader
		end)

	self:updateTextures()
end

function SailView:updateTextures()
	local resources = self:getResources()

	local state = self:getProp():getState()
	local resource = state and state.resource
	resource = resource or "Sail_Common"

	if resource == self.textureResource then
		return
	end

	self.textureResource = resource

	resources:queue(
		TextureResource,
		self:getTextureResourcePath("Custom.png"),
		function(texture)
			self.customTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getTextureResourcePath("Static.png"),
		function(texture)
			self.staticTexture = texture
		end)
	resources:queueEvent(function()
		local material = self.sailNode:getMaterial()

		material:setTextures(self.staticTexture, self.customTexture)
		material:send(material.UNIFORM_TEXTURE, "scape_CustomDiffuseTexture", self.customTexture)
	end)

	if state.colors then
		if state.colors[1] then
			material:send(material.UNIFORM_FLOAT, "scape_PrimaryColor", state.colors[1])
		end

		if state.colors[2] then
			material:send(material.UNIFORM_FLOAT, "scape_SecondaryColor", state.colors[2])
		end
	end
end

-- function SailView:getWorldPosition(modelPosition, boneWeights)
-- 	if not self.spawned then
-- 		return nil
-- 	end

-- 	local skeleton = self.skeleton:getResource()
-- 	local localPosition = Vector.ZERO
-- 	for _, boneWeight in ipairs(boneWeights) do
-- 		local boneName, boneWeight = unpack(boneWeight)

-- 		local boneIndex = self.skeleton:getResource():getBoneIndex(boneName)
-- 		if boneIndex > 0 then
-- 			local transform = self.transforms:getTransform(boneIndex)
-- 			localPosition = localPosition + Vector(transform:transformPoint(modelPosition:get())) * boneWeight
-- 		end
-- 	end

-- 	local transform = self:getRoot():getTransform():getGlobalTransform()
-- 	local resultPosition = 
-- end

function SailView:getShipState()
	return self:getShipState().shipState
end

function SailView:updateState()
	local state = self:getShipState()
	if not state then
		return
	end

	local hoisted = state.sailsHoisted
	if self.hoisted ~= hoisted then
		self:hoist(hoisted)
	end

	self.power = state.windPower or 0
end

function SailView:hoist(hoisted)
	self.hoistedTime = self.HOIST_ANIMATION_DURATION - self.hoistedTime
	self.hoisted = hoisted
end

function SailView:applyAnimation(time, animation)
	self.transforms:reset()
	animation:computeFilteredTransforms(time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function SailView:updateAnimation(delta)
	local blendHoist = self.hoistedAnimation < self.HOIST_ANIMATION_DURATION

	local currentAnimation, currentTime
	if blendHoist then
		local fromAnimation = self.windAnimation
		local fromTime = self.power * self.windAnimation:getDuration()

		local toAnimation = self.hoistedAnimation
		local toTime = 0

		if not self.hoisted then
			fromAnimation, toAnimation = toAnimation, fromAnimation
			fromTime, toTime = toTime, fromTime
		end

		currentAnimation = SkeletonAnimation.blend(
			self.skeleton:getResource(),
			fromAnimation,
			fromTime,
			toAnimation,
			toTime,
			self.HOIST_ANIMATION_DURATION)
		currentTime = self.hoistedTime
	else
		if self.hoisted then
			currentAnimation = self.hoistedAnimation
			currentTime = 0
		else
			currentAnimation = self.windAnimation
			currentTime = self.power * self.windAnimation:getDuration()
		end
	end
	self:applyAnimation(currentAnimation, currentTime)

	self.hoistedTime = math.min(self.hoistedTime + delta, self.HOIST_ANIMATION_DURATION)
end

function SailView:tick()
	PropView.tick(self)

	self:updateTextures()
end

function SailView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self:updateState()
		self:updateAnimation(delta)
	end
end

return SailView
