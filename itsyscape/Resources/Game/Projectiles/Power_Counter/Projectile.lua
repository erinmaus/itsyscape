--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Counter/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Counter = Class(Projectile)
Counter.DURATION = 1.25
Counter.START_OFFSET_POSITION = Vector(0, 8, 0)
Counter.STOP_OFFSET_POSITION = Vector(0, -8, 0)

function Counter:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:getTransform():setLocalScale(Vector(2, 2, 1))

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/Power_Counter/Texture.png",
		function(texture)
			self.texture = texture
			self.quad:setParent(root)
			self.quad:getMaterial():setTextures(self.texture)
		end)
end

function Counter:tick()
	if not self.destinationPosition then
		self.destinationPosition = self:getTargetPosition(self:getDestination())

		local root = self:getRoot()
		root:getTransform():setPreviousTransform(self.destinationPosition + Counter.START_OFFSET_POSITION)
	end
end

function Counter:getDuration()
	return Counter.DURATION
end

function Counter:update(elapsed)
	Projectile.update(self, elapsed)

	if self.destinationPosition then
		local gameView = self:getGameView()

		local alpha = self:getDelta()

		local startPosition = self.destinationPosition + Counter.START_OFFSET_POSITION
		local stopPosition = self.destinationPosition + Counter.STOP_OFFSET_POSITION
		local position = startPosition:lerp(stopPosition, alpha)

		local root = self:getRoot()
		root:getTransform():setLocalTranslation(position)

		self.quad:getMaterial():setColor(Color(1, 1, 1, 1 - alpha))
	end
end

return Counter
