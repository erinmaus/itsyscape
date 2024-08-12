--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Armoire.lua
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
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Armoire = Class(PropView)
Armoire.ANIMATION_OPEN = 1
Armoire.ANIMATION_CLOSE = 2

function Armoire:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.isOpen = false
	self.spawned = false
	self.time = 0
end

function Armoire:getBaseFilename()
	return "Resources/Game/Props/Armoire_Isabelle"
end

function Armoire:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function Armoire:getCurrentAnimation()
	if self.currentAnimation == Armoire.ANIMATION_OPEN then
		return self.openAnimation
	elseif self.currentAnimation == Armoire.ANIMATION_CLOSE then
		return self.closeAnimation
	else
		return nil
	end
end

function Armoire:load()
	PropView.load(self)

	local resources = self:getResources()

	local root = self:getRoot()
	local modelRoot = SceneNode()
	modelRoot:setParent(root)
	modelRoot:getTransform():setLocalScale(Vector(0.6))

	self.interiorNode = ModelSceneNode()
	self.exteriorNode = ModelSceneNode()
	self.doorsNode = ModelSceneNode()
	self.clothesNode = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Armoire.lskel"),
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
				self.interiorNode:setModel(self.interiorModel)
				self.interiorNode:getMaterial():setTextures(self.interiorTexture)
				self.interiorNode:setParent(modelRoot)

				self.exteriorNode:setModel(self.exteriorModel)
				self.exteriorNode:getMaterial():setTextures(self.exteriorTexture)
				self.exteriorNode:setParent(modelRoot)

				self.doorsNode:setModel(self.doorsModel)
				self.doorsNode:getMaterial():setTextures(self.doorsTexture)
				self.doorsNode:setParent(modelRoot)

				self.clothesNode:setModel(self.clothesModel)
				self.clothesNode:getMaterial():setTextures(self.clothesTexture)
				self.clothesNode:setParent(modelRoot)

				self.openAnimation:computeFilteredTransforms(0, self.transforms)
				self.skeleton:getResource():applyTransforms(self.transforms)
				self.skeleton:getResource():applyBindPose(self.transforms)

				self.interiorNode:setTransforms(self.transforms)
				self.exteriorNode:setTransforms(self.transforms)
				self.doorsNode:setTransforms(self.transforms)
				self.clothesNode:setTransforms(self.transforms)

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
		self:getResourcePath("Interior.lmesh"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.interiorModel = model	
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Exterior.lmesh"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.exteriorModel = model
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Doors.lmesh"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.doorsModel = model
		end)
	resources:queue(
		ModelResource,
		self:getResourcePath("Clothes.lmesh"),
		function(model)
			model:getResource():bindSkeleton(self.skeleton:getResource())
			self.clothesModel = model
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Exterior.png"),
		function(texture)
			self.exteriorTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Interior.png"),
		function(texture)
			self.interiorTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Doors.png"),
		function(texture)
			self.doorsTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath("Clothes.png"),
		function(texture)
			self.clothesTexture = texture
		end)
end

function Armoire:playOpenAnimation()
	self.currentAnimation = Armoire.ANIMATION_OPEN
	self.isOpen = true
end

function Armoire:playCloseAnimation()
	self.currentAnimation = Armoire.ANIMATION_CLOSE
	self.isOpen = false
end

function Armoire:tick()
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

function Armoire:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self:getCurrentAnimation():getDuration())
		self:getCurrentAnimation():computeFilteredTransforms(self.time, self.transforms)
		self.skeleton:getResource():applyTransforms(self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)
	end
end

return Armoire
