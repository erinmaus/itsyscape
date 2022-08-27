--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/AirStrike/Projectile.lua
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

local AirStrike = Class(Projectile)
AirStrike.SPEED = 5

function AirStrike:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function AirStrike:getTextureFilename()
	return Class.ABSTRACT()
end

function AirStrike:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	self.quad:getTransform():setLocalScale(Vector(0.5, 0.5, 0.5))

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/AirStrike/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function AirStrike:getDuration()
	return self.duration
end

function AirStrike:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function AirStrike:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(self.hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, math.pi / 4)
		local zRotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, self:getTime() * math.pi * 4)
		local rotation = xRotation * zRotation

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))

		self.light:setAttenuation(alpha * 2 + 2)
	end
end

return AirStrike
