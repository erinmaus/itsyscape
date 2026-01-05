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
local MapCurve = require "ItsyScape.World.MapCurve"

local DebugManipulateCameraController = Class(CameraController)
DebugManipulateCameraController.CAMERA_VERTICAL_ROTATION = math.pi / 2
DebugManipulateCameraController.SCROLL_SPEED_MULTIPLIER = 10

DebugManipulateCameraController.ROTATE_SPEED            = math.pi / 4
DebugManipulateCameraController.PAN_SPEED_MULTIPLIER    = 1 / 64

DebugManipulateCameraController.CONSTANT_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi)

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
	self.currentDelay = 0
	self.currentDuration = 0
	self.currentElapsed = 0
	self.currentExcessDelta = 0
	self.currentCurve = nil

	self.pending = {}
	self.currentIndex = 1
end

function DebugManipulateCameraController:onCopyTransforms()
	self.translationOffset = self:getCamera():getEye():keep()
	self.rotationOffset = (-self.CONSTANT_ROTATION * self:getCamera():getCombinedRotation()):getNormal()
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

function DebugManipulateCameraController:onOrientateToActor(actorID, delay, duration, tween)
	local nextActor = self:getGameView():getActorByID(actorID)
	if not nextActor then
		return
	end

	if self.currentElapsed >= self.currentDuration and self.currentDuration > 0 then
		self:reset()
	end

	table.insert(self.pending, {
		actor = nextActor,
		delay = delay or 0,
		duration = duration or 0,
		tween = tween
	})

	self:rebuildMapCurve()
end

function DebugManipulateCameraController:onOrientateFromActorToActor(actorID, otherActorID, delay, duration, tween)
	local nextActor = self:getGameView():getActorByID(actorID)
	if not nextActor then
		return
	end

	local otherActor = self:getGameView():getActorByID(otherActorID)
	if not otherActor then
		return
	end

	if self.currentElapsed >= self.currentDuration and self.currentDuration > 0 then
		self:reset()
	end

	table.insert(self.pending, {
		actor = nextActor,
		otherActor = otherActor,
		delay = delay or 0,
		duration = duration or 0,
		tween = tween
	})

	self:rebuildMapCurve()
end

function DebugManipulateCameraController:rebuildMapCurve()
	local totalDuration = 0

	local positions = {}
	local rotations = {}
	local previousRotation, previousPosition
	for _, p in ipairs(self.pending) do
		totalDuration = totalDuration + (p.duration or 1)

		local translation, rotation = self:getActorTransforms(p.actor)

		if previousRotation then
			local distance = previousPosition:distance(translation)
			local steps = math.max(math.ceil(distance / 4), 1)

			for i = 1, steps do
				local delta = i / (steps + 1)
				local r = previousRotation:slerp(rotation, delta)
				table.insert(rotations, { r:get() })
			end
		end

		if previousPosition then
			local distance = previousPosition:distance(translation)
			local steps = math.max(math.ceil(distance / 4), 1)

			for i = 1, steps do
				local delta = i / (steps + 1)
				local p = previousPosition:lerp(translation, delta)
				table.insert(positions, { p:get() })
			end
		end

		table.insert(positions, { translation:get() })
		table.insert(rotations, { rotation:get() })


		previousPosition = translation
		previousRotation = rotation
	end

	print ("#positions", #positions)
	print ("#rotations", #rotations)
	self.currentDuration = totalDuration
	self.currentCurve = MapCurve(nil, {
		linear = false,
		width = 1,
		height = 1,
		unit = 1,
		positions = positions,
		rotations = rotations
	})
end

function DebugManipulateCameraController:getActorTransforms(actor)
	local actorView = self:getGameView():getView(actor)
	local transform = actorView and actorView:getSceneNode():getTransform():getGlobalDeltaTransform(1) or love.math.newTransform()
	local translation, rotation = MathCommon.decomposeTransform(transform)
	rotation = Quaternion(-rotation.x, -rotation.y, -rotation.z, rotation.w)

	return translation, rotation
end

function DebugManipulateCameraController:copyActorTransforms(actor)
	local translation, rotation = self:getActorTransforms(actor)
	self.translationOffset = translation:keep()
	self.rotationOffset = rotation:getNormal()
end

function DebugManipulateCameraController:onCopyActorTransforms(actorID)
	local actor = self:getGameView():getActorByID(actorID)
	if actor then
		self:copyActorTransforms(actor)
	end
end

function DebugManipulateCameraController:onShake(duration, interval, min, max)
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

function DebugManipulateCameraController:updateCurve(delta)
	if self.currentIndex <= #self.pending then
		local p = self.pending[self.currentIndex]

		if self.currentDelay < p.delay then
			local nextDelay = self.currentDelay + delta + self.currentExcessDelta
			local remainingDelta = math.max(nextDelay - p.delay, 0)

			self.currentDelay = math.min(nextDelay, p.delay)
			self.currentExcessDelta = remainingDelta
		elseif self.currentElapsed <= self.currentDuration then
			local nextElapsed = self.currentElapsed + delta + self.currentExcessDelta

			local pendingDuration = 0
			for i = 1, self.currentIndex do
				pendingDuration = pendingDuration + self.pending[i].duration
			end

			local nextDuration = pendingDuration + (self.pending[self.currentIndex + 1] and self.pending[self.currentIndex + 1].duration or 0)

			local remainingDelta = math.max(nextElapsed - pendingDuration, 0)
			self.currentExcessDelta = remainingDelta

			self.currentElapsed = math.min(nextElapsed, nextDuration)
			if self.currentElapsed >= pendingDuration then
				self.currentDelay = 0
				self.currentIndex = self.currentIndex + 1
			end
		end
	end
end

function DebugManipulateCameraController:updateShake(delta)
	if not self.isShaking then
		return
	end

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
		self.previousShakingOffset = Vector(0):keep()
		self.currentShakingOffset = Vector(0):keep()
	end
end

function DebugManipulateCameraController:update(delta)
	CameraController.update(self, delta)

	self:updateCurve(delta)
	self:updateShake(delta)
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
			local rotation = Quaternion(-self.rotationOffset.x, -self.rotationOffset.y, -self.rotationOffset.z, self.rotationOffset.w)
			self:pokeInterface("updateCameraRotation", rotation)
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

function DebugManipulateCameraController:getDelta()
	if self.currentDuration == 0 then
		return 1
	end

	return Tween.sineEaseInOut(math.clamp(self.currentElapsed / self.currentDuration))
end

function DebugManipulateCameraController:draw()
	CameraController.draw(self)

	local shake
	if self.currentShakingOffset and self.previousShakingOffset then
		shake = self.previousShakingOffset:lerp(self.currentShakingOffset, 1 - (self.currentShakingInterval / self.shakingInterval))
	else
		shake = Vector.ZERO
	end

	local camera = self:getCamera()

	camera:setDistance(0)
	camera:setVerticalRotation(math.pi / 2)
	camera:setHorizontalRotation(-math.pi)
	camera:setIsWallHackEnabled(false)

	local translation, rotation
	if self.currentCurve then
		local delta = self:getDelta()
		translation, rotation = self.currentCurve:evaluate(delta)
	else
		translation, rotation = Vector.ZERO, Quaternion.IDENTITY
	end

	local p = self.pending[math.min(self.currentIndex, #self.pending)]
	if p and p.otherActor then
		local currentTranslation = self:getActorTransforms(p.actor)
		local otherTranslation = self:getActorTransforms(p.otherActor)
		rotation = Quaternion.lookAt(translation, otherTranslation, Vector.UNIT_Y)
		rotation = Quaternion(-rotation.x, -rotation.y, -rotation.z, rotation.w)
	end

	camera:setRotation((self.CONSTANT_ROTATION * rotation * self.rotationOffset):getNormal())
	camera:setPosition(translation + self.translationOffset + shake)
end

return DebugManipulateCameraController
