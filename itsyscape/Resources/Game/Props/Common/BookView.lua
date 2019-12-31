--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/BookView.lua
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

local BookView = Class(PropView)
BookView.ANIMATION_OPEN = 1
BookView.ANIMATION_CLOSE = 2

function BookView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.open = false
	self.spawned = false
	self.time = false
	self.transforms = {}
end

function BookView:getBaseFilename()
	return Class.ABSTRACT()
end

function BookView:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function BookView:getCurrentAnimation()
	if self.currentAnimation == BookView.ANIMATION_OPEN then
		return self.openAnimation
	elseif self.currentAnimation == BookView.ANIMATION_CLOSE then
		return self.closeAnimation
	else
		return nil
	end
end

function BookView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Book.lskel"),
		function(skeleton)
			self.skeleton = skeleton

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("BookOpen.lanim"),
				function(animation)
					self.openAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("BookClose.lanim"),
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
					self.currentAnimation = BookView.ANIMATION_OPEN
					self.open = true
				else
					self.currentAnimation = BookView.ANIMATION_CLOSE
					self.open = false
				end

				self.time = self:getCurrentAnimation():getDuration()
				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Book.lmodel"),
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

function BookView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.open ~= self.open then
		if state.open then
			self.currentAnimation = BookView.ANIMATION_OPEN
			self.open = true
		else
			self.currentAnimation = BookView.ANIMATION_CLOSE
			self.open = false
		end

		self.time = 0
	end
end

function BookView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self:getCurrentAnimation():getDuration())
		self:getCurrentAnimation():computeTransforms(self.time, self.transforms)
		self.node:setTransforms(self.transforms)
	end
end

return BookView
