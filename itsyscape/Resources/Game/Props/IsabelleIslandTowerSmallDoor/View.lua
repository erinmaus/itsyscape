--------------------------------------------------------------------------------
-- Resources/Game/Props/IsabelleIslandTowerSmallDoor/View.lua
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

function Door:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.open = false
	self.spawned = false
	self.time = false
end

function Door:getBaseFilename()
	return "Resources/Game/Props/IsabelleIslandTowerSmallDoor"
end

function Door:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
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

function Door:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self:getCurrentAnimation():getDuration())

		self.transforms:reset()
		self:getCurrentAnimation():computeFilteredTransforms(self.time, self.transforms)

		local skeleton = self.skeleton:getResource()
		skeleton:applyTransforms(self.transforms)
		skeleton:applyBindPose(self.transforms)
	end
end

return Door
