--------------------------------------------------------------------------------
-- Resources/Game/Props/WhaleSkeletonStatue/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local WhaleSkeletonStatue = Class(PropView)

function WhaleSkeletonStatue:getBaseFilename()
	return "Resources/Game/Props/WhaleSkeletonStatue"
end

function WhaleSkeletonStatue:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function WhaleSkeletonStatue:applyAnimation()
	self.transforms:reset()
	self.idleAnimation:computeFilteredTransforms(self.time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function WhaleSkeletonStatue:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.concreteNode = ModelSceneNode()
	self.skeletonNode = ModelSceneNode()
	self.vineLeavesNode = ModelSceneNode()
	self.time = 0

	resources:queue(
		SkeletonResource,
		self:getResourcePath("WhaleSkeletonStatue.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				ModelResource,
				self:getResourcePath("Concrete.lmesh"),
				function(model)
					self.concreteModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath("Skeleton.lmesh"),
				function(model)
					self.skeletonModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath("VineLeaves.lmesh"),
				function(model)
					self.vineLeavesModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Idle.lanim"),
				function(animation)
					self.idleAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.concreteNode:setModel(self.concreteModel)
				self.concreteNode:setTransforms(self.transforms)
				self.concreteNode:getMaterial():setShader(self.shader)
				self.concreteNode:getMaterial():setTextures(self.concreteTexture)
				self.concreteNode:setParent(root)
				self.concreteNode:getMaterial():setOutlineThreshold(-0.005)
				self.concreteNode:onWillRender(function(renderer)
					local currentShader = renderer:getCurrentShader()
					if currentShader and currentShader:hasUniform("scape_BumpHeight") then
						currentShader:send("scape_BumpHeight", 4)
					end
				end)

				self.vineLeavesNode:setModel(self.vineLeavesModel)
				self.vineLeavesNode:setTransforms(self.transforms)
				self.vineLeavesNode:getMaterial():setShader(self.shader)
				self.vineLeavesNode:getMaterial():setTextures(self.vineLeavesTexture)
				self.vineLeavesNode:setParent(root)
				self.vineLeavesNode:getMaterial():setOutlineThreshold(-0.005)
				self.vineLeavesNode:getMaterial():setOutlineColor(Color(0.5))
				self.vineLeavesNode:getMaterial():setIsParticulate(true)
				self.vineLeavesNode:onWillRender(function(renderer)
					local currentShader = renderer:getCurrentShader()
					if currentShader and currentShader:hasUniform("scape_BumpHeight") then
						currentShader:send("scape_BumpHeight", 1)
					end
				end)

				self.skeletonNode:setModel(self.skeletonModel)
				self.skeletonNode:setTransforms(self.transforms)
				self.skeletonNode:getMaterial():setTextures(self.skeletonTexture)
				self.skeletonNode:setParent(root)

				self:applyAnimation()

				self.spawned = true
			end)
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Concrete.png"),
		function(texture)
			self.concreteTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Skeleton.png"),
		function(texture)
			self.skeletonTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("VineLeaves.png"),
		function(texture)
			self.vineLeavesTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularBumpSkinnedModel",
		function(shader)
			self.shader = shader
		end)
end

function WhaleSkeletonStatue:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self.idleAnimation:getDuration())
		self:applyAnimation()

		if self.time >= self.idleAnimation:getDuration() then
			self.time = 0
		end
	end
end

return WhaleSkeletonStatue
