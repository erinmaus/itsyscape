--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/TheEmptyKingsExecutionerAxe/Projectile.lua
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
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Axe = Class(Projectile)
Axe.DURATION = 12 / 24 -- Frame 12 of a 24 FPS animation
Axe.OFFSET_POSITION = Vector(0, 1, -1.5)
Axe.OFFSET_ANGLE = -math.pi / 4

function Axe:attach()
	Projectile.attach(self)
end

function Axe:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:getTransform():setLocalScale(Vector(1.5, 3.5, 0))

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/TheEmptyKingsExecutionerAxe/Texture.png",
		function(texture)
			self.texture = texture
			self.quad:setParent(root)
			self.quad:getMaterial():setTextures(self.texture)
		end)
end

function Axe:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource())
	end
end

function Axe:getDuration()
	return Axe.DURATION
end

function Axe:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local gameView = self:getGameView()

		local handPosition
		do
			local actorView = gameView:getActor(self:getDestination())
			if actorView then
				local handTransform = actorView:getLocalBoneTransform("hand.r")
				handPosition = Vector(handTransform:transformPoint(0, 0, 0))
			else
				handPosition = Vector.ZERO
			end
		end

		local destinationPosition = self:getTargetPosition(self:getDestination()) + handPosition + Axe.OFFSET_POSITION
		local startPosition = self.spawnPosition

		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)

		local position = startPosition:lerp(destinationPosition, mu)
		local angle = mu * math.pi * 2 + Axe.OFFSET_ANGLE
		local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)
	end
end

return Axe
