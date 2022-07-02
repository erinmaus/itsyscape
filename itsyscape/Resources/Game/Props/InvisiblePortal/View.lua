--------------------------------------------------------------------------------
-- Resources/Game/Props/InvisiblePortal/View.lua
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
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local InvisiblePortal = Class(PropView)
InvisiblePortal.ROTATE_MAX_SPEED_MULTIPLIER = 1
InvisiblePortal.ROTATE_MIN_SPEED_MULTIPLIER = 0.25
InvisiblePortal.ROTATE_SPEED_MULTIPLIER_WIDTH = InvisiblePortal.ROTATE_MAX_SPEED_MULTIPLIER - InvisiblePortal.ROTATE_MIN_SPEED_MULTIPLIER
InvisiblePortal.ROTATE_RADIANS_PER_SECOND = math.pi / 16
InvisiblePortal.TRANSLATE_RADIANS_PER_SECOND = math.pi / 2
InvisiblePortal.TRANSLATE_OFFSET = Vector.UNIT_Y * 3 + Vector.UNIT_Z
InvisiblePortal.TRANSLATION_NORMAL = Vector.UNIT_Y / 2
InvisiblePortal.STATIC_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 4)

function InvisiblePortal:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/InvisiblePortal/Map.png",
		function(texture)
			self.texture = texture
			self.quad:getMaterial():setTextures(self.texture)
			self.quad:setParent(root)
		end)
end

function InvisiblePortal:updateRotation(delta)
	local scale
	do
		local playerPosition
		do
			local playerActor = self:getGameView():getGame():getPlayer():getActor()
			if not playerActor then
				return
			else
				playerPosition = playerActor:getPosition()
			end
		end

		local propSize, propPosition
		do
			local prop = self:getProp()
			propPosition = prop:getPosition()
			local min, max = prop:getBounds()
			propSize = (max - min):getLength()
		end

		local playerToPropDifference = playerPosition - propPosition
		local playerToPropDistance = playerToPropDifference:getLength()
		scale = 1 - math.min(math.max(playerToPropDistance - propSize, 0) / propSize, 1)
	end

	local mu = (scale * InvisiblePortal.ROTATE_SPEED_MULTIPLIER_WIDTH) + InvisiblePortal.ROTATE_MIN_SPEED_MULTIPLIER
	self.speedTime = (self.speedTime or 0) + mu * InvisiblePortal.ROTATE_RADIANS_PER_SECOND

	local angle = self.speedTime * InvisiblePortal.ROTATE_RADIANS_PER_SECOND
	self.quad:getTransform():setLocalRotation(
		Quaternion.fromAxisAngle(Vector.UNIT_Y, angle) * InvisiblePortal.STATIC_ROTATION)
end

function InvisiblePortal:updateTranslation(delta)
	self.translationTime = (self.translationTime or 0) + delta
	local angle = math.sin(self.translationTime * InvisiblePortal.TRANSLATE_RADIANS_PER_SECOND)
	self.quad:getTransform():setLocalTranslation(InvisiblePortal.TRANSLATION_NORMAL * angle + InvisiblePortal.TRANSLATE_OFFSET)
end

function InvisiblePortal:update(delta)
	PropView.update(self, delta)

	self:updateRotation(delta)
	self:updateTranslation(delta)
end

return InvisiblePortal
