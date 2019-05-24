--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_Lever/View.lua
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

local Lever = Class(PropView)
Lever.ANIMATION_UP = 1
Lever.ANIMATION_DOWN = 2

function Lever:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.down = false
	self.spawned = false
	self.time = false
	self.isPlayingPullAnimation = false
	self.transforms = {}
end

function Lever:getCurrentAnimation()
	if self.currentAnimation == Lever.ANIMATION_UP then
		return self.upAnimation
	elseif self.currentAnimation == Lever.ANIMATION_DOWN then
		return self.downAnimation
	else
		return nil
	end
end

function Lever:getResourcePath(resource)
	return string.format("Resources/Game/Props/HighChambersYendor_Lever/%s", resource)
end

function Lever:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()
	self.node:getTransform():setLocalScale(Vector(1, 0.5, 1))

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Lever.lskel"),
		function(skeleton)
			self.skeleton = skeleton

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("LeverPull.lanim"),
				function(animation)
					self.pullAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("LeverUp.lanim"),
				function(animation)
					self.upAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("LeverDown.lanim"),
				function(animation)
					self.downAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.node:setModel(self.model)
				self.node:getMaterial():setTextures(self.texture)
				self.node:setParent(root)

				self.upAnimation:computeTransforms(0, self.transforms)
				self.node:setTransforms(self.transforms)

				local state = self:getProp():getState()
				if state.down then
					self.currentAnimation = Lever.ANIMATION_UP
					self.down = true
				else
					self.currentAnimation = Lever.ANIMATION_DOWN
					self.down = false
				end

				self.time = self:getCurrentAnimation():getDuration()
				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Lever.lmesh"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.model = model
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Lever.png"),
		function(texture)
			self.texture = texture
		end)
end

function Lever:tick()
	PropView.tick(self)

	if self.spawned then
		local state = self:getProp():getState()
		if state.down ~= self.down then
			if state.down then
				self.currentAnimation = Lever.ANIMATION_UP
				self.down = true
				self.time = self.pullAnimation:getDuration()
			else
				self.currentAnimation = Lever.ANIMATION_DOWN
				self.down = false
				self.time = 0
			end

			self.isPlayingPullAnimation = true
		end
	end
end

function Lever:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		if self.currentAnimation == Lever.ANIMATION_DOWN then
			self.time = math.min(self.time + delta, self.pullAnimation:getDuration())

			if self.time >= self.pullAnimation:getDuration() then
				self.isPlayingPullAnimation = false
			end
		elseif self.currentAnimation == Lever.ANIMATION_UP then
			self.time = math.max(self.time - delta, 0)

			if self.time <= 0 then
				self.isPlayingPullAnimation = false
			end
		end

		if self.isPlayingPullAnimation then
			self.pullAnimation:computeTransforms(self.time, self.transforms)
		else
			self:getCurrentAnimation():computeTransforms(self.time, self.transforms)
		end

		self.node:setTransforms(self.transforms)
	end
end

return Lever
