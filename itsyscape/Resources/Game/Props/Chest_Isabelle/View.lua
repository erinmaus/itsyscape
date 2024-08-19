--------------------------------------------------------------------------------
-- Resources/Game/Props/Chest_Isabelle/View.lua
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
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Chest = Class(PropView)
Chest.ANIMATION_OPEN = 1
Chest.ANIMATION_CLOSE = 2

function Chest:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.isOpen = false
	self.spawned = false
	self.time = 0
end

function Chest:getBaseFilename()
	return "Resources/Game/Props/Chest_Isabelle"
end

function Chest:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function Chest:getCurrentAnimation()
	if self.currentAnimation == Chest.ANIMATION_OPEN then
		return self.openAnimation
	elseif self.currentAnimation == Chest.ANIMATION_CLOSE then
		return self.closeAnimation
	else
		return nil
	end
end

function Chest:load()
	PropView.load(self)

	local resources = self:getResources()

	local root = self:getRoot()
	local modelRoot = SceneNode()
	modelRoot:setParent(root)
	modelRoot:getTransform():setLocalScale(Vector(0.5))

	self.chestNode = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Chest.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Open.lanim"),
				function(animation)
					self.openAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath("Close.lanim"),
				function(animation)
					self.closeAnimation = animation:getResource()
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.chestNode:setModel(self.chestModel)
				self.chestNode:getMaterial():setTextures(self.diffuseTexture, self.specularTexture)
				self.chestNode:getMaterial():setShader(self.velvetShader)
				--self.chestNode:getMaterial():setOutlineThreshold(0.5)
				self.chestNode:setParent(modelRoot)
				self.chestNode:onWillRender(function(renderer)
					local shader = renderer:getCurrentShader()
					if shader and shader:hasUniform("scape_SpecularTexture") then
						shader:send("scape_SpecularTexture", self.specularTexture:getResource())
					end
				end)

				self.openAnimation:computeFilteredTransforms(0, self.transforms)
				self.skeleton:getResource():applyTransforms(self.transforms)
				self.skeleton:getResource():applyBindPose(self.transforms)

				self.chestNode:setTransforms(self.transforms)

				local state = self:getProp():getState()
				if state.isOpen then
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
		self:getResourcePath("Chest.lmesh"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.chestModel = model	
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Chest.png"),
		function(texture)
			self.diffuseTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Chest_Specular.png"),
		function(texture)
			self.specularTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/VelvetSkinnedModel",
		function(shader)
			self.velvetShader = shader
		end)
end

function Chest:playOpenAnimation()
	self.currentAnimation = Chest.ANIMATION_OPEN
	self.isOpen = true
end

function Chest:playCloseAnimation()
	self.currentAnimation = Chest.ANIMATION_CLOSE
	self.isOpen = false
end

function Chest:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.isOpen ~= self.isOpen then
		local animation = self:getCurrentAnimation()
		if animation then
			self.time = animation:getDuration() - self.time
		else
			self.time = 0
		end

		if state.isOpen then
			self:playOpenAnimation()
		else
			self:playCloseAnimation()
		end
	end
end

function Chest:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self:getCurrentAnimation():getDuration())
		self:getCurrentAnimation():computeFilteredTransforms(self.time, self.transforms)
		self.skeleton:getResource():applyTransforms(self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)
	end
end

return Chest
