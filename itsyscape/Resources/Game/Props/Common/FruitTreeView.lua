--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/FruitTreeView.lua
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

local FruitTreeView = Class(PropView)

FruitTreeView.SHAKE_TIME_SECONDS = 1
FruitTreeView.MAXIMUM_RANDOM_ANGLE = math.rad(10)
FruitTreeView.MAXIMUM_RANDOM_SHAKE_ANGLE = math.rad(20)

function FruitTreeView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.previousProgress = 0
	self.shaken = 0
	self.spawned = false
	self.depleted = false
	self.time = 0
end

function FruitTreeView:getBaseModelFilename()
	return Class.ABSTRACT()
end

function FruitTreeView:getBaseTextureFilename()
	return Class.ABSTRACT()
end

function FruitTreeView:getResourcePath(Type, resource)
	if Type == TextureResource then
		return string.format("%s/%s", self:getBaseTextureFilename(), resource)
	elseif Type == ModelResource or Type == SkeletonResource or Type == SkeletonAnimationResource then
		return string.format("%s/%s", self:getBaseModelFilename(), resource)
	else
		error("unknown type")
	end
end

function FruitTreeView:done()
	-- Nothing.
end

function FruitTreeView:getCurrentAnimation()
	return self.animations[self.currentAnimation]
	    or self.animations[TreeView.ANIMATION_IDLE]
end

function FruitTreeView:applyAnimation(time, animation)
	self.transforms:reset()
	animation:computeFilteredTransforms(time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function FruitTreeView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.treeNode = ModelSceneNode()
	self.fruitNode = ModelSceneNode()
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
				self:getResourcePath(ModelResource, "Fruit.lmesh"),
				function(model)
					self.fruitModel = model
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

				self.fruitNode:setModel(self.fruitModel)
				self.fruitNode:getMaterial():setShader(self.leavesShader)
				self.fruitNode:getMaterial():setTextures(self.fruitTexture)
				self.fruitNode:setParent(root)
				self.fruitNode:setTransforms(self.transforms)

				self.leavesNode:setModel(self.leavesModel)
				self.leavesNode:getMaterial():setOutlineColor(Color(0.5))
				self.leavesNode:getMaterial():setShader(self.leavesShader)
				self.leavesNode:getMaterial():setTextures(self.leavesTexture)
				self.leavesNode:getMaterial():setOutlineThreshold(-0.01)
				self.leavesNode:setParent(root)
				self.leavesNode:setTransforms(self.transforms)

				local function onWillRender(renderer)
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

					if currentShader:hasUniform("scape_WallHackWindow") then
						currentShader:send("scape_WallHackWindow", { 2.0, 2.0, 2.0, 2.0 })
					end
				end

				self.leavesNode:onWillRender(onWillRender)
				self.fruitNode:onWillRender(onWillRender)

				local state = self:getProp():getState().resource
				if state then
					self.shaken = state.shaken
					self.time = self.SHAKE_TIME_SECONDS
				end

				local i, j = self:getProp():getTile()
				local rng = love.math.newRandomGenerator(i, j)

				self.idleRotations = {}
				for i = 1, skeleton:getResource():getNumBones() do
					local x = (rng:random() * 2) - 1
					local y = (rng:random() * 2) - 1
					local z = (rng:random() * 2) - 1
					local axis = Vector(x, y, z):getNormal()

					local angle = rng:random() * self.MAXIMUM_RANDOM_ANGLE
					self.idleRotations[i] = Quaternion.fromAxisAngle(axis, angle):keep()
				end

				self.shakeRotations = {}
				self.shakeTweenPower = {}
				for i = 1, skeleton:getResource():getNumBones() do
					local x = (rng:random() * 2) - 1
					local y = (rng:random() * 2) - 1
					local z = (rng:random() * 2) - 1
					local axis = Vector(x, y, z):getNormal()
					self.shakeTweenPower[i] = rng:random() + 1

					local angle = rng:random() * self.MAXIMUM_RANDOM_SHAKE_ANGLE
					self.shakeRotations[i] = Quaternion.fromAxisAngle(axis, angle):keep()
				end

				self.spawned = true
				self:done()
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
		TextureResource,
		self:getResourcePath(TextureResource, "Fruit.png"),
		function(texture)
			self.fruitTexture = texture
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

function FruitTreeView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if self.shaken ~= r.shaken then
			self.wasDepleted = self.isDepleted
			self.isDepleted = r.shaken > 0
			self.shaken = r.shaken
			self.time = 0
		end
	end
end

function FruitTreeView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self.SHAKE_TIME_SECONDS)
		local delta = self.time / self.SHAKE_TIME_SECONDS

		if self.isDepleted then
			delta = 1 - delta
		end

		self.fruitNode:getMaterial():setColor(Color(1, 1, 1, Tween.sineEaseOut(delta)))

		self.poseAnimation:getResource():computeFilteredTransforms(0, self.transforms)

		local transform = love.math.newTransform()
		for i = 1, self.skeleton:getResource():getNumBones() do
			if i ~= self.skeleton:getResource():getBoneIndex("root") then
				local targetRotation = self.idleRotations[i] * self.shakeRotations[i]
				local rotation = self.idleRotations[i]:slerp(targetRotation, Tween.powerEaseIn(math.sin(delta * math.pi), self.shakeTweenPower[i]))

				transform:reset()
				transform:applyQuaternion(rotation:get())

				self.transforms:applyTransform(i, transform)
			end
		end

		self.skeleton:getResource():applyTransforms(self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)
	end
end

return FruitTreeView
