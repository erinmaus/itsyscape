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

function DebugManipulateCameraController:new(...)
	CameraController.new(self, ...)

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

function DebugManipulateCameraController:onReset()
	self:reset()
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

		self.currentTranslation = translation:keep()
		self.currentRotation = rotation:keep()
	else
		local nextActorView = self:getGameView():getView(nextActor)
		local transform = nextActorView:getSceneNode():getTransform():getGlobalDeltaTransform(_APP:getPreviousFrameDelta())
		local translation, rotation = MathCommon.decomposeTransform(transform)

		self.previousTranslation = translation:keep()
		self.currentTranslation = translation:keep()

		self.previousRotation = rotation:keep()
		self.currentRotation = rotation:keep()
	end

	self.currentDelay = 0
	self.currentDuration = duration
	self.currentElapsed = 0
	self.currentTween = tween
end

function DebugManipulateCameraController:onOrientateToActor(actorID, duration, tween)
	local nextActor = self:getGameView():getActorByID(actorID)
	if nextActor then
		self:orientateToActor(nextActor, duration, tween)
	end
end

function DebugManipulateCameraController:update(delta)
	CameraController.update(self, delta)

	self.currentElapsed = math.min(self.currentElapsed + delta, self.currentDuration + self.currentDelay)
end

function DebugManipulateCameraController:draw()
	CameraController.draw(self)

	local camera = self:getCamera()

	camera:setDistance(0)
	camera:setHorizontalRotation(0)
	camera:setVerticalRotation(0)

	local delta = math.max(self.currentElapsed - self.currentDelay, 0) / self.currentDuration
	local mu = (Tween[self.currentTween] or Tween.linear)(math.clamp(delta))

	local rotation = self.previousRotation:slerp(self.currentRotation, mu)
	local translation = self.previousTranslation:lerp(self.currentTranslation, mu)

	local offsetRotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi)

	camera:setRotation((-camera:getLocalRotation()) * rotation * offsetRotation)
	camera:setPosition(translation)
end

return DebugManipulateCameraController
