--------------------------------------------------------------------------------
-- ItsyScape/Graphics/MapTableCameraController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CameraController = require "ItsyScape.Graphics.CameraController"

local MapTableCameraController = Class(CameraController)
MapTableCameraController.ACTION_BUTTON = 1
MapTableCameraController.PROBE_BUTTON  = 2
MapTableCameraController.CAMERA_BUTTON = 3

MapTableCameraController.DISTANCE = 30
MapTableCameraController.SPEED = 16

function MapTableCameraController:new(...)
	CameraController.new(self, ...)

	self.isCameraDragging = false
	self.cameraOffset = Vector(0)

	self:getCamera():setDistance(MapTableCameraController.DISTANCE)
end

function MapTableCameraController:getPlayerPosition()
	local delta = self:getApp():getFrameDelta()

	local position
	do
		local gameView = self:getGameView()
		local actor = gameView:getActor(self:getGame():getPlayer():getActor())
		if actor then
			local node = actor:getSceneNode()
			local transform = node:getTransform():getGlobalDeltaTransform(delta or 0)
			position = Vector(transform:transformPoint(0, 1, 0))
		end
	end

	return position or Vector.ZERO
end

function MapTableCameraController:mousePress(uiActive, x, y, button)
	if not uiActive then
		if button == MapTableCameraController.ACTION_BUTTON then
			return CameraController.PROBE_SELECT_DEFAULT
		elseif button == MapTableCameraController.PROBE_BUTTON then
			return CameraController.PROBE_CHOOSE_OPTION
		elseif button == MapTableCameraController.CAMERA_BUTTON then
			self.isCameraDragging = true
		end
	end
end

function MapTableCameraController:mouseRelease(uiActive, x, y, button)
	if button == MapTableCameraController.CAMERA_BUTTON then
		self.isCameraDragging = false
	end

	return CameraController.PROBE_SUPPRESS
end

function MapTableCameraController:mouseMove(uiActive, x, y, dx, dy)
	if self.isCameraDragging then
		local distanceX = -dx / MapTableCameraController.SPEED
		local distanceY = -dy / MapTableCameraController.SPEED

		self.cameraOffset = self.cameraOffset + Vector(distanceX, 0, distanceY)
	end
end

function MapTableCameraController:draw()
	self:getCamera():setPosition(self:getPlayerPosition() + self.cameraOffset)
end

return MapTableCameraController
