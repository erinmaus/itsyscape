--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/EarthStrike/Projectile.lua
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

local EarthStrike = Class(Projectile)
EarthStrike.SPEED = 5

function EarthStrike:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function EarthStrike:getTextureFilename()
	return Class.ABSTRACT()
end

function EarthStrike:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(Color(0.67, 0.78, 0.21))

	self.quad:getTransform():setLocalScale(Vector(0.5, 1.0, 0.5))

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/EarthStrike/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function EarthStrike:getDuration()
	return self.duration
end

function EarthStrike:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function EarthStrike:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(self.hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local lookRotation = Quaternion.lookAt(self.spawnPosition, hitPosition)
		local rotation = lookRotation * xRotation

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))

		self.light:setAttenuation((1 - alpha) * 3 + 2)
	end
end

return EarthStrike
