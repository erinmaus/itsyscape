--------------------------------------------------------------------------------
-- Resources/Game/Props/Theodyssius_Head/View.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Head = Class(PropView)

Head.EYE_OFFSET    = Vector(0, 8, 0)
Head.CROWN_OFFSET  = Vector(0, 8.5, 0)
Head.TARGET_OFFSET = Vector(0, 2, 0)

Head.INNER_CROWN_SCALE = Vector(3)
Head.OUTER_CROWN_SCALE = Vector(4.5)

function Head:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.innerCrown = DecorationSceneNode()
	self.outerCrown = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Theodyssius_Head/Crown.png",
		function(texture)
			self.crownTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Theodyssius_Head/Crown.lstatic",
		function(mesh)
			self.innerCrown:fromGroup(mesh:getResource(), "Crown")
			self.innerCrown:getMaterial():setTextures(self.crownTexture)
			self.innerCrown:setParent(root)
			self.innerCrown:getTransform():setLocalScale(Head.INNER_CROWN_SCALE)

			self.outerCrown:fromGroup(mesh:getResource(), "Crown")
			self.outerCrown:getMaterial():setTextures(self.crownTexture)
			self.outerCrown:setParent(root)
			self.outerCrown:getTransform():setLocalScale(Head.OUTER_CROWN_SCALE)
		end)

	self.eye = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Theodyssius_Head/Eye.png",
		function(texture)
			self.eyeTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Theodyssius_Head/Eye.lstatic",
		function(mesh)
			self.eye:fromGroup(mesh:getResource(), "Eye")
			self.eye:getMaterial():setTextures(self.eyeTexture)
			self.eye:setParent(root)
		end)
end

function Head:updateEye(delta)
	local state = self:getProp():getState()

	local targetPosition
	local worldEyePosition, localEyePosition
	local localCrownPosition

	local targetActorID = state.target
	if targetActorID then
		local targetActor = self:getGameView():getActorByID(targetActorID)
		local targetActorView = self:getGameView():getActor(targetActor)

		if targetActorView then
			local accumulatedTransform
			do
				local headTransform = targetActorView:getLocalBoneTransform("head")
				local worldTransform = targetActorView:getSceneNode():getTransform():getGlobalTransform(_APP:getFrameDelta())
				accumulatedTransform = love.math.newTransform()
				accumulatedTransform:apply(worldTransform)
				accumulatedTransform:apply(headTransform)
			end

			targetPosition = Vector(accumulatedTransform:transformPoint(Head.TARGET_OFFSET:get()))
		end
	end

	local eyeID = state.eye
	if eyeID then
		local eye = self:getGameView():getActorByID(eyeID)
		local eyeView = self:getGameView():getActor(eye)

		if eyeView then
			local accumulatedTransform
			do
				local headTransform = eyeView:getLocalBoneTransform("head")
				local worldTransform = eyeView:getSceneNode():getTransform():getGlobalTransform(_APP:getFrameDelta())

				accumulatedTransform = love.math.newTransform()
				accumulatedTransform:apply(worldTransform)
				accumulatedTransform:apply(headTransform)

				localEyePosition = Vector(headTransform:transformPoint(Head.EYE_OFFSET:get()))
				localCrownPosition = Vector(headTransform:transformPoint(Head.CROWN_OFFSET:get()))
			end

			worldEyePosition = Vector(accumulatedTransform:transformPoint(Head.EYE_OFFSET:get()))
		end
	end

	if targetPosition and worldEyePosition and localEyePosition then
		local targetRotation = Quaternion.lookAt(
			targetPosition * Vector.PLANE_XZ,
			worldEyePosition * Vector.PLANE_XZ)

		local transform = self.eye:getTransform()
		local currentRotation = transform:getLocalRotation()

		transform:setLocalRotation(targetRotation)
		transform:setLocalTranslation(localEyePosition)

		if self.innerCrown and self.outerCrown then
			self.innerCrown:getTransform():setLocalTranslation(localCrownPosition)
			self.outerCrown:getTransform():setLocalTranslation(localCrownPosition)
		end
	end
end

function Head:updateCrown(delta)
	local innerCrownRotation = Quaternion.fromAxisAngle(Vector(1, 0.5, 1), math.pi * delta)
	local outerCrownRotation = Quaternion.fromAxisAngle(Vector(-1, 0.5, -1), math.pi * delta)

	local innerCrownTransform = self.innerCrown:getTransform()
	local outerCrownTransform = self.outerCrown:getTransform()

	innerCrownTransform:setLocalRotation(innerCrownTransform:getLocalRotation() * innerCrownRotation)
	outerCrownTransform:setLocalRotation(outerCrownTransform:getLocalRotation() * outerCrownRotation)
end

function Head:update(delta)
	PropView.update(self, delta)

	if self.eye then
		self:updateEye(delta)
	end

	if self.innerCrown and self.outerCrown then
		self:updateCrown(delta)
	end
end

function Head:getIsStatic()
	return false
end

return Head
