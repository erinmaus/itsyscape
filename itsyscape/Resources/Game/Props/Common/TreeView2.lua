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
	elseif Type == ModelResource or Type == SkeletonResource then
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
				self.leavesNode:setParent(root)
				self.leavesNode:setTransforms(self.transforms)

				self.leavesNode:onWillRender(function(renderer)
					local currentShader = renderer:getCurrentShader()
					if not currentShader then
						return
					end

					if currentShader:hasUniform("scape_BumpHeight") then
						currentShader:send("scape_BumpHeight", 1)
					end

					local _, layer = self:getProp():getPosition()
					local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

					if currentShader:hasUniform("scape_WindDirection") then
						currentShader:send("scape_WindDirection", { windDirection:get() })
					end

					if currentShader:hasUniform("scape_WindSpeed") then
						currentShader:send("scape_WindSpeed", windSpeed)
					end

					if currentShader:hasUniform("scape_WindPattern") then
						currentShader:send("scape_WindPattern", { windPattern:get() })
					end

					if currentShader:hasUniform("scape_WindMaxDistance") then
						currentShader:send("scape_WindMaxDistance", 0.25)
					end
				end)

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
		"Resources/Shaders/TriPlanarSkinnedModel",
		function(shader)
			self.treeShader = shader
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyLeafModel",
		function(shader)
			self.leafShader = shader
		end)
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
		end
	end
end

function TreeView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self.FELLED_SPAWN_TIME_SECONDS)
		local delta = self.time / self.FELLED_SPAWN_TIME_SECONDS

		if self.isDepleted then
			self.treeNode:getMaterial():setColor(Color(1, 1, 1, Tween.sineEaseOut(1 - delta)))
			self.leavesNode:getMaterial():setColor(Color(1, 1, 1, Tween.sineEaseOut(1 - delta)))
		else
			self.treeNode:getMaterial():setColor(Color(1, 1, 1, Tween.sineEaseOut(delta)))
			self.leavesNode:getMaterial():setColor(Color(1, 1, 1, Tween.sineEaseOut(delta)))
		end

		for i = 1, self.skeleton:getResource():getNumBones() do
			self.transforms:setIdentity(i)
		end

		do
			local transform = love.math.newTransform()
			transform:applyQuaternion(Quaternion.X_90:get())

			self.transforms:setTransform(
				self.skeleton:getResource():getBoneIndex("root"),
				transform)
		end

		local r = self:getProp():getState().resource
		if self.isDepleted and r and r.felledPosition then
			local targetRotation = Quaternion.lookAt(Vector(unpack(r.felledPosition)) * Vector.PLANE_XZ, self:getProp():getPosition() * Vector.PLANE_XZ, Vector.UNIT_Y)
			local currentRotation = Quaternion.IDENTITY:slerp(targetRotation, Tween.sineEaseOut(delta))

			local transform = love.math.newTransform()
			transform:applyQuaternion(currentRotation:get())

			self.transforms:setTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				transform)
		else
			local transform = love.math.newTransform()
			local scale = Tween.sineEaseOut(delta)
			transform:scale(scale, scale, scale)

			self.transforms:setTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				transform)
		end

		self.skeleton:getResource():applyTransforms(self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)
	end
end

return TreeView
