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

SailView.HOIST_ANIMATION_DURATION  = 0.5
SailView.HIDE_FADE_IN_OUT_DURATION = 0.5

function SailView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.spawned = false
	self.power = 0
	self.hoisted = true
	self.hoistedTime = self.HOIST_ANIMATION_DURATION

	self.hiddenTime = 0
	self.isHidden = false
end

function SailView:getSizeClass()
	return Class.ABSTRACT()
end

function SailView:getPositionType()
	return Class.ABSTRACT()
end

function SailView:getCommonResourcePath(filename)
	return string.format("Resources/Game/SailingItems/Common/Sail/Sail_%sMast_%s", self:getPositionType(), filename)
end

function SailView:getTextureResourcePath(filename)
	local state = self:getShipState()

	local resource = state and state.resource
	resource = resource or "Sail_Common"

	return string.format("Resources/Game/SailingItems/%s/%s_%s", resource, self:getPositionType(), filename)
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
					self.windAnimation = animation:getResource()
				end,
				self.skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getCommonResourcePath("Animation_Hoisted.lanim"),
				function(animation)
					self.hoistedAnimation = animation:getResource()
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
		material:send(material.UNIFORM_TEXTURE, "scape_CustomDiffuseTexture", self.customTexture:getResource())
	end)

	if state.colors then
		local material = self.sailNode:getMaterial()

		if state.colors[1] then
			material:send(material.UNIFORM_FLOAT, "scape_PrimaryColor", state.colors[1])
		end

		if state.colors[2] then
			material:send(material.UNIFORM_FLOAT, "scape_SecondaryColor", state.colors[2])
		end
	end
end

function SailView:updateWind()
	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	local material = self.sailNode:getMaterial()
	material:send(material.UNIFORM_FLOAT, "scape_BumpForce", 0)
	material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
	material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", 2)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 2.0, 2.0, 2.0, 2.0)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackAlpha", 0.0)
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
	return self:getProp():getState().shipState
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
	local blendHoist = self.hoistedTime < self.HOIST_ANIMATION_DURATION

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

		local hoistedDelta = self.hoistedTime / self.HOIST_ANIMATION_DURATION
		hoistedDelta = Tween.sineEaseOut(hoistedDelta)

		currentAnimation = SkeletonAnimation.blend(
			self.skeleton:getResource(),
			fromAnimation,
			fromTime,
			toAnimation,
			toTime,
			self.HOIST_ANIMATION_DURATION)
		currentTime = hoistedDelta * self.HOIST_ANIMATION_DURATION
	else
		if self.hoisted then
			currentAnimation = self.hoistedAnimation
			currentTime = 0
		else
			currentAnimation = self.windAnimation
			currentTime = self.power * self.windAnimation:getDuration()
		end
	end
	self:applyAnimation(currentTime, currentAnimation)

	self.hoistedTime = math.min(self.hoistedTime + delta, self.HOIST_ANIMATION_DURATION)
end

function SailView:updateHiding(delta)
	local uiView = _APP:getUIView()
	local isHidden = uiView:getInterface("Cannon") ~= nil or uiView:getInterface("Helm") ~= nil
	if isHidden ~= self.isHidden then
		self.hiddenTime = self.HIDE_FADE_IN_OUT_DURATION - self.hiddenTime
		self.isHidden = isHidden
	end

	self.hiddenTime = math.min(self.hiddenTime + delta, self.HIDE_FADE_IN_OUT_DURATION)

	local alpha = math.clamp(self.hiddenTime / self.HIDE_FADE_IN_OUT_DURATION)
	if self.isHidden then
		alpha = 1 - alpha
	end

	self.sailNode:getMaterial():setColor(Color(1, 1, 1, alpha))
end

function SailView:tick()
	PropView.tick(self)

	self:updateTextures()
	self:updateWind()
end

function SailView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self:updateState()
		self:updateAnimation(delta)
		self:updateHiding(delta)
	end
end

return SailView
