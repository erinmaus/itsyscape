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
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local Color = require "ItsyScape.Graphics.Color"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local UndeadSquidInk = Class(Projectile)
UndeadSquidInk.SPEED = 15

function UndeadSquidInk:attach()
	Projectile.attach(self)

	self.duration = math.huge
	self.inked = false
end

function UndeadSquidInk:getTextureFilename()
	return Class.ABSTRACT()
end

function UndeadSquidInk:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/UndeadSquidInk/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function UndeadSquidInk:getDuration()
	return self.duration
end

function UndeadSquidInk:tick()
	if not self.spawnPosition or not self.fallPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource())
		self.fallPosition = self:getTargetPosition(self:getDestination())

		self.duration = (self.spawnPosition - self.fallPosition):getLength() / self.SPEED
	end
end

function UndeadSquidInk:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local fallPosition = self:getTargetPosition(self:getDestination())
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.powerEaseOut(delta, 4)
		local position = self.spawnPosition:lerp(self.fallPosition, mu)

		local alpha = 1.0
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5

			if not self.inked then
				local target = self:getDestination()
				if target:isCompatibleType(Actor) then
					local animation = CacheRef(
						"ItsyScape.Graphics.AnimationResource",
						"Resources/Game/Animations/UndeadSquid_Target_Inking/Script.lua")

					target:onAnimationPlayed('x-undead-squid', 1, animation)
					self.inked = true
				end
			end
		end

		local scale = Vector(0.5 + 1 * Tween.sineEaseOut(delta))

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setPreviousTransform(position)
		root:getTransform():setLocalScale(scale)
		root:getTransform():setPreviousTransform(nil, nil, scale)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))
	end
end

return UndeadSquidInk
