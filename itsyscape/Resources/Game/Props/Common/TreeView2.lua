--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/TreeView2.lua
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
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local TreeView = Class(PropView)

TreeView.FELLED_SPAWN_TIME_SECONDS = 0.75

function TreeView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.previousProgress = 0
	self.shaken = 0
	self.spawned = false
	self.depleted = false
	self.time = 0
	self._transform = love.math.newTransform()
	self._color = Color(1, 1, 1, 1)
end

function TreeView:getBaseModelFilename()
	return Class.ABSTRACT()
end

function TreeView:getBaseTextureFilename()
	return Class.ABSTRACT()
end

function TreeView:getResourcePath(Type, resource)
	if Type == TextureResource then
		return string.format("%s/%s", self:getBaseTextureFilename(), resource)
	elseif Type == ModelResource or Type == SkeletonResource or Type == SkeletonAnimationResource then
		return string.format("%s/%s", self:getBaseModelFilename(), resource)
	else
		error("unknown type")
	end
end

function TreeView:done()
	-- Nothing.
end

function TreeView:getCurrentAnimation()
	return self.animations[self.currentAnimation]
	    or self.animations[TreeView.ANIMATION_IDLE]
end

function TreeView:applyAnimation(time, animation)
	self.transforms:reset()
	animation:computeFilteredTransforms(time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function TreeView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.treeNode = ModelSceneNode()
	self.trunkNode = ModelSceneNode()
	self.leavesNode = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath(SkeletonResource, "Tree.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				ModelResource,
				self:getResourcePath(ModelResource, "Tree.lmesh"),
				function(model)
					self.treeModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath(ModelResource, "Trunk.lmesh"),
				function(model)
					self.trunkModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath(ModelResource, "Leaves.lmesh"),
				function(model)
					self.leavesModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath(SkeletonAnimationResource, "Pose.lanim"),
				function(animation)
					self.poseAnimation = animation
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.treeNode:setModel(self.treeModel)
				self.treeNode:getMaterial():setShader(self.treeShader)
				self.treeNode:getMaterial():setTextures(self.barkTexture)
				self.treeNode:getMaterial():setOutlineThreshold(-0.01)
				self.treeNode:setParent(root)
				self.treeNode:setTransforms(self.transforms)

				self.trunkNode:setModel(self.trunkModel)
				self.trunkNode:getMaterial():setShader(self.treeShader)
				self.trunkNode:getMaterial():setTextures(self.barkTexture)
				self.trunkNode:getMaterial():setOutlineThreshold(-0.01)
				self.trunkNode:setParent(root)
				self.trunkNode:setTransforms(self.transforms)

				self.leavesNode:setModel(self.leavesModel)
				self.leavesNode:getMaterial():setOutlineColor(Color(0.5))
				self.leavesNode:getMaterial():setShader(self.leavesShader)
				self.leavesNode:getMaterial():setTextures(self.leavesTexture)
				self.leavesNode:getMaterial():setOutlineThreshold(-0.01)
				self.leavesNode:setTransforms(self.transforms)
				if not self:getIsEditor() then
					self.leavesNode:setParent(root)
				end

				local state = self:getProp():getState().resource
				if state then
					self.isDepleted = state.depleted
					self.wasDepleted = state.depleted
					if self.wasDepleted then
						self.time = self.FELLED_SPAWN_TIME_SECONDS
					else
						self.time = 0
					end
				end

				self:done()

				self.spawned = true

				self:_updateNodeUniforms(self.leavesNode)
			end)
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath(TextureResource, "Leaves.png"),
		function(texture)
			self.leavesTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath(TextureResource, "Bark.png"),
		function(texture)
			self.barkTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/TriplanarSkinnedModel",
		function(shader)
			self.treeShader = shader
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyLeafModel",
		function(shader)
			self.leavesShader = shader
		end)
end

function TreeView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function TreeView:_updateNodeUniforms(node)
	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	local material = node:getMaterial()
	material:send(material.UNIFORM_FLOAT, "scape_BumpForce", 0)
	material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
	material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", 0.25)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 2.0, 2.0, 2.0, 2.0)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackAlpha", 0.0)
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

		if self.previousProgress ~= r.progress then
			self:getResources():queueEvent(function()
				self.currentAnimation = TreeView.ANIMATION_CHOPPED
				self.time = 0
			end)

			self.previousProgress = r.progress
		end

		if r.depleted ~= self.isDepleted then
			self.wasDepleted = self.isDepleted
			self.isDepleted = r.depleted
			self.time = 0
		end
	end
end

function TreeView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self.FELLED_SPAWN_TIME_SECONDS)
		local delta = self.time / self.FELLED_SPAWN_TIME_SECONDS

		if self.isDepleted then
			self._color.a = Tween.sineEaseOut(1 - delta)
		else
			self._color.a = Tween.sineEaseOut(delta)
		end

		self.treeNode:getMaterial():setColor(self._color)
		self.leavesNode:getMaterial():setColor(self._color)

		self.transforms:reset()

		self.poseAnimation:getResource():computeFilteredTransforms(0, self.transforms)

		local globalRotation
		do
			local currentRotation = Quaternion.IDENTITY
			local previousRotation = Quaternion.IDENTITY

			local currentNode = self:getRoot()
			while currentNode do
				currentRotation = currentRotation * currentNode:getTransform():getLocalRotation()

				local _, r = currentNode:getTransform():getPreviousTransform()
				previousRotation = previousRotation * r

				currentNode = currentNode:getParent()
			end

			globalRotation = previousRotation:slerp(currentRotation, _APP and _APP:getFrameDelta() or 1)
		end

		local r = self:getProp():getState().resource
		if self.isDepleted and r and r.felledPosition then
			local targetRotation = Quaternion.lookAt(Vector(unpack(r.felledPosition)) * Vector.PLANE_XZ, self:getProp():getPosition() * Vector.PLANE_XZ, Vector.UNIT_Y)
			local currentRotation = globalRotation:slerp(targetRotation, Tween.sineEaseOut(delta))

			local transform = self._transform
			transform:reset()

			transform:applyQuaternion(currentRotation:get())

			self.transforms:applyTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				transform)
		else
			local transform = self._transform
			transform:reset()

			local scale = Tween.sineEaseOut(delta)
			transform:scale(scale, scale, scale)

			self.transforms:applyTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				transform)
		end

		self.skeleton:getResource():applyTransforms(self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)
	end
end

return TreeView
