--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/TreeView.lua
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
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local TreeView = Class(PropView)
TreeView.ANIMATION_SPAWNED = 1
TreeView.ANIMATION_IDLE    = 2
TreeView.ANIMATION_CHOPPED = 3
TreeView.ANIMATION_FELLED  = 4

function TreeView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.previousProgress = 0
	self.shaken = 0
	self.spawned = false
	self.depleted = false
	self.time = false
	self.transforms = {}
	self.animations = {}
end

function TreeView:getBaseFilename()
	return Class.ABSTRACT()
end

function TreeView:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function TreeView:getCurrentAnimation()
	return self.animations[self.currentAnimation]
	    or self.animations[TreeView.ANIMATION_IDLE]
end

function TreeView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Tree.lskel"),
		function(skeleton)
			self.skeleton = skeleton

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Spawn.lanim"),
				function(animation)
					self.animations[TreeView.ANIMATION_SPAWNED] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Idle.lanim"),
				function(animation)
					self.animations[TreeView.ANIMATION_IDLE] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Chopped.lanim"),
				function(animation)
					self.animations[TreeView.ANIMATION_CHOPPED] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Felled.lanim"),
				function(animation)
					self.animations[TreeView.ANIMATION_FELLED] = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.node:setModel(self.model)
				self.node:getMaterial():setTextures(self.texture)
				self.node:setParent(root)

				local idleDuration = self.animations[TreeView.ANIMATION_IDLE]:getDuration()

				self.node:onWillRender(function()
					local animation = self:getCurrentAnimation()
					if (self.currentAnimation ~= TreeView.ANIMATION_IDLE and idleDuration <= 1 / 30) or
					   self.time <= animation:getDuration()
					then
						animation:computeTransforms(self.time, self.transforms)
						self.node:setTransforms(self.transforms)
					end
				end)

				local offset = idleDuration * math.random()
				self.animations[TreeView.ANIMATION_IDLE]:computeTransforms(offset, self.transforms)
				self.node:setTransforms(self.transforms)

				local state = self:getProp():getState().resource
				if state then
					if state.depleted then
						self.currentAnimation = TreeView.ANIMATION_FELLED
						self.time = self.animations[TreeView.ANIMATION_FELLED]:getDuration()
						self.depleted = true
					else
						self.currentAnimation = TreeView.ANIMATION_IDLE
						self.time = 0
						self.depleted = false
					end

					self.shaken = state.shaken
				end

				self.time = self:getCurrentAnimation():getDuration()
				self.spawned = true
			end)
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Tree.lmodel"),
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
	if love.filesystem.getInfo(self:getResourcePath("Depleted.png")) then
		resources:queue(
			TextureResource,
			self:getResourcePath("Depleted.png"),
			function(depletedTexture)
				self.depletedTexture = depletedTexture
			end)
	end
end

function TreeView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function TreeView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 2, 0),
				self:getProp())
		end

		if self.previousProgress ~= r.progress or self.shaken ~= r.shaken then
			self:getResources():queueEvent(function()
				self.currentAnimation = TreeView.ANIMATION_CHOPPED
				self.time = 0
			end)

			self.previousProgress = r.progress
			self.shaken = r.shaken

			if self.shaken > 0 and self.depletedTexture then
				self.node:getMaterial():setTextures(self.depletedTexture)
			elseif self.shaken <= 0 and self.texture then
				self.node:getMaterial():setTextures(self.texture)
			end
		end

		if r.depleted ~= self.depleted then
			self:getResources():queueEvent(function()
				if r.depleted then
					self.currentAnimation = TreeView.ANIMATION_FELLED
				else
					self.currentAnimation = TreeView.ANIMATION_SPAWNED
				end
			end)

			self.depleted = r.depleted
		end
	end
end

function TreeView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		local animation = self:getCurrentAnimation()
		self.time = math.min(self.time + delta, animation:getDuration())

		if (self.currentAnimation == TreeView.ANIMATION_CHOPPED or
			self.currentAnimation == TreeView.ANIMATION_IDLE) and
			self.time >= animation:getDuration()
		then
			self.time = 0
			self.currentAnimation = TreeView.ANIMATION_IDLE
		end
	end
end

return TreeView
