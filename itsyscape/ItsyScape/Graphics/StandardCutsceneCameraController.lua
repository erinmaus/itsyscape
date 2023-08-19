--------------------------------------------------------------------------------
-- ItsyScape/Graphics/StandardCutsceneCameraController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CameraController = require "ItsyScape.Graphics.CameraController"

local StandardCutsceneCameraController = Class(CameraController)
StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
StandardCutsceneCameraController.CAMERA_VERTICAL_ROTATION = -math.pi / 2
StandardCutsceneCameraController.ZOOM = 20
StandardCutsceneCameraController.TRANSLATION = Vector.ZERO

function StandardCutsceneCameraController:new(...)
	CameraController.new(self, ...)

	self.currentVerticalRotation = StandardCutsceneCameraController.CAMERA_VERTICAL_ROTATION
	self.previousVerticalRotation = StandardCutsceneCameraController.CAMERA_VERTICAL_ROTATION
	self.targetVerticalRotation = StandardCutsceneCameraController.CAMERA_VERTICAL_ROTATION
	self.currentVerticalRotationTime = 1
	self.targetVerticalRotationTime = 1
	self.verticalRotationTween = 'expEaseOut'

	self.currentHorizontalRotation = StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION
	self.previousHorizontalRotation = StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION
	self.targetHorizontalRotation = StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION
	self.currentHorizontalRotationTime = 1
	self.targetHorizontalRotationTime = 1
	self.horizontalRotationTween = 'expEaseOut'

	self.currentZoom = StandardCutsceneCameraController.ZOOM
	self.previousZoom = StandardCutsceneCameraController.ZOOM
	self.targetZoom = StandardCutsceneCameraController.ZOOM
	self.currentZoomTime = 1
	self.targetZoomTime = 1
	self.zoomTween = 'sineEaseOut'

	self.currentTranslation = StandardCutsceneCameraController.TRANSLATION
	self.previousTranslation = StandardCutsceneCameraController.TRANSLATION
	self.targetTranslation = StandardCutsceneCameraController.TRANSLATION
	self.currentTranslationTime = 1
	self.targetTranslationTime = 1
	self.translationTween = 'expEaseOut'

	self:trySetTargetActor()
end

function StandardCutsceneCameraController:trySetTargetActor()
	if not self.targetActor then
		local player = self:getGame():getPlayer()
		player = player and player:getActor()


		self.targetActor = player or false
	end
end

function StandardCutsceneCameraController:getTargetPosition()
	local delta = self:getApp():getFrameDelta()

	local position
	do
		self:trySetTargetActor()

		local gameView = self:getGameView()
		local actor = gameView:getActor(self.targetActor)
		if actor then
			local node = actor:getSceneNode()
			local transform = node:getTransform():getGlobalDeltaTransform(delta or 0)
			position = Vector(transform:transformPoint(0, 1, 0))
		end
	end

	return position or Vector.ZERO
end

function StandardCutsceneCameraController:update(delta)
	self.currentVerticalRotationTime = math.min(self.currentVerticalRotationTime + delta, self.targetVerticalRotationTime)
	self.currentHorizontalRotationTime = math.min(self.currentHorizontalRotationTime + delta, self.targetHorizontalRotationTime)
	self.currentZoomTime = math.min(self.currentZoomTime + delta, self.targetZoomTime)

	self.currentZoom = (self.targetZoom - self.previousZoom) * Tween[self.zoomTween](self.currentZoomTime / self.targetZoomTime) + self.previousZoom
	self.currentHorizontalRotation = (self.targetHorizontalRotation - self.previousHorizontalRotation) * Tween[self.horizontalRotationTween](self.currentHorizontalRotationTime / self.targetHorizontalRotationTime) + self.previousHorizontalRotation
	self.currentVerticalRotation = (self.targetVerticalRotation - self.previousVerticalRotation) * Tween[self.verticalRotationTween](self.currentVerticalRotationTime / self.targetVerticalRotationTime) + self.previousVerticalRotation

	self.currentTranslationTime = math.min(self.currentTranslationTime + delta, self.targetTranslationTime)
	self.currentTranslation = self.previousTranslation:lerp(self.targetTranslation, Tween[self.translationTween](self.currentTranslationTime / self.targetTranslationTime))
end

function StandardCutsceneCameraController:onTranslate(position, duration)
	self.previousTranslation = self.currentTranslation
	self.targetTranslation = position

	if duration == 0 then
		self.currentTranslationTime = 1
		self.targetTranslationTime = 1
		self.currentTranslation = self.targetTranslation
	else
		self.currentTranslationTime = 0
		self.targetTranslationTime = duration
	end
end

function StandardCutsceneCameraController:onTargetActor(actorID)
	local stage = self:getGame():getStage()
	for actor in stage:iterateActors() do
		if actor:getID() == actorID then
			self.targetActor = actor
			Log.info("Targetting actor ('%s') with ID %d.", actor:getName(), actorID)
			return
		end
	end

	Log.warn("Couldn't find actor with ID %d.", actorID)
end

function StandardCutsceneCameraController:onZoom(distance, duration)
	self.previousZoom = self.currentZoom
	self.targetZoom = distance

	if duration == 0 then
		self.currentZoomTime = 1
		self.targetZoomTime = 1
		self.currentZoom = self.targetZoom
	else
		self.currentZoomTime = 0
		self.targetZoomTime = duration
	end
end

function StandardCutsceneCameraController:onVerticalRotate(angle, duration)
	self.previousVerticalRotation = self.currentVerticalRotation
	self.targetVerticalRotation = angle

	if duration == 0 then
		self.currentVerticalRotationTime = 1
		self.targetVerticalRotationTime = 1
		self.currentVerticalRotation = self.targetVerticalRotation
	else
		self.currentVerticalRotationTime = 0
		self.targetVerticalRotationTime = duration
	end
end

function StandardCutsceneCameraController:onHorizontalRotate(angle, duration)
	self.previousHorizontalRotation = self.currentHorizontalRotation
	self.targetHorizontalRotation = angle

	if duration == 0 then
		self.currentHorizontalRotationTime = 1
		self.targetHorizontalRotationTime = 1
		self.currentHorizontalRotation = self.targetHorizontalRotation
	else
		self.currentHorizontalRotationTime = 0
		self.targetHorizontalRotationTime = duration
	end
end

function StandardCutsceneCameraController:draw()
	self:getCamera():setDistance(self.currentZoom)
	self:getCamera():setHorizontalRotation(self.currentHorizontalRotation)
	self:getCamera():setVerticalRotation(self.currentVerticalRotation)
	self:getCamera():setPosition(self:getTargetPosition() + self.currentTranslation)
end

return StandardCutsceneCameraController
