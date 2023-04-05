--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Psychic/Projectile.lua
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

local Psychic = Class(Projectile)
Psychic.SPEED = 6
Psychic.LIGHT_COLOR = Color.fromHexString("FFAACC")

function Psychic:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function Psychic:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quads = {}
	for i = 1, 3 do
		local quad = QuadSceneNode()
		quad:setParent(root)
		quad:setIsBillboarded(false)
		quad:getTransform():setLocalScale(Vector(2, 4, 1))

		local x = (math.random() - 0.5) * 2
		local y = (math.random() - 0.5) * 2
		local z = (math.random() - 0.5) * 2
		quad:getTransform():setLocalTranslation(Vector(x, y, z))
		quad:getTransform():setLocalScale(Vector(0.5, 0.5, 0.5))

		table.insert(self.quads, quad)
	end

	self.light = PointLightSceneNode()
	self.light:setColor(Psychic.LIGHT_COLOR)
	self.light:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/Psychic/Texture.png",
		function(texture)
			for i = 1, #self.quads do
				self.quads[i]:getMaterial():setTextures(texture)
			end
		end)
end

function Psychic:getDuration()
	return self.duration
end

function Psychic:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function Psychic:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.hitPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(self.hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi / 2)
		local lookRotation = Quaternion.lookAt(self.spawnPosition, self.hitPosition)
		local rotation = lookRotation * yRotation * xRotation

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)

		for i = 1, #self.quads do
			self.quads[i]:getMaterial():setColor(Color(1, 1, 1, alpha))
		end

		self.light:setAttenuation(alpha * 8 + 4)
	end
end

return Psychic
