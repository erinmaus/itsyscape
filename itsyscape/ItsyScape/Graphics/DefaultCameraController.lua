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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CameraController = require "ItsyScape.Graphics.CameraController"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Keybinds = require "ItsyScape.UI.Keybinds"

local DefaultCameraController = Class(CameraController)
DefaultCameraController.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DefaultCameraController.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIPPED = math.pi / 2
DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIP_TIME_SECONDS = 0.5
DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 8
DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 128
DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIP = math.pi / 4
DefaultCameraController.SCROLL_MULTIPLIER = 4
DefaultCameraController.MIN_DISTANCE = 10
DefaultCameraController.MAX_DISTANCE = 25
DefaultCameraController.DEFAULT_DISTANCE = 30
DefaultCameraController.SCROLL_DISTANCE_Y_ENGAGE = 128

DefaultCameraController.MAP_ROTATION_SWITCH_PERIOD = 1.0

DefaultCameraController.ACTION_BUTTON = 1
DefaultCameraController.PROBE_BUTTON  = 2
DefaultCameraController.CAMERA_BUTTON = 3

DefaultCameraController.SHOW_MODE_NONE   = "none"
DefaultCameraController.SHOW_MODE_SCROLL = "scroll"
DefaultCameraController.SHOW_MODE_MOVE   = "move"

DefaultCameraController.CLICK_STILL_MAX        = 24
DefaultCameraController.CLICK_DRAG_DENOMINATOR = 4
DefaultCameraController.SCROLL_SPEED_MULTIPLIER = 5

DefaultCameraController.PAN_TIME = 0.5
DefaultCameraController.PAN_DISTANCE = 0
DefaultCameraController.PAN_OFFSET = Vector(0, 15, 0)

DefaultCameraController.SPEED = math.pi / 2

function DefaultCameraController:new(...)
	CameraController.new(self, ...)

	self.distanceX = 0
	self.distanceY = 0
	self.isActionMoving = false
	self.isActionButtonDown = false
	self.isCameraDragging = false
	self.isRotationUnlocked = 0
	self.isPositionUnlocked = 0
	self.isPanning = false
	self.panningTime = 0
	self.panningVerticalRotationOffset = 0
	self.panningHorizontalRotationOffset = 0

	self._camera = ThirdPersonCamera()

	self.curveMode = DefaultCameraController.SHOW_MODE_NONE

	self.cameraVerticalRotationOffset = _CONF.camera and _CONF.camera.verticalRotationOffset or 0
	self.isCameraVerticalRotationFlipped = _CONF.camera and _CONF.camera.isVerticalRotationFlipped or false
	self.cameraVerticalRotationOffsetRemainder = 0
	self.cameraHorizontalRotationOffset = _CONF.camera and _CONF.camera.horizontalRotationOffset or 0
	self.cameraOffset = Vector(0):keep()

	self:getCamera():setHorizontalRotation(
		DefaultCameraController.CAMERA_HORIZONTAL_ROTATION + self.cameraHorizontalRotationOffset)
	self:getCamera():setVerticalRotation(
		DefaultCameraController.CAMERA_VERTICAL_ROTATION + self.cameraVerticalRotationOffset)
	self:getCamera():setDistance(_CONF.camera and _CONF.camera.distance or DefaultCameraController.DEFAULT_DISTANCE)

	self.targetDistance = self:getCamera():getDistance()
	self.currentDistance = self:getCamera():getDistance()

	self.isTargetting = _CONF.targetCameraMode or false
	self.isFocusDown = Keybinds['PLAYER_1_CAMERA']:isDown()
	self.targetOpponentDistance = 0

	self.cursor = love.graphics.newImage("Resources/Game/UI/Cursor_Mobile.png")
end

function DefaultCameraController:getPlayerMapRotation()
	local player = self:getGame():getPlayer()
	if not player then
		return Quaternion.IDENTITY
	end

	local actor = player:getActor()
	if not actor then
		return Quaternion.IDENTITY
	end

	local _, _, layer = actor:getTile()

	local mapSceneNode = self:getGameView():getMapSceneNode(layer)

	if not mapSceneNode then
		return Quaternion.IDENTITY
	end

	local _, previousRotation = mapSceneNode:getTransform():getPreviousTransform()
	local currentRotation = mapSceneNode:getTransform():getLocalRotation()

	local rotation = previousRotation:slerp(currentRotation, self:getApp():getFrameDelta())

	if self.currentPlayerLayer ~= layer then
		self.currentPlayerLayer = layer
		self.previousPlayerMapRotation = self.currentPlayerMapRotation
		self.previousPlayerMapRotationTime = 0
	end

	self.currentPlayerMapRotation = rotation

	if self.previousPlayerMapRotation then
		local delta = math.min(self.previousPlayerMapRotationTime / DefaultCameraController.MAP_ROTATION_SWITCH_PERIOD, 1)
		return self.previousPlayerMapRotation:slerp(self.currentPlayerMapRotation, delta)
	else
		return self.currentPlayerMapRotation
	end
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
			position = Vector(transform:transformPoint(0, 0, 0))
		end
	end

	position = position or Vector.ZERO
	position = position + Vector(0, 1, 0)

	return position
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
	if self:getIsDemoing() then
		return
	end

	if not uiActive then
		if button == DefaultCameraController.ACTION_BUTTON then
			self.isActionMoving = false
			self.isActionButtonDown = true
			self.distanceX = 0
			self.distanceY = 0
		elseif button == DefaultCameraController.CAMERA_BUTTON then
			self.isCameraDragging = true
		end
	end
end

function DefaultCameraController:mouseRelease(uiActive, x, y, button)
	if self:getIsDemoing() then
		return CameraController.PROBE_SUPPRESS
	end

	if button == DefaultCameraController.CAMERA_BUTTON or
	   (button == DefaultCameraController.ACTION_BUTTON and self.isActionMoving)
    then
		self.isCameraDragging = false
	end

	if button == DefaultCameraController.ACTION_BUTTON then
		local suppress = self.isActionMoving

		self.isActionMoving = false
		self.isActionButtonDown = false

		if suppress then
			return CameraController.PROBE_SUPPRESS
		end
	end

	if not uiActive then
		if button == DefaultCameraController.ACTION_BUTTON then
			self.isActionButtonDown = false
			return CameraController.PROBE_SELECT_DEFAULT
		elseif button == DefaultCameraController.PROBE_BUTTON then
			return CameraController.PROBE_CHOOSE_OPTION
		end
	end

	self.cameraVerticalRotationOffsetRemainder = 0

	return CameraController.PROBE_SUPPRESS
end

function DefaultCameraController:_scroll(y)
	local distance = self.targetDistance - y * 0.5
	if not _DEBUG then
		self.targetDistance = math.min(math.max(distance, DefaultCameraController.MIN_DISTANCE), DefaultCameraController.MAX_DISTANCE)
	else
		self.targetDistance = distance
	end
end

function DefaultCameraController:mouseScroll(uiActive, x, y)
	if self:getIsDemoing() then
		return
	end

	if not uiActive then
		if love.system.getOS() ~= "OS X" then
			y = y * DefaultCameraController.SCROLL_SPEED_MULTIPLIER
		end

		self:_scroll(y)
	end
end

function DefaultCameraController:_rotate(dx, dy)
	local panning = self.isPanning and not self:getIsDemoing()

	local verticalOffset = -dx / 128
	local horizontalOffset = (self.isCameraVerticalRotationFlipped and 1 or -1) * dy / 128
	local angle1 = (panning and self.panningVerticalRotationOffset or self.cameraVerticalRotationOffset) + verticalOffset
	local angle2 = (panning and self.panningHorizontalRotationOffset or self.cameraHorizontalRotationOffset) + horizontalOffset

	if not (_DEBUG or panning) then
		if self.isRotationUnlocked <= 0 and not self.cameraVerticalRotationFlipTime then
			local beforeAngle1Clamp = angle1

			angle1 = math.max(
				angle1,
				-DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle1 = math.min(
				angle1,
				DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)

			if beforeAngle1Clamp ~= angle1 then
				self.cameraVerticalRotationOffsetRemainder = self.cameraVerticalRotationOffsetRemainder + verticalOffset
			end

			if math.abs(self.cameraVerticalRotationOffsetRemainder) > DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIP then
				self.cameraVerticalRotationOffsetRemainder = 0
				self.isCameraVerticalRotationFlipped = not self.isCameraVerticalRotationFlipped
				self.cameraVerticalRotationFlipTime = DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIP_TIME_SECONDS - (self.cameraVerticalRotationFlipTime or 0)
			end
		end

		angle2 = math.max(
			angle2,
			-DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
		angle2 = math.min(
			angle2,
			DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
	end

	angle1 = math.sign(angle1) * (math.abs(angle1) % (math.pi * 2))
	angle2 = math.sign(angle2) * (math.abs(angle2) % (math.pi * 2))

	if panning then
		self.panningVerticalRotationOffset = angle1
		self.panningHorizontalRotationOffset = angle2
	else
		self.cameraVerticalRotationOffset = angle1
		self.cameraHorizontalRotationOffset = angle2
	end
end

function DefaultCameraController:rotate(dx, dy)
	self:_rotate(dx, dy)

	local isRotationLocked = math.abs(self.cameraHorizontalRotationOffset) == DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET
	if isRotationLocked then
		self:_scroll(-dy / DefaultCameraController.CLICK_DRAG_DENOMINATOR)
	end
end

function DefaultCameraController:mouseMove(uiActive, x, y, dx, dy)
	if self:getIsDemoing() then
		return
	end

	self.distanceX = (self.distanceX or 0) + (dx or 0)
	self.distanceY = (self.distanceY or 0) + (dy or 0)

	if self.isCameraDragging then
		self:_rotate(dx, dy)

		local isRotationLocked = math.abs(self.cameraHorizontalRotationOffset) == DefaultCameraController.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET
		local isEngaged
		do
			local _, _, scale = love.graphics.getScaledMode()
			isEngaged = math.abs(self.distanceY) >= (scale * DefaultCameraController.SCROLL_DISTANCE_Y_ENGAGE)
		end

		if self.isActionButtonDown and isRotationLocked and isEngaged then
			self:_scroll(-dy / DefaultCameraController.CLICK_DRAG_DENOMINATOR)
		end
	elseif self.isActionButtonDown then
		local difference = math.sqrt(self.distanceX ^ 2 + self.distanceY ^ 2)
		if difference > DefaultCameraController.CLICK_STILL_MAX then
			self.isCameraDragging = true
			self.isActionMoving = true
		end
	end
end

function DefaultCameraController:getIsMouseCaptured()
	return self.isActionButtonDown and self.isActionMoving and self.isCameraDragging
end

function DefaultCameraController:updateControls(delta)
	if _DEBUG then
		self.isPanning = false
		return
	end

	local focusedWidget = self:getApp():getUIView():getInputProvider():getFocusedWidget()
	if focusedWidget and focusedWidget:isCompatibleType(require "ItsyScape.UI.TextInput") then
		self.isPanning = false
		return
	end

	local upPressed = Keybinds['CAMERA_UP']:isDown()
	local downPressed = Keybinds['CAMERA_DOWN']:isDown()
	local leftPressed = Keybinds['CAMERA_LEFT']:isDown()
	local rightPressed = Keybinds['CAMERA_RIGHT']:isDown()
	local panDown = Keybinds['CAMERA_PAN']:isDown()
	self.isPanning = panDown

	local angle1 = self.isPanning and self.panningVerticalRotationOffset or self.cameraVerticalRotationOffset
	do
		if leftPressed then
			angle1 = angle1 + DefaultCameraController.SPEED * delta
		end

		if rightPressed then
			angle1 = angle1 - DefaultCameraController.SPEED * delta
		end
	end

	local angle2 = self.isPanning and self.panningHorizontalRotationOffset or self.cameraHorizontalRotationOffset
	do
		if upPressed then
			angle2 = angle2 - DefaultCameraController.SPEED * delta
		end

		if downPressed then
			angle2 = angle2 + DefaultCameraController.SPEED * delta
		end
	end

	if not self.isPanning then
		if not self.isRotationUnlocked or self.isRotationUnlocked <= 0 then
			angle1 = math.max(
				angle1,
				-DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle1 = math.min(
				angle1,
				DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
		end

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

	if self.isPanning then
		self.panningVerticalRotationOffset = angle1
		self.panningHorizontalRotationOffset = angle2
	else
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

	local offset = self.cameraOffset
	do
		if love.keyboard.isDown('up') then
			offset = offset + -Vector.UNIT_Z * speed * delta
		end

		if love.keyboard.isDown('down') then
			offset = offset + Vector.UNIT_Z * speed * delta
		end
	end

	do
		if love.keyboard.isDown('left') then
			offset = offset + -Vector.UNIT_X * speed * delta
		end
		if love.keyboard.isDown('right') then
			offset = offset + Vector.UNIT_X * speed * delta
		end
	end

	do
		if love.keyboard.isDown('=') then
			offset = offset + -Vector.UNIT_Y * speed * delta
		end
		if love.keyboard.isDown('-') then
			offset = offset + Vector.UNIT_Y * speed * delta
		end
	end

	if love.keyboard.isDown('space') then
		offset = Vector(0)
	end

	self.cameraOffset = offset:keep()
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

	self.currentDistance = interpolatedDistance
end

function DefaultCameraController:updateTargetDistance()
	local playerPosition = self:getPlayerPosition()
	local targetPosition, targetSize = self:getTargetPosition()
	local distance = (playerPosition - targetPosition):getLength()

	self.targetOpponentDistance = (distance + targetSize):keep()
end

function DefaultCameraController:updateShow(delta)
	if not self.curve then
		return
	end

	if not self:getIsDemoing() then
		return
	end

	self.currentCurveTime = math.min((self.currentCurveTime or 0) + delta, self.curveDuration or 0)

	local cx, cy = self.curve:evaluate(self.currentCurveTime / self.curveDuration)
	cx = cx * love.graphics.getWidth()
	cy = cy * love.graphics.getHeight()

	local px, py = self.previousCurveX, self.previousCurveY

	if self.curveMode == DefaultCameraController.SHOW_MODE_MOVE then
		self:_rotate(cx - px, cy - py)
	elseif self.curveMode == DefaultCameraController.SHOW_MODE_SCROLL then
		self:_scroll(-(cy - py) / DefaultCameraController.CLICK_DRAG_DENOMINATOR)
	end

	self.previousCurveX = cx
	self.previousCurveY = cy
end

function DefaultCameraController:updatePanning(delta)
	if self.isPanning then
		self.panningTime = self.panningTime + delta
	else
		self.panningTime = self.panningTime - delta
	end
	self.panningTime = math.clamp(self.panningTime, 0, DefaultCameraController.PAN_TIME)

	if self.panningTime <= 0 then
		self.panningVerticalRotationOffset = 0
		self.panningHorizontalRotationOffset = 0
	end
end

function DefaultCameraController:update(delta)
	if _DEBUG then
		self:debugUpdate(delta)
	end

	if self.previousPlayerMapRotationTime then
		if self.previousPlayerMapRotationTime >= DefaultCameraController.MAP_ROTATION_SWITCH_PERIOD then
			self.previousPlayerMapRotation = nil
			self.previousPlayerMapRotationTime = nil
		else
			self.previousPlayerMapRotationTime = self.previousPlayerMapRotationTime + delta
		end
	end

	if self.cameraVerticalRotationFlipTime then
		self.cameraVerticalRotationFlipTime = self.cameraVerticalRotationFlipTime - delta
		if self.cameraVerticalRotationFlipTime <= 0 then
			self.cameraVerticalRotationFlipTime = nil
			self.cameraVerticalRotationOffset = 0
		end
	end

	self:updateShow(delta)
	self:updateControls(delta)
	self:updatePanning(delta)

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

	if self.isShaking then
		self.currentShakingInterval = self.currentShakingInterval - delta
		if self.currentShakingInterval <= 0 then
			self.currentShakingInterval = self.shakingInterval

			local x = love.math.random() * (self.maxShakingOffset - self.minShakingOffset) + self.minShakingOffset
			local y = love.math.random() * (self.maxShakingOffset - self.minShakingOffset) + self.minShakingOffset
			local z = love.math.random() * (self.maxShakingOffset - self.minShakingOffset) + self.minShakingOffset

			self.previousShakingOffset = self.currentShakingOffset
			self.currentShakingOffset = Vector(x, y, z):keep()
		end

		self.currentShakingDuration = self.currentShakingDuration - delta
		if self.currentShakingDuration <= 0 then
			self.isShaking = false
			self.currentShakingOffset = Vector(0):keep()
		end
	end

	local cameraDetails = _CONF.camera or {}
	do
		cameraDetails.horizontalRotationOffset = self.cameraHorizontalRotationOffset
		cameraDetails.verticalRotationOffset = self.cameraVerticalRotationOffset
		cameraDetails.isVerticalRotationFlipped = self.isCameraVerticalRotationFlipped
		cameraDetails.distance = self.targetDistance
	end
	_CONF.camera = cameraDetails
end

function DefaultCameraController:onMapRotationStick()
	self.mapRotationSticky = (self.mapRotationSticky or 0) + 1
end

function DefaultCameraController:onMapRotationUnstick()
	self.mapRotationSticky = (self.mapRotationSticky or 1) - 1
end

function DefaultCameraController:onUnlockPosition()
	self.isPositionUnlocked = (self.isPositionUnlocked or 0) + 1
end

function DefaultCameraController:onLockPosition()
	self.isPositionUnlocked = (self.isPositionUnlocked or 1) - 1
end

function DefaultCameraController:onUnlockRotation()
	self.isRotationUnlocked = (self.isRotationUnlocked or 0) + 1
end

function DefaultCameraController:onLockRotation()
	self.isRotationUnlocked = (self.isRotationUnlocked or 1) - 1

	if self.isRotationUnlocked <= 0 then
		self.cameraVerticalRotationOffset = math.max(
			self.cameraVerticalRotationOffset,
			-DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
		self.cameraVerticalRotationOffset = math.min(
			self.cameraVerticalRotationOffset,
			DefaultCameraController.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
	end
end

function DefaultCameraController:onShake(duration, interval, min, max)
	self.isShaking = true
	self.shakingDuration = duration or 1.5
	self.shakingInterval = interval or 1 / 15
	self.currentShakingInterval = 0
	self.currentShakingDuration = self.shakingDuration
	self.minShakingOffset = min or 0
	self.maxShakingOffset = max or 1
	self.previousShakingOffset = Vector(0):keep()
	self.currentShakingOffset = Vector(0):keep()
end

function DefaultCameraController:onShowMove(points, duration)
	self.curveMode = DefaultCameraController.SHOW_MODE_MOVE
	self.curve = love.math.newBezierCurve(unpack(points))
	self.curveDuration = duration
	self.currentCurveTime = 0
	self.previousCurveX = points[1] * love.graphics.getWidth()
	self.previousCurveY = points[2] * love.graphics.getHeight()
end

function DefaultCameraController:onShowScroll(points, duration)
	self.curveMode = DefaultCameraController.SHOW_MODE_SCROLL
	self.curve = love.math.newBezierCurve(unpack(points))
	self.curveDuration = duration
	self.currentCurveTime = 0
	self.previousCurveX = points[1] * love.graphics.getWidth()
	self.previousCurveY = points[2] * love.graphics.getHeight()
end

function DefaultCameraController:getIsDemoing()
	if self.currentCurveTime then
		return self.currentCurveTime < self.curveDuration
	end

	return false
end

function DefaultCameraController:demoMobile()
	if self.curveMode == DefaultCameraController.SHOW_MODE_MOVE then
		love.graphics.draw(self.cursor, self.previousCurveX, self.previousCurveY)
	elseif self.curveMode == DefaultCameraController.SHOW_MODE_SCROLL then
		local x = love.graphics.getWidth() / 2
		local y = love.graphics.getHeight() / 2

		local range = love.graphics.getHeight() / 2
		local scroll = self.previousCurveY / love.graphics.getHeight()

		love.graphics.push()
		love.graphics.translate(x, y)
		love.graphics.rotate(0, 0, 1, math.pi / 4)
		love.graphics.draw(self.cursor, 0, scroll * range)
		love.graphics.draw(self.cursor, 0, -scroll * range)
		love.graphics.pop()
	end
end

function DefaultCameraController:demo()
	if _MOBILE then
		self:demoMobile()
		return
	end

	if self.curveMode == DefaultCameraController.SHOW_MODE_MOVE then
		love.graphics.draw(self.cursor, self.previousCurveX, self.previousCurveY)
	elseif self.curveMode == DefaultCameraController.SHOW_MODE_SCROLL then
		local x = love.graphics.getWidth() / 2
		local y = love.graphics.getHeight() / 2

		local range = love.graphics.getHeight() / 4
		local scroll = self.previousCurveY / love.graphics.getHeight()


		love.graphics.draw(self.cursor, x, y - range / 2 + scroll * range)
	end
end

function DefaultCameraController:_clampCenter(center)
	local player = self:getGame():getPlayer()
	if not player then
		return center
	end

	local actor = player:getActor()
	if not actor then
		return center
	end

	local _, _, layer = actor:getTile()
	local map = self:getGameView():getMap(layer)
	local mapSceneNode = self:getGameView():getMapSceneNode(layer)

	if not map or not mapSceneNode then
		return center
	end

	self._camera:copy(self:getCamera())
	self._camera:setPosition(Vector.ZERO)
	self._camera:setDistance(0)
	self._camera:setRotation(Quaternion.IDENTITY)
	self._camera:setVerticalRotation(math.pi / 4)
	self._camera:setHorizontalRotation(0)
	self._camera:setFar(self.MAX_DISTANCE * math.sqrt(2))

	local viewMin, viewMax = Vector(math.huge), Vector(-math.huge)
	for x = 0, 1 do
		for z = 0, 1 do
			local corner = Vector(2 * x - 1, 0, 2 * z - 1)
			corner = self._camera:unproject(corner) * Vector.PLANE_XZ

			viewMin = viewMin:min(corner)
			viewMax = viewMax:max(corner)
		end
	end

	local viewSize = Vector(viewMax.x - viewMin.x, 0, viewMax.z - viewMin.z)

	local delta = self:getApp():getFrameDelta()
	local transform = mapSceneNode:getTransform():getGlobalDeltaTransform(delta)
	local mapMin, mapMax = Vector(0, 0, 0), Vector(map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize())
	mapMin, mapMax = Vector.transformBounds(mapMin, mapMax, transform)
	local mapHalfSize = (mapMax - mapMin) / 2

	local min = mapMin + viewSize
	local max = mapMax - viewSize
	local newCenter = center:clamp(min, max)
	newCenter.y = center.y

	return newCenter
end

function DefaultCameraController:draw()
	local distance = self.currentDistance

	local verticalOffset
	if self.cameraVerticalRotationFlipTime then
		local mu = self.cameraVerticalRotationFlipTime / DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIP_TIME_SECONDS

		local sourceVerticalRotation
		local targetVerticalRotation
		if self.isCameraVerticalRotationFlipped then
			sourceVerticalRotation = DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIPPED
			targetVerticalRotation = DefaultCameraController.CAMERA_VERTICAL_ROTATION
		else
			sourceVerticalRotation = DefaultCameraController.CAMERA_VERTICAL_ROTATION
			targetVerticalRotation = DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIPPED
		end
		targetVerticalRotation = targetVerticalRotation + self.cameraVerticalRotationOffset

		verticalOffset = math.lerpAngle(
			sourceVerticalRotation,
			targetVerticalRotation,
			Tween.sineEaseOut(mu))
	elseif self.isCameraVerticalRotationFlipped then
		verticalOffset = DefaultCameraController.CAMERA_VERTICAL_ROTATION_FLIPPED + self.cameraVerticalRotationOffset
	else
		verticalOffset = DefaultCameraController.CAMERA_VERTICAL_ROTATION + self.cameraVerticalRotationOffset
	end

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

	local horizontalOffset = DefaultCameraController.CAMERA_HORIZONTAL_ROTATION + self.cameraHorizontalRotationOffset
	do
		local panningDelta = math.clamp(self.panningTime / DefaultCameraController.PAN_TIME)
		verticalOffset = verticalOffset + self.panningVerticalRotationOffset * panningDelta
		horizontalOffset = horizontalOffset + self.panningHorizontalRotationOffset * panningDelta
		center = center + DefaultCameraController.PAN_OFFSET * panningDelta
		distance = math.lerp(distance, DefaultCameraController.PAN_DISTANCE, panningDelta)
	end

	self:getCamera():setVerticalRotation(verticalOffset)
	self:getCamera():setHorizontalRotation(horizontalOffset)
	self:getCamera():setDistance(distance)

	if not _DEBUG and self.isPositionUnlocked <= 0 then
		center = self:_clampCenter(center)
	end

	local shake
	if self.currentShakingOffset and self.previousShakingOffset then
		shake = self.previousShakingOffset:lerp(self.currentShakingOffset, 1 - (self.currentShakingInterval / self.shakingInterval)):keep()
	else
		shake = Vector.ZERO
	end

	self:getCamera():setPosition(center + self.cameraOffset + shake)

	if self.mapRotationSticky and self.mapRotationSticky > 0 then
		self:getCamera():setRotation(-self:getPlayerMapRotation())
	else
		self:getCamera():setRotation()
	end
end

return DefaultCameraController
