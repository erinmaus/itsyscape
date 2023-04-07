--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Icicle/Projectile.lua
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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Icicle = Class(Projectile)
Icicle.DURATION = 1
Icicle.ALPHA_MULTIPLIER = 1.25

Icicle.TARGET_Y = -6
Icicle.START_Y  = 6

Icicle.INSIDE_COLOR  = Color(0.8, 0.7, 1.0)
Icicle.OUTLINE_COLOR = Color(0.0)

function Icicle:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
	self.decoration:setParent(root)

	self.outline = DecorationSceneNode()
	self.outline:setParent(root)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Icicle/Model.lstatic",
		function(model)
			local material = self.decoration:getMaterial()
			material:setTextures(self:getGameView():getWhiteTexture())
			material:setIsTranslucent(true)

			self.decoration:fromGroup(model:getResource(), "Icicle")

			material = self.outline:getMaterial()
			material:setTextures(self:getGameView():getWhiteTexture())
			material:setIsTranslucent(true)

			self.outline:fromGroup(model:getResource(), "Outline")
		end)
end

function Icicle:getDuration()
	return Icicle.DURATION
end

function Icicle:tick()
	if not self.startPosition or not self.size then
		self.startPosition = self:getTargetPosition(self:getDestination())

		local min, max = self:getDestination():getBounds()
		local x = max.x - min.x
		local z = max.z - min.z
		local y = max.y - min.y

		self.size = Vector(math.max(x, y, z)) / 4

		self.startPosition = self.startPosition + Vector.UNIT_Y * (y / 2 + Icicle.START_Y * self.size)
		self.targetPosition = self.startPosition - Vector.UNIT_Y * (y / 2 - Icicle.TARGET_Y * self.size)

		local root = self:getRoot()
		root:getTransform():setPreviousTransform(self.startPosition, Quaternion.Z_90, self.size)
	end
end

function Icicle:update(elapsed)
	Projectile.update(self, elapsed)

	if self.startPosition and self.size and self.outline and self.outline then
		local root = self:getRoot()
		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * Icicle.ALPHA_MULTIPLIER
		alpha = math.min(alpha, 1)

		local position = self.startPosition:lerp(self.targetPosition, Tween.sineEaseOut(delta))

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalScale(self.size)
		root:getTransform():setLocalRotation(Quaternion.Z_90)

		self.decoration:getMaterial():setColor(Color(
			Icicle.INSIDE_COLOR.r,
			Icicle.INSIDE_COLOR.g,
			Icicle.INSIDE_COLOR.b,
			alpha))

		self.outline:getMaterial():setColor(Color(
			Icicle.OUTLINE_COLOR.r,
			Icicle.OUTLINE_COLOR.g,
			Icicle.OUTLINE_COLOR.b,
			alpha))
	end
end

return Icicle
