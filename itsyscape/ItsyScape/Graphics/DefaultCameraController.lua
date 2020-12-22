--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DefaultCameraController.lua
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

local DefaultCameraController = Class(CameraController)
DefaultCameraController.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DefaultCameraController.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12
DefaultCameraController.SCROLL_MULTIPLIER = 4
DefaultCameraController.MIN_DISTANCE = 1
DefaultCameraController.MAX_DISTANCE = 60

DefaultCameraController.ACTION_BUTTON = 1
DefaultCameraController.PROBE_BUTTON  = 2
DefaultCameraController.CAMERA_BUTTON = 3

function DefaultCameraController:new(...)
	CameraController.new(self, ...)

	self.isCameraDragging = false

	self.cameraVerticalRotationOffset = 0
	self.cameraHorizontalRotationOffset = 0
	self.cameraOffset = Vector(0)

	self:getCamera():setHorizontalRotation(
		DefaultCameraController.CAMERA_HORIZONTAL_ROTATION)
	self:getCamera():setVerticalRotation(
		DefaultCameraController.CAMERA_VERTICAL_ROTATION)

	self.targetDistance = self:getCamera():getDistance()
end

function DefaultCameraController:getPlayerPosition()
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

function DefaultCameraController:mousePress(uiActive, x, y, button)
	if not uiActive then
		if button == DefaultCameraController.ACTION_BUTTON then
			return CameraController.PROBE_SELECT_DEFAULT
		elseif button == DefaultCameraController.PROBE_BUTTON then
			return CameraController.PROBE_CHOOSE_OPTION
		elseif button == DefaultCameraController.CAMERA_BUTTON then
			self.isCameraDragging = true
		end
	end
end

function DefaultCameraController:mouseRelease(uiActive, x, y, button)
	if button == DefaultCameraController.CAMERA_BUTTON then
		self.isCameraDragging = false
	end

	return CameraController.PROBE_SUPPRESS
end

function DefaultCameraController:mouseScroll(uiActive, x, y)
	if not uiActive then
		local distance = self.targetDistance - y * 0.5
		if not _DEBUG then
			self.targetDistance = math.min(math.max(distance, DefaultCameraController.MIN_DISTANCE), DefaultCameraController.MAX_DISTANCE)
		else
			self.targetDistance = distance
		end
	end
end

function DefaultCameraController:mouseMove(uiActive, x, y, dx, dy)
	if self.isCameraDragging then
		local angle1 = self.cameraVerticalRotationOffset + dx / 128
		local angle2 = self.cameraHorizontalRotationOffset + -dy / 128

		if not _DEBUG then
			angle1 = math.max(
				angle1,
				-DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle1 = math.min(
				angle1,
				DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle2 = math.max(
				angle2,
				-DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
			angle2 = math.min(
				angle2,
				DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
		end

		self:getCamera():setVerticalRotation(
			DefaultCameraController.CAMERA_VERTICAL_ROTATION + angle1)
		self:getCamera():setHorizontalRotation(
			DefaultCameraController.CAMERA_HORIZONTAL_ROTATION + angle2)

		self.cameraVerticalRotationOffset = angle1
		self.cameraHorizontalRotationOffset = angle2
	end
end

function DefaultCameraController:update(delta)
	if _DEBUG then
		local isShiftDown = love.keyboard.isDown('lshift') or
		                    love.keyboard.isDown('rshift')
		local isCtrlDown = love.keyboard.isDown('lctrl') or
		                   love.keyboard.isDown('rctrl')
		local speed
		if isShiftDown then
			speed = 12
		else
			speed = 4
		end

		do
			if love.keyboard.isDown('up') then
				self.cameraOffset = self.cameraOffset + -Vector.UNIT_Z * speed * delta
			end

			if love.keyboard.isDown('down') then
				self.cameraOffset = self.cameraOffset + Vector.UNIT_Z * speed * delta
			end
		end

		do
			if love.keyboard.isDown('left') then
				self.cameraOffset = self.cameraOffset + -Vector.UNIT_X * speed * delta
			end
			if love.keyboard.isDown('right') then
				self.cameraOffset = self.cameraOffset + Vector.UNIT_X * speed * delta
			end
		end

		do
			if love.keyboard.isDown('pageup') then
				self.cameraOffset = self.cameraOffset + -Vector.UNIT_Y * speed * delta
			end
			if love.keyboard.isDown('pagedown') then
				self.cameraOffset = self.cameraOffset + Vector.UNIT_Y * speed * delta
			end
		end

		if love.keyboard.isDown('space') then
			self.cameraOffset = Vector(0)
		end
	end

	local interpolatedDistance
	do 
		local currentDistance = self:getCamera():getDistance()
		local targetDistance  = self.targetDistance

		local scrollDelta = delta * DefaultCameraController.SCROLL_MULTIPLIER
		local distanceStep = (targetDistance - currentDistance) * scrollDelta
		interpolatedDistance = currentDistance + distanceStep
	end

	self:getCamera():setDistance(interpolatedDistance)
end

function DefaultCameraController:draw()
	self:getCamera():setPosition(self:getPlayerPosition() + self.cameraOffset)
end

return DefaultCameraController
