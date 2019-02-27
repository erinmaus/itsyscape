--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Curse/Projectile.lua
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

local Curse = Class(Projectile)
Curse.DURATION = 2

function Curse:attach()
	Projectile.attach(self)

	self.duration = self.DURATION
end

function Curse:load()
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

function Curse:getDuration()
	return self.duration
end

function Curse:tick()
	self.position = self:getTargetPosition(self:getDestination())
end

function Curse:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.position

		local alpha = math.abs(math.sin(math.pi * delta))

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, delta * math.pi * 4)
		local rotation = yRotation * xRotation

		local scale
		do
			local min, max = self:getDestination():getBounds()
			local size = max - min
			scale = Vector(math.max(size.x, size.z))
			position = position + Vector(0, size.y / 2, 0)
		end

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)
		root:getTransform():setLocalScale(scale)
		root:getTransform():setPreviousTransform(position, rotation, scale)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))

		self.light:setColor(Color(1, 0, 0, 1))
		self.light:setAttenuation(alpha * 4 + 4)
	end
end

return Curse
