--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/HexLab_VatBubbles/Projectile.lua
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

local Bubbles = Class(Projectile)
Bubbles.MIN_BUBBLES = 1
Bubbles.MAX_BUBBLES = 3
Bubbles.MIN_DURATION = 1
Bubbles.MAX_DURATION = 1.5
Bubbles.MIN_SPEED = 0.5
Bubbles.MAX_SPEED = 1
Bubbles.MIN_SCALE = 2 / 16
Bubbles.MAX_SCALE = 4 / 16
Bubbles.MAX_OFFSET_RADIUS = 0.25
Bubbles.MAX_LIGHT_RADIUS = 2
Bubbles.COLOR = Color(55 / 255, 200 / 255, 113 / 255, 1)
Bubbles.WIBBLE_WOBBLE_MULTIPLIER = math.pi * 4
Bubbles.WIBBLE_WOBBLE_WIDTH = 0.25

function Bubbles:attach()
	Projectile.attach(self)

	self.duration = math.random() * (self.MAX_DURATION - self.MIN_DURATION) + self.MIN_DURATION
end

function Bubbles:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.bubbles = {}
	local numBubbles = math.random(self.MIN_BUBBLES, self.MAX_BUBBLES)
	for i = 1, numBubbles do
		local bubble = {
			x = ((math.random() * 2) - 1) * self.MAX_OFFSET_RADIUS,
			y = ((math.random() * 2) - 1) * self.MAX_OFFSET_RADIUS,
			speed = math.random() * (self.MAX_SPEED - self.MIN_SPEED) + self.MIN_SPEED,
			offset = math.random(),
			node = QuadSceneNode(),
			light = PointLightSceneNode()
		}

		local scale = math.random() * (self.MAX_SCALE - self.MIN_SCALE) + self.MIN_SCALE
		bubble.node:setParent(root)
		bubble.node:getMaterial():setIsTranslucent(true)
		bubble.node:getMaterial():setIsFullLit(true)
		bubble.node:getMaterial():setIsZWriteDisabled(true)
		bubble.node:getTransform():setLocalScale(Vector.ONE * scale)

		bubble.light:setParent(bubble.node)
		bubble.light:setAttenuation(math.random() * self.MAX_LIGHT_RADIUS)
		bubble.light:setColor(self.COLOR)

		table.insert(self.bubbles, bubble)
	end

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/HexLab_VatBubbles/Texture.png",
		function(texture)
			for i = 1, #self.bubbles do
				self.bubbles[i].node:getMaterial():setTextures(texture)
			end
		end)
end

function Bubbles:getDuration()
	return self.duration
end

function Bubbles:tick()
	if not self.spawnPosition then
		local source = self:getTargetPosition(self:getSource())
		local offset = self:getTargetPosition(self:getDestination())
		self.spawnPosition = source + offset
	end
end

function Bubbles:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		for i = 1, #self.bubbles do
			local bubble = self.bubbles[i]
			local offset = math.sin((self:getTime() + bubble.offset) * self.WIBBLE_WOBBLE_MULTIPLIER)

			local x = bubble.x + offset * self.WIBBLE_WOBBLE_WIDTH
			local y = bubble.y + bubble.speed * self:getTime()
			local position = Vector(x, y, 0)
			bubble.node:getTransform():setLocalTranslation(position)
			bubble.node:getTransform():setPreviousTransform(position)
	
			local alpha = Tween.sineEaseOut(1 - self:getDelta())
			bubble.node:getMaterial():setColor(Color(1, 1, 1, alpha))
		end

		self:getRoot():getTransform():setLocalTranslation(self.spawnPosition)
	end
end

return Bubbles
