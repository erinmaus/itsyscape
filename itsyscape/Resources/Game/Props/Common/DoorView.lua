--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/DoorView.lua
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
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local DoorView = Class(PropView)
DoorView.ANIMATION_OPEN = 1
DoorView.ANIMATION_CLOSE = 2

function DoorView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.open = false
	self.spawned = false
	self.time = false
	self.transforms = {}
end

function DoorView:getBaseFilename()
	return Class.ABSTRACT()
end

function DoorView:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function DoorView:getCurrentAnimation()
	if self.currentAnimation == DoorView.ANIMATION_OPEN then
		return self.openAnimation
	elseif self.currentAnimation == DoorView.ANIMATION_CLOSE then
		return self.closeAnimation
	else
		return nil
	end
end

function DoorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Door.lskel"),
		function(skeleton)
			self.skeleton = skeleton

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("DoorOpen.lanim"),
				function(animation)
					self.openAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("DoorClose.lanim"),
				function(animation)
					self.closeAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.node:setModel(self.model)
				self.node:getMaterial():setTextures(self.texture)
				self.node:setParent(root)

				self.openAnimation:computeTransforms(0, self.transforms)
				self.node:setTransforms(self.transforms)

				local state = self:getProp():getState()
				if state.open then
					self:playOpenAnimation()
				else
					self:playCloseAnimation()
				end

				self.time = self:getCurrentAnimation():getDuration()
				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Door.lmodel"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.model = model
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Texture.png"),
		function(texture)
			self.texture = texture
		end)
end

function DoorView:playOpenAnimation()
	self.currentAnimation = DoorView.ANIMATION_OPEN
	self.open = true
end

function DoorView:playCloseAnimation()
	self.currentAnimation = DoorView.ANIMATION_CLOSE
	self.open = false
end

function DoorView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.open ~= self.open then
		if state.open then
			self:playOpenAnimation()
		else
			self:playCloseAnimation()
		end

		self.time = 0
	end
end

function DoorView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self:getCurrentAnimation():getDuration())
		self:getCurrentAnimation():computeTransforms(self.time, self.transforms)
		self.node:setTransforms(self.transforms)
	end
end

return DoorView
