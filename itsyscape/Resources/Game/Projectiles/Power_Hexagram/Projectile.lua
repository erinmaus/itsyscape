--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Hexagram/Projectile.lua
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
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local Color = require "ItsyScape.Graphics.Color"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Hexagram = Class(Projectile)
Hexagram.DURATION = 60
Hexagram.IN_TIME = 1
Hexagram.OUT_TIME = 59
Hexagram.FADE_DURATION = 1

function Hexagram:attach()
	Projectile.attach(self)

	self.duration = self.DURATION
end

function Hexagram:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/Power_Curse/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function Hexagram:getDuration()
	return self.duration
end

function Hexagram:tick()
	if not self.position then
		self.position = self:getTargetPosition(self:getDestination())
	end
end

function Hexagram:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position then
		local root = self:getRoot()
		local time = self:getTime()
		local position = self.position

		local delta
		if time < Hexagram.IN_TIME then
			delta = time / Hexagram.FADE_DURATION
		elseif time > Hexagram.OUT_TIME then
			delta = (time - Hexagram.OUT_TIME) / Hexagram.FADE_DURATION
			delta = 1 - delta
		else
			delta = 1
		end

		local alpha = Tween.sineEaseOut(delta)

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, delta * math.pi * 4)
		local rotation = yRotation * xRotation

		local scale
		do
			local min, max = self:getDestination():getBounds()
			local size = max - min
			scale = Vector(math.max(size.x, size.z)) * 2
			position = position - Vector(0, size.y / 2 - 0.25, 0)
		end

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)
		root:getTransform():setLocalScale(scale)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))

		self.light:setColor(Color(1, 0, 0, 1))
		self.light:setAttenuation(12)
		self.light:getTransform():setLocalTranslation(Vector.UNIT_Y)
	end
end

return Hexagram
