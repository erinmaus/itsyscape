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
	self.verticalRotationTween = 'linear'

	self.currentHorizontalRotation = StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION
	self.previousHorizontalRotation = StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION
	self.targetHorizontalRotation = StandardCutsceneCameraController.CAMERA_HORIZONTAL_ROTATION
	self.currentHorizontalRotationTime = 1
	self.targetHorizontalRotationTime = 1
	self.horizontalRotationTween = 'linear'

	self.currentZoom = StandardCutsceneCameraController.ZOOM
	self.previousZoom = StandardCutsceneCameraController.ZOOM
	self.targetZoom = StandardCutsceneCameraController.ZOOM
	self.currentZoomTime = 1
	self.targetZoomTime = 1
	self.zoomTween = 'linear'

	self.currentTranslation = StandardCutsceneCameraController.TRANSLATION
	self.previousTranslation = StandardCutsceneCameraController.TRANSLATION
	self.targetTranslation = StandardCutsceneCameraController.TRANSLATION
	self.currentTranslationTime = 1
	self.targetTranslationTime = 1
	self.translationTween = 'linear'

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
			local _, _, layer = self.targetActor:getTile()
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

	if self.isShaking then
		self.currentShakingInterval = self.currentShakingInterval - delta
		if self.currentShakingInterval <= 0 then
			self.currentShakingInterval = self.shakingInterval

			local x = love.math.random() * (self.maxShakingOffset - self.minShakingOffset) + self.minShakingOffset
			local y = love.math.random() * (self.maxShakingOffset - self.minShakingOffset) + self.minShakingOffset
			local z = love.math.random() * (self.maxShakingOffset - self.minShakingOffset) + self.minShakingOffset

			self.previousShakingOffset = self.currentShakingOffset
			self.currentShakingOffset = Vector(x, y, z)
		end

		self.currentShakingDuration = self.currentShakingDuration - delta
		if self.currentShakingDuration <= 0 then
			self.isShaking = false
			self.currentShakingOffset = Vector(0)
		end
	end
end

function StandardCutsceneCameraController:onTranslate(position, duration)
	self.previousTranslation = self.currentTranslation
	self.targetTranslation = position

	if duration == 0 or not duration then
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

	if duration == 0 or not duration then
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

	if duration == 0 or not duration then
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

	if duration == 0 or not duration then
		self.currentHorizontalRotationTime = 1
		self.targetHorizontalRotationTime = 1
		self.currentHorizontalRotation = self.targetHorizontalRotation
	else
		self.currentHorizontalRotationTime = 0
		self.targetHorizontalRotationTime = duration
	end
end

function StandardCutsceneCameraController:onShake(duration, interval, min, max)
	self.isShaking = true
	self.shakingDuration = duration or 1.5
	self.shakingInterval = interval or 1 / 15
	self.currentShakingInterval = 0
	self.currentShakingDuration = self.shakingDuration
	self.minShakingOffset = min or 0
	self.maxShakingOffset = max or 1
	self.previousShakingOffset = Vector(0)
	self.currentShakingOffset = Vector(0)
end

function StandardCutsceneCameraController:onMapRotationStick(duration)
	self.mapRotationSticky = (self.mapRotationSticky or 0) + 1
	self.mapRotationStickyDuration = duration or 0
end

function StandardCutsceneCameraController:onMapRotationUnstick()
	self.mapRotationSticky = (self.mapRotationSticky or 1) - 1
end

function StandardCutsceneCameraController:getActorMapRotation()
	if not self.targetActor then
		return Quaternion.IDENTITY
	end

	local _, _, layer = self.targetActor:getTile()
	local mapSceneNode = self:getGameView():getMapSceneNode(layer)
	if not mapSceneNode then
		return Quaternion.IDENTITY
	end

	local _, previousRotation = mapSceneNode:getTransform():getPreviousTransform()
	local currentRotation = mapSceneNode:getTransform():getLocalRotation()
	local rotation = previousRotation:slerp(currentRotation, self:getApp():getFrameDelta())

	if self.currentActorLayer ~= layer then
		self.currentActorLayer = layer
		self.previousActorMapRotation = self.currentActorMapRotation
		self.previousActorMapRotationTime = 0
	end

	self.currentActorMapRotation = rotation

	if self.previousActorMapRotation then
		local delta
		if self.mapRotationStickyDuration > 0 then
			delta = math.min(self.previousActorMapRotationTime / self.mapRotationStickyDuration, 1)
		else
			delta = 1
		end

		return self.previousActorMapRotation:slerp(self.currentActorMapRotation, delta)
	else
		return self.currentActorMapRotation
	end
end

function StandardCutsceneCameraController:draw()
	local shake
	if self.currentShakingOffset and self.previousShakingOffset then
		shake = self.previousShakingOffset:lerp(self.currentShakingOffset, 1 - (self.currentShakingInterval / self.shakingInterval))
	else
		shake = Vector.ZERO
	end

	self:getCamera():setDistance(self.currentZoom)
	self:getCamera():setHorizontalRotation(self.currentHorizontalRotation)
	self:getCamera():setVerticalRotation(self.currentVerticalRotation - math.pi / 2)
	self:getCamera():setPosition(self:getTargetPosition() + self.currentTranslation + shake)

	if self.mapRotationSticky and self.mapRotationSticky > 0 then
		self:getCamera():setRotation(-self:getActorMapRotation())
	else
		self:getCamera():setRotation()
	end
end

return StandardCutsceneCameraController
