--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/UnholySacrifice/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Blood = Class(Projectile)
Blood.MIN_DROPS = 1
Blood.MAX_DROPS = 3
Blood.MIN_DURATION = 1
Blood.MAX_DURATION = 1.25
Blood.MIN_SPEED = 1
Blood.MAX_SPEED = 2
Blood.MIN_SCALE = 2 / 16
Blood.MAX_SCALE = 4 / 16
Blood.OFFSET_X = 0.25
Blood.OFFSET_Y = 0.5
Blood.OFFSET_Z = 0.5
Blood.MAX_OFFSET_RADIUS = 0.125
Blood.MAX_LIGHT_RADIUS = 2
Blood.COLOR = Color(1, 0.2, 0.2, 1)

function Blood:attach()
	Projectile.attach(self)

	self.duration = math.random() * (self.MAX_DURATION - self.MIN_DURATION) + self.MIN_DURATION
end

function Blood:load()
	Projectile.load(self)

	local resources = self:getResources()

	self.drops = {}
	local numBlood = math.random(self.MIN_DROPS, self.MAX_DROPS)
	for i = 1, numBlood do
		local bubble = {
			x = math.random() * self.MAX_OFFSET_RADIUS + self.OFFSET_X,
			y = self.OFFSET_Y,
			z = self.OFFSET_Z,
			speed = math.random() * (self.MAX_SPEED - self.MIN_SPEED) + self.MIN_SPEED,
			offset = math.random(),
			node = QuadSceneNode(),
			light = PointLightSceneNode()
		}

		local scale = math.random() * (self.MAX_SCALE - self.MIN_SCALE) + self.MIN_SCALE
		bubble.node:getMaterial():setIsTranslucent(true)
		bubble.node:getMaterial():setIsFullLit(true)
		bubble.node:getMaterial():setIsZWriteDisabled(true)
		bubble.node:getTransform():setLocalScale(Vector.ONE * scale)

		bubble.light:setAttenuation(math.random() * self.MAX_LIGHT_RADIUS)
		bubble.light:setColor(self.COLOR)

		table.insert(self.drops, bubble)
	end

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/UnholySacrifice/Texture.png",
		function(texture)
			for i = 1, #self.drops do
				self.drops[i].node:getMaterial():setTextures(texture)
			end
		end)
end

function Blood:getDuration()
	return self.duration
end

function Blood:tick()
	if not self.spawnPosition then
		local source = self:getTargetPosition(self:getSource())
		self.spawnPosition = source

		for i = 1, #self.drops do
			self.drops[i].node:setParent(self:getRoot())
			self.drops[i].light:setParent(self.drops[i].node)
		end
	end
end

function Blood:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		for i = 1, #self.drops do
			local bubble = self.drops[i]

			local x = bubble.x
			local y = bubble.y - bubble.speed * self:getTime()
			local z = bubble.z
			local position = Vector(x, y, z)
			bubble.node:getTransform():setLocalTranslation(position)
			bubble.node:getTransform():setPreviousTransform(position)
	
			local alpha = Tween.sineEaseOut(1 - self:getDelta())
			bubble.node:getMaterial():setColor(Color(1, 1, 1, alpha))
		end

		self:getRoot():getTransform():setLocalTranslation(self.spawnPosition)
		self:getRoot():getTransform():setPreviousTransform(self.spawnPosition)
	end
end

return Blood
