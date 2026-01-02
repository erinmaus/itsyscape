--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DebugManipulateCameraController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local CameraController = require "ItsyScape.Graphics.CameraController"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local DebugManipulateCameraController = Class(CameraController)
DebugManipulateCameraController.CAMERA_VERTICAL_ROTATION = math.pi / 2
DebugManipulateCameraController.SCROLL_SPEED_MULTIPLIER = 10

DebugManipulateCameraController.ROTATE_SPEED            = math.pi / 4
DebugManipulateCameraController.PAN_SPEED_MULTIPLIER    = 1 / 64

DebugManipulateCameraController.CONSTANT_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_Z, -math.pi)

function DebugManipulateCameraController:new(...)
	CameraController.new(self, ...)

	self.isInteractive = false
	self.interactiveLock = 0
	self.isPanning = false
	self.isRotating = false

	self.translationOffset = Vector.ZERO
	self.rotationOffset = Quaternion.IDENTITY

	self:reset()
end

function DebugManipulateCameraController:reset()
	self.previousRotation = Quaternion.IDENTITY
	self.currentRotation = Quaternion.IDENTITY

	self.previousTranslation = Vector.ZERO
	self.currentTranslation = Vector.ZERO

	self.currentActor = false
	self.previousActor = false

	self.currentDelay = 0
	self.currentDuration = 1
	self.currentElapsed = 1
	self.currentTween = "linear"
end

function DebugManipulateCameraController:onCopyTransforms()
	self.translationOffset = self:getCamera():getEye():keep()
	self.rotationOffset = self:getCamera():getCombinedRotation()
end

function DebugManipulateCameraController:onResetTransforms()
	self.translationOffset = Vector.ZERO
	self.rotationOffset = Quaternion.IDENTITY
end

function DebugManipulateCameraController:onReset()
	self:reset()
end

function DebugManipulateCameraController:onEnableInteraction()
	self.interactiveLock = self.interactiveLock + 1
	self.isInteractive = self.interactiveLock > 0
end

function DebugManipulateCameraController:onDisableInteraction()
	self.interactiveLock = self.interactiveLock - 1
	self.isInteractive = self.interactiveLock <= 0
end

function DebugManipulateCameraController:orientateToActor(nextActor, delay, duration, tween)
	local previousActor = self.previousActor
	local currentActor = self.currentActor

	self.previousActor = self.currentActor
	self.currentActor = nextActor

	if previousActor and currentActor then
		local delta = math.max(self.currentElapsed - self.currentDelay, 0) / self.currentDuration
		local mu = (Tween[self.currentTween] or Tween.linear)(delta)

		self.previousRotation = self.previousRotation:slerp(self.currentRotation, mu):keep()
		self.previousTranslation = self.previousTranslation:lerp(self.currentTranslation, mu):keep()
	elseif currentActor then
		local nextActorView = self:getGameView():getView(currentActor)
		local translation, rotation = MathCommon.decomposeTransform(transform)
		rotation = rotation * self.CONSTANT_ROTATION

		self.currentTranslation = translation:keep()
		self.currentRotation = rotation:keep()
	else
		local nextActorView = self:getGameView():getView(nextActor)
		local transform = nextActorView:getSceneNode():getTransform():getGlobalDeltaTransform(_APP:getPreviousFrameDelta())
		local translation, rotation = MathCommon.decomposeTransform(transform)
		rotation = rotation * self.CONSTANT_ROTATION

		self.previousTranslation = translation:keep()
		self.currentTranslation = translation:keep()

		self.previousRotation = rotation:keep()
		self.currentRotation = rotation:keep()
	end

	self.currentDelay = delay
	self.currentDuration = duration
	self.currentElapsed = 0
	self.currentTween = tween
end

function DebugManipulateCameraController:onOrientateToActor(actorID, delay, duration, tween)
	local nextActor = self:getGameView():getActorByID(actorID)
	if nextActor then
		self:orientateToActor(nextActor, delay, duration, tween)
	end
end

function DebugManipulateCameraController:update(delta)
	CameraController.update(self, delta)

	self.currentElapsed = math.min(self.currentElapsed + delta, self.currentDuration + self.currentDelay)
end

function DebugManipulateCameraController:mousePress(uiActive, x, y, button)
	CameraController.mousePress(self, uiActive, x, y, button)

	if uiActive then
		return CameraController.PROBE_SUPPRESS
	end

	if button == 1 then
		self:pokeInterface("startCameraInteraction")
		self.isRotating = true
	elseif button == 3 then
		self:pokeInterface("startCameraInteraction")
		self.isPanning = true
	end

	return CameraController.PROBE_SUPPRESS
end

function DebugManipulateCameraController:mouseScroll(uiActive, x, y)
	CameraController.mouseScroll(self, uiActive, x, y)

	if uiActive then
		return
	end

	if love.system.getOS() ~= "OS X" then
		y = y * self.SCROLL_SPEED_MULTIPLIER
	else
		y = y / self.SCROLL_SPEED_MULTIPLIER
	end

	local offset = self:getCamera():getUp() * y
	self.translationOffset = (self.translationOffset + offset):keep()

	self:pokeInterface("startCameraInteraction")
	self:pokeInterface("updateCameraTranslation", self.translationOffset)
	self:pokeInterface("stopCameraInteraction")
end

function DebugManipulateCameraController:mouseMove(uiActive, x, y, dx, dy)
	CameraController.mouseMove(self, uiActive, x, y, dx, dy)

	if uiActive then
		return CameraController.PROBE_SUPPRESS
	end

	if self.isRotating then
		local rotateXSpeedModifier = self.ROTATE_SPEED / love.graphics.getWidth()
		local rotateYSpeedModifier = self.ROTATE_SPEED / love.graphics.getHeight()

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -dy * rotateXSpeedModifier)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, dx * rotateYSpeedModifier)

		self.rotationOffset = (xRotation * self.rotationOffset * yRotation):keep()
	end

	if self.isPanning then
		self:draw()

		local _, yRotation = self:getCamera():getCombinedRotation():decomposeAxis(Vector.UNIT_Y)
		yRotation = (-yRotation):getNormal()

		local offset = yRotation:transformVector(Vector(dx * self.PAN_SPEED_MULTIPLIER, 0, dy * self.PAN_SPEED_MULTIPLIER))
		self.translationOffset = (self.translationOffset + offset):keep()
	end

	return CameraController.PROBE_SUPPRESS
end

function DebugManipulateCameraController:mouseRelease(uiActive, x, y, button)
	CameraController.mouseRelease(self, uiActive, x, y, button)

	if button == 1 then
		if self.isRotating and self.isInteractive then
			self:pokeInterface("updateCameraRotation", self.rotationOffset)
			self:pokeInterface("stopCameraInteraction")
		end

		self.isRotating = false
	elseif button == 3 then
		if self.isPanning and self.isInteractive then
			self:pokeInterface("updateCameraTranslation", self.translationOffset)
			self:pokeInterface("stopCameraInteraction")
		end

		self.isPanning = false
	end

	return CameraController.PROBE_SUPPRESS
end

function DebugManipulateCameraController:pokeInterface(action, ...)
	local interface = self:getUIView():getInterface("DebugManipulate")
	if interface then
		interface:simulatePoke("pokeAction", action, ...)
	end
end

function DebugManipulateCameraController:draw()
	CameraController.draw(self)

	local camera = self:getCamera()

	camera:setDistance(0)
	camera:setVerticalRotation(-math.pi / 2)
	camera:setHorizontalRotation(math.pi)

	local delta
	do
		local numerator = math.max(self.currentElapsed - self.currentDelay, 0)
		if self.currentDuration > 0 then
			delta = numerator / self.currentDuration
		else
			delta = 1
		end
	end

	local mu = (Tween[self.currentTween] or Tween.linear)(math.clamp(delta))

	local rotation = self.previousRotation:slerp(self.currentRotation, mu)
	local translation = self.previousTranslation:lerp(self.currentTranslation, mu)

	camera:setRotation((rotation * self.rotationOffset):getNormal())
	camera:setPosition(translation + self.translationOffset)
end

return DebugManipulateCameraController
