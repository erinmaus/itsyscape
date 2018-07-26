--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/DoorView.lua
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
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local DoorView = Class(PropView)

function DoorView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.open = false
	self.spawned = false
	self.time = false
	self.transforms = {}
end

function DoorView:getBaseFilename()
	return Class.ABSTRACT()
end

function DoorView:getResourcePath(resource)
	return string.format("%s/%s", self:getBaseFilename(), resource)
end

function DoorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local skeleton = Skeleton(self:getResourcePath("Door.lskel"))
	local model = resources:load(
		ModelResource,
		self:getResourcePath("Door.lmodel"),
		skeleton)
	local texture = resources:load(
		TextureResource,
		self:getResourcePath("Texture.png"))
	self.openAnimation = SkeletonAnimation(
		self:getResourcePath("DoorOpen.lanim"),
		skeleton)
	self.closeAnimation = SkeletonAnimation(
		self:getResourcePath("DoorClose.lanim"),
		skeleton)

	self.model = ModelSceneNode()
	self.model:setModel(model)
	self.model:getMaterial():setTextures(texture)
	self.model:setParent(root)

	self.openAnimation:computeTransforms(0, self.transforms)
	self.model:setTransforms(self.transforms)
end

function DoorView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.open ~= self.open then
		if state.open then
			self.currentAnimation = self.openAnimation
			self.open = true
		else
			self.currentAnimation = self.closeAnimation
			self.open = false
		end

		self.time = 0
	end
end

function DoorView:update(delta)
	PropView.update(self, delta)

	if not self.spawned then
		local state = self:getProp():getState()
		if state.open then
			self.currentAnimation = self.openAnimation
			self.open = true
		else
			self.currentAnimation = self.closeAnimation
			self.open = false
		end

		self.time = self.currentAnimation:getDuration()
		self.spawned = true
	end

	self.time = math.min(self.time + delta, self.currentAnimation:getDuration())
	self.currentAnimation:computeTransforms(self.time, self.transforms)
	self.model:setTransforms(self.transforms)
end

return DoorView
