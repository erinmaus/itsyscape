--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MagmaJellyfishRock/Projectile.lua
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
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local Color = require "ItsyScape.Graphics.Color"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Rock = Class(Projectile)
Rock.DURATION = 0.6

function Rock:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/MagmaJellyfishRock/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function Rock:getDuration()
	return Rock.DURATION
end

function Rock:tick()
	if not self.spawnPosition or not self.fallPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource())
		self.fallPosition = self:getTargetPosition(self:getDestination())
	end
end

function Rock:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.powerEaseOut(delta, 4)
		local position = self.spawnPosition:lerp(self.fallPosition, mu)

		local alpha = 1.0
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local scale = Vector(0.5 + 1 * Tween.sineEaseOut(delta))

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setPreviousTransform(position)
		root:getTransform():setLocalScale(scale)
		root:getTransform():setPreviousTransform(nil, nil, scale)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))
	end
end

return Rock
