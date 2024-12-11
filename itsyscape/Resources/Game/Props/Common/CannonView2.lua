--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/CannonView.lua
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
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local SailingItemView = require "Resources.Game.Props.Common.SailingItemView"

local CannonView = Class(SailingItemView)

CannonView.BARREL_TRANSLATION = Vector(0, 1.4, 0.5)
CannonView.WHEELS_TRANSLATION = Vector(0, 0.4, 0.9)

function CannonView:load()
	SailingItemView.load(self)

	local attachments = self:getAttachments()

	local resources = self:getResources()
	local root = self:getRoot()

	self.staticNodes = self:loadAttachments(root, attachments.STATIC_ATTACHMENTS)

	self.barrelNode = SceneNode()
	self.barrelNode:setParent(root)
	self.barrelNodes = self:loadAttachments(self.barrelNode, attachments.BARREL_ATTACHMENTS)

	self.boltNode = SceneNode()
	self.boltNode:setParent(root)
	self.boltNodes = self:loadAttachments(self.boltNode, attachments.BOLT_ATTACHMENTS)

	self.wheelsNode = SceneNode()
	self.wheelsNode:setParent(root)
	self.wheelsNodes = self:loadAttachments(self.wheelsNode, attachments.WHEELS_ATTACHMENTS)

	self.currentRotation = self:_getRotation():keep()
	self.previousRotation = self.currentRotation
end

function CannonView:_getRotation()
	local state = self:getProp():getState()
	local currentRotation = state and state.rotation
	currentRotation = currentRotation and Quaternion(unpack(currentRotation))
	currentRotation = currentRotation or Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(0))

	do
		local mouseX, mouseY = love.mouse.getPosition()
		local width, height = love.graphics.getWidth(), love.graphics.getHeight()

		local x = mouseX / width
		local y = mouseY / height

		local modifiedRotation = Quaternion.fromEulerXYZ(
			math.rad(math.lerp(-30, 15, y)),
			math.rad(math.lerp(-30, 30, x)),
			0)

		currentRotation = modifiedRotation * currentRotation
	end

	return currentRotation
end

function CannonView:update(delta)
	SailingItemView.update(self, delta)

	self.previousRotation = self.currentRotation
	self.currentRotation = self:_getRotation():keep()

	local barrelRotation = self.previousRotation:slerp(self.currentRotation, _APP:getPreviousFrameDelta()):getNormal()
	local boltRotation
	do
		local x = barrelRotation:getEulerXYZ()
		boltRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, x)
	end

	self.barrelNode:getTransform():setLocalTranslation(self.BARREL_TRANSLATION)
	self.boltNode:getTransform():setLocalTranslation(self.BARREL_TRANSLATION)
	self.wheelsNode:getTransform():setLocalTranslation(self.WHEELS_TRANSLATION)

	self.barrelNode:getTransform():setLocalRotation(barrelRotation)
	self.boltNode:getTransform():setLocalRotation(boltRotation)

	local attachments = self:getAttachments()
	self:updateAttachments(self.barrelNodes, attachments.BARREL_ATTACHMENTS)
	self:updateAttachments(self.boltNodes, attachments.BOLT_ATTACHMENTS)
	self:updateAttachments(self.staticNodes, attachments.STATIC_ATTACHMENTS)
	self:updateAttachments(self.wheelsNodes, attachments.WHEELS_ATTACHMENTS)
end

return CannonView
