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
local Keybinds = require "ItsyScape.UI.Keybinds"

local DefaultCameraController = Class(CameraController)
DefaultCameraController.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DefaultCameraController.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12
DefaultCameraController.SCROLL_MULTIPLIER = 4
DefaultCameraController.MIN_DISTANCE = 1
DefaultCameraController.MAX_DISTANCE = 60
DefaultCameraController.DEFAULT_DISTANCE = 30

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
	self:getCamera():setDistance(DefaultCameraController.DEFAULT_DISTANCE)

	self.targetDistance = self:getCamera():getDistance()

	self.isTargetting = _CONF.targetCameraMode or false
	self.isFocusDown = Keybinds['PLAYER_1_CAMERA']:isDown()
	self.targetOpponentDistance = 0
end

function DefaultCameraController:getPlayerPosition()
	local player = self:getGame():getPlayer()
	if not player then
		return Vector.ZERO
	end

	local delta = self:getApp():getFrameDelta()
	local position
	do
		local gameView = self:getGameView()
		local actor = gameView:getActor(player:getActor())
		if actor then
			local node = actor:getSceneNode()
			local transform = node:getTransform():getGlobalDeltaTransform(delta or 0)
			position = Vector(transform:transformPoint(0, 1, 0))
		end
	end

	return position or Vector.ZERO
end

function DefaultCameraController:getTargetPosition()
	local delta = self:getApp():getFrameDelta()

	local position, size
	do
		local gameView = self:getGameView()
		local player = self:getGame():getPlayer()
		if player and player:isReady() then
			local target = player:getTarget()
			if target then
				local actor = gameView:getActor(target)
				if actor then
					local node = actor:getSceneNode()
					local transform = node:getTransform():getGlobalDeltaTransform(delta or 0)
					position = Vector(transform:transformPoint(0, 1, 0))

					local min, max, zoom = target:getBounds()
					local bounds = max - min
					size = math.max(bounds.x, bounds.y, bounds.z) + zoom
				end
			end
		end
	end

	return position or self:getPlayerPosition(), size or 0
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

function DefaultCameraController:debugUpdate(delta)
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

function DefaultCameraController:updateScrollPosition(delta)
	local interpolatedDistance
	do 
		local currentDistance = self:getCamera():getDistance()
		local targetDistance  = self.targetDistance + self.targetOpponentDistance

		local scrollDelta = delta * DefaultCameraController.SCROLL_MULTIPLIER
		local distanceStep = (targetDistance - currentDistance) * scrollDelta
		interpolatedDistance = currentDistance + distanceStep
	end

	self:getCamera():setDistance(interpolatedDistance)
end

function DefaultCameraController:updateTargetDistance()
	local playerPosition = self:getPlayerPosition()
	local targetPosition, targetSize = self:getTargetPosition()
	local distance = (playerPosition - targetPosition):getLength()

	self.targetOpponentDistance = (distance + targetSize)
end

function DefaultCameraController:update(delta)
	if _DEBUG then
		self:debugUpdate(delta)
	end

	local isFocusDown = Keybinds['PLAYER_1_CAMERA']:isDown()
	if isFocusDown ~= self.isFocusDown and isFocusDown then
		self.isTargetting = not self.isTargetting
		if self.isTargetting then
			Log.info("Target camera mode enabled.")
		else
			Log.info("Target camera mode disabled.")
		end

		_CONF.targetCameraMode = self.isTargetting
	end
	self.isFocusDown = isFocusDown

	if self.isTargetting then
		self:updateTargetDistance()
	end

	self:updateScrollPosition(delta)
end

function DefaultCameraController:draw()
	local center
	if self.isTargetting then
		local playerPosition = self:getPlayerPosition()
		local targetPosition = self:getTargetPosition()
		local difference = playerPosition - targetPosition
		local normal = difference:getNormal()
		local distance = difference:getLength()

		center = targetPosition + normal * (distance / 2)
	else
		center = self:getPlayerPosition()
	end

	self:getCamera():setPosition(center + self.cameraOffset)
end

return DefaultCameraController
