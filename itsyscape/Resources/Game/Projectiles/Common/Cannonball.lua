--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Common/CannonBall.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Cannonball = Class(Projectile)
Cannonball.SPEED = 10

function Cannonball:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function Cannonball:getTextureFilename()
	return Class.ABSTRACT()
end

function Cannonball:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function Cannonball:getDuration()
	return self.duration
end

function Cannonball:tick()
	if not self.spawnPosition or not self.fallPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource())
		self.fallPosition = self:getTargetPosition(self:getDestination())

		self.duration = (self.spawnPosition - self.fallPosition):getLength() / self.SPEED
	end
end

function Cannonball:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.fallPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.powerEaseOut(delta, 4)
		local position = self.spawnPosition:lerp(self.fallPosition, mu)
		if delta > 0.5 then
			position.y = position.y * Tween.sineEaseOut(delta / 0.5)
		end

		root:getTransform():setLocalTranslation(position)
	end
end

return Cannonball
