--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/HelmView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local SailingItemView = require "Resources.Game.Props.Common.SailingItemView"

local HelmView = Class(SailingItemView)

HelmView.WHEEL_OFFSET = Vector(0, 1.2, -0.3)

HelmView.ROTATION_MULTIPLIER = math.pi * 3
HelmView.ROTATION_SPEED_RADIANS_PER_SECOND = math.pi
HelmView.ROTATION_TWEEN_SPEED = 0.5

function HelmView:load()
	PropView.load(self)

	local attachments = self:getAttachments()

	local resources = self:getResources()
	local root = self:getRoot()

	self.staticNodes = self:loadAttachments(root, attachments.STATIC_ATTACHMENTS)

	self.wheelNode = SceneNode()
	self.wheelNode:setParent(root)
	self.wheelNodes = self:loadAttachments(self.wheelNode, attachments.WHEEL_ATTACHMENTS)

	self.currentRotation = self:_getRotation()
	self.previousRotation = self.currentRotation
	self.currentSpeedMultiplier = 0
end

function HelmView:_getRotation()
	local state = self:getProp():getState()
	local currentRotation = state and state.direction
	currentRotation = (currentRotation or 0) * self.ROTATION_MULTIPLIER

	return currentRotation
end

function HelmView:update(delta)
	PropView.update(self, delta)

	local targetRotation = self:_getRotation()
	if self.previousRotation ~= targetRotation and self.previousRotation == self.currentRotation then
		self.currentSpeedMultiplier = 0
	end

	self.currentSpeedMultiplier = self.currentSpeedMultiplier + (1 / self.ROTATION_TWEEN_SPEED) * delta

	if targetRotation > self.currentRotation then
		local nextRotation = self.currentRotation + delta * self.ROTATION_SPEED_RADIANS_PER_SECOND * self.currentSpeedMultiplier
		self.currentRotation = math.min(nextRotation, targetRotation)
	elseif targetRotation < self.currentRotation then
		local nextRotation = self.currentRotation - delta * self.ROTATION_SPEED_RADIANS_PER_SECOND * self.currentSpeedMultiplier
		self.currentRotation = math.max(nextRotation, targetRotation)
	end

	local wheelTransform = self.wheelNode:getTransform()
	wheelTransform:setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Z, self.currentRotation))
	wheelTransform:setLocalTranslation(self.WHEEL_OFFSET)

	local attachments = self:getAttachments()
	self:updateAttachments(self.staticNodes, attachments.STATIC_ATTACHMENTS)
	self:updateAttachments(self.wheelNodes, attachments.WHEEL_ATTACHMENTS)
end

return HelmView
