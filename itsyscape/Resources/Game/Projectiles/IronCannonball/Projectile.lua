--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/IronCannonball/Projectile.lua
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

local IronCannonball = Class(Projectile)
IronCannonball.SPEED = 10

function IronCannonball:attach()
	Projectile.attach(self)

	self.spawnPosition = Projectile.getTargetPosition(self:getSource())
	self.fallPosition = Projectile.getTargetPosition(self:getDestination())
	self.duration = (self.spawnPosition - self.fallPosition):getLength() / IronCannonball.SPEED
end

function IronCannonball:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.cube = (require "ItsyScape.Graphics.DebugCubeSceneNode")()
	--self.cube:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/IronCannonball/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function IronCannonball:getDuration()
	return self.duration
end

function IronCannonball:update(delta)
	Projectile.update(self, delta)

	local root = self:getRoot()

	local delta = self:getDelta()
	local mu = Tween.powerEaseOut(delta, 4)
	local position = self.spawnPosition:lerp(self.fallPosition, mu)
	if delta > 0.5 then
		position.y = position.y * Tween.sineEaseOut(delta / 0.5)
	end

	root:getTransform():setLocalTranslation(position)
	root:getTransform():setPreviousTransform(position)
end

return IronCannonball
