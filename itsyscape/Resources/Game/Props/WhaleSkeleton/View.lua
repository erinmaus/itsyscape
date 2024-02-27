--------------------------------------------------------------------------------
-- Resources/Game/Props/WhaleSkeleton/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local WhaleSkeleton = Class(PropView)

function WhaleSkeleton:getBaseFilename()
	return "Resources/Game/Props/WhaleSkeleton"
end

function WhaleSkeleton:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function WhaleSkeleton:applyAnimation()
	self.transforms:reset()
	self.idleAnimation:computeFilteredTransforms(self.time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function WhaleSkeleton:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()
	self.time = 0

	resources:queue(
		SkeletonResource,
		self:getResourcePath("WhaleSkeleton.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Idle.lanim"),
				function(animation)
					self.idleAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.node:setModel(self.model)
				self.node:setTransforms(self.transforms)
				self.node:getMaterial():setTextures(self.texture)
				self.node:setParent(root)
				self:applyAnimation()

				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("WhaleSkeleton.lmesh"),
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

function WhaleSkeleton:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self.idleAnimation:getDuration())
		self:applyAnimation()

		if self.time >= self.idleAnimation:getDuration() then
			self.time = 0
		end
	end
end

return WhaleSkeleton
