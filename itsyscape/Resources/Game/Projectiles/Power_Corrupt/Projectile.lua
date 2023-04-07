--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Corrupt/Projectile.lua
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

local Power_Corrupt = Class(Projectile)
Power_Corrupt.SPEED = 6

function Power_Corrupt:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function Power_Corrupt:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quads = {}
	for i = 1, 3 do
		local quad = QuadSceneNode()
		quad:setParent(root)
		quad:setIsBillboarded(false)
		quad:getTransform():setLocalScale(Vector(0.5, 1.0, 0.5))

		local x = (math.random() - 0.5) * 2
		local y = (math.random() - 0.5) * 2
		local z = (math.random() - 0.5) * 2
		quad:getTransform():setLocalTranslation(Vector(x, y, z))
		quad:getTransform():setLocalScale(Vector(0.5, 0.5, 0.5))

		table.insert(self.quads, quad)
	end

	self.light = PointLightSceneNode()
	self.light:setColor(Color(0.67, 0.21, 0.78, 1))
	self.light:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/Power_Corrupt/Texture.png",
		function(texture)
			for i = 1, #self.quads do
				self.quads[i]:getMaterial():setTextures(texture)
			end
		end)
end

function Power_Corrupt:getDuration()
	return self.duration
end

function Power_Corrupt:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function Power_Corrupt:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local lookRotation = Quaternion.lookAt(self.spawnPosition, hitPosition)
		local rotation = lookRotation * xRotation

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)

		for i = 1, #self.quads do
			self.quads[i]:getMaterial():setColor(Color(1, 1, 1, alpha))
		end

		self.light:setAttenuation(alpha * 4 + 2)
	end
end

return Power_Corrupt
