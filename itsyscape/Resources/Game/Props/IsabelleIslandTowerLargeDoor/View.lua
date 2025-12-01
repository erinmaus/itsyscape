--------------------------------------------------------------------------------
-- Resources/Game/Props/IsabelleIslandTowerLargeDoor/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local FlameGreeble = require "Resources.Game.Props.Common.Greeble.FlameGreeble"
local SmokeGreeble = require "Resources.Game.Props.Common.Greeble.SmokeGreeble"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local Door = Class(PropView)

Door.ANIMATION_OPEN  = 1
Door.ANIMATION_CLOSE = 2

Door.LEFT_DOOR_OFFSET  = Vector(-3, 1.5, 2)
Door.RIGHT_DOOR_OFFSET  = Vector(3, 1.5, 2)

function Door:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.open = false
	self.spawned = false
	self.time = false

	self.leftSmokeGreeble = self:addGreeble(SmokeGreeble, { ATTACH_TO_ROOT = true, PARTICLE_SCALE = 1.5, SMOKE_OFFSET = Vector(0, 0.5, 0) })
	self.leftFireGreeble = self:addGreeble(FlameGreeble, { ATTACH_TO_ROOT = true, PARTICLE_SCALE = 1.5 })
	self.leftFlickerGreeble = self:addGreeble(FlickerGreeble)

	self.rightSmokeGreeble = self:addGreeble(SmokeGreeble, { ATTACH_TO_ROOT = true, PARTICLE_SCALE = 1.5, SMOKE_OFFSET = Vector(0, 0.5, 0) })
	self.rightFireGreeble = self:addGreeble(FlameGreeble, { ATTACH_TO_ROOT = true, PARTICLE_SCALE = 1.5 })
	self.rightFlickerGreeble = self:addGreeble(FlickerGreeble)
end

function Door:getBaseFilename()
	return "Resources/Game/Props/IsabelleIslandTowerLargeDoor"
end

function Door:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function Door:getLocalPosition(boneName, offset)
	offset = offset or Vector.ZERO

	local boneIndex = self.skeleton:getResource():getBoneIndex(boneName)
	local transform = self.transforms:getTransform(boneIndex)

	local combinedTransform = love.math.newTransform()
	combinedTransform:translate(offset:get())
	combinedTransform:applyQuaternion((-Quaternion.X_90):get())
	combinedTransform:apply(transform)

	return Vector.ZERO:transform(combinedTransform)
end

function Door:getWorldPosition(boneName, offset)
	local position = self:getLocalPosition(boneName, offset)
	local transform = self:getRoot():getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())

	return position:transform(transform)
end

function Door:getCurrentAnimation()
	if self.currentAnimation == Door.ANIMATION_OPEN then
		return self.openAnimation
	elseif self.currentAnimation == Door.ANIMATION_CLOSE then
		return self.closeAnimation
	else
		return nil
	end
end

function Door:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		SkeletonResource,
		self:getResourcePath("Door.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				ModelResource,
				self:getResourcePath("Trim.lmesh"),
				function(trimModel)
					self.trimModel = trimModel

					self.trimNode = ModelSceneNode()
					self.trimNode:setModel(self.trimModel)
					self.trimNode:setTransforms(self.transforms)
					self.trimNode:setParent(root)

					local material = DecorationMaterial(self:getResourcePath("Trim.lmaterial"))
					material:apply(self.trimNode, self:getResources())
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath("Skull.lmesh"),
				function(skullModel)
					self.skullModel = skullModel

					self.skullNode = ModelSceneNode()
					self.skullNode:setModel(self.skullModel)
					self.skullNode:setTransforms(self.transforms)
					self.skullNode:setParent(root)

					local material = DecorationMaterial(self:getResourcePath("Skull.lmaterial"))
					material:apply(self.skullNode, self:getResources())
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath("Interior.lmesh"),
				function(interiorModel)
					self.interiorModel = interiorModel

					self.interiorNode = ModelSceneNode()
					self.interiorNode:setModel(self.interiorModel)
					self.interiorNode:setTransforms(self.transforms)
					self.interiorNode:setParent(root)

					local material = DecorationMaterial(self:getResourcePath("Interior.lmaterial"))
					material:apply(self.interiorNode, self:getResources())
				end,
				self.skeleton:getResource())
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
				self.closeAnimation:computeTransforms(0, self.transforms)

				local state = self:getProp():getState()
				if state.open then
					self:playOpenAnimation()
				else
					self:playCloseAnimation()
				end

				self.open = state.open

				self.time = self:getCurrentAnimation():getDuration()
				self.spawned = true
			end)
		end)
end

function Door:playOpenAnimation()
	self.currentAnimation = Door.ANIMATION_OPEN
	self.open = true
end

function Door:playCloseAnimation()
	self.currentAnimation = Door.ANIMATION_CLOSE
	self.open = false
end

function Door:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.open ~= self.open then
		if state.open then
			self:playOpenAnimation()
		else
			self:playCloseAnimation()
		end

		self.open = state.open
		self.time = 0
	end
end

function Door:updatePositions()
	local globalRightPosition = self:getWorldPosition("door.right", self.RIGHT_DOOR_OFFSET)
	self.rightSmokeGreeble:updateLocalPosition(globalRightPosition)
	self.rightFireGreeble:updateLocalPosition(globalRightPosition)

	local localRightPosition = self:getLocalPosition("door.right", self.RIGHT_DOOR_OFFSET)
	self.rightFlickerGreeble:getRoot():getTransform():setLocalTranslation(localRightPosition)

	local globalLeftPosition = self:getWorldPosition("door.left", self.LEFT_DOOR_OFFSET)
	self.leftSmokeGreeble:updateLocalPosition(globalLeftPosition)
	self.leftFireGreeble:updateLocalPosition(globalLeftPosition)

	local localLeftPosition = self:getLocalPosition("door.left", self.LEFT_DOOR_OFFSET)
	self.leftFlickerGreeble:getRoot():getTransform():setLocalTranslation(localLeftPosition)
end

function Door:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self:getCurrentAnimation():getDuration())

		self.transforms:reset()
		self:getCurrentAnimation():computeFilteredTransforms(self.time, self.transforms)

		local skeleton = self.skeleton:getResource()
		skeleton:applyTransforms(self.transforms)

		self:updatePositions()

		skeleton:applyBindPose(self.transforms)
	end
end

return Door
