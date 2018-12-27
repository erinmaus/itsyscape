--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Common/Boomerang.lua
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
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Boomerang = Class(Projectile)
Boomerang.SPEED = 5

function Boomerang:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function Boomerang:getTextureFilename()
	return Class.ABSTRACT()
end

function Boomerang:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.quad:getTransform():setLocalScale(Vector(0.5, 0.25, 0.25))

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function Boomerang:getDuration()
	return self.duration
end

function Boomerang:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)

		self.duration = (self.spawnPosition - self.hitPosition):getLength() / self.SPEED
	end
end

function Boomerang:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = (math.sin(delta * math.pi * 2 + math.pi) + 1) / 2
		local position = self.spawnPosition:lerp(self.hitPosition, mu)

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, math.pi / 4)
		local zRotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, self:getTime() * math.pi * 4)
		local rotation = xRotation * zRotation

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)
		root:getTransform():setPreviousTransform(position, rotation, nil)
	end
end

return Boomerang
