--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Confuse/Projectile.lua
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

local Confuse = Class(Projectile)
Confuse.DURATION = 2

function Confuse:attach()
	Projectile.attach(self)

	self.duration = self.DURATION
end

function Confuse:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/Power_Confuse/Texture.png",
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function Confuse:getDuration()
	return self.duration
end

function Confuse:tick()
	self.position = self:getTargetPosition(self:getDestination())
end

function Confuse:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.position

		local alpha = math.abs(math.sin(math.pi * delta))
		local angle = math.sin(math.pi * 2 * delta) * math.pi / 4

		local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)

		local height
		do
			local min, max = self:getDestination():getBounds()
			local size = max - min
			height = size.y
		end

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)

		self.quad:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.quad:getTransform():setLocalTranslation(Vector.UNIT_Y * height)

		self.light:setColor(Color(1, 1, 0, 1))
		self.light:setAttenuation(alpha * 2 + 2)
	end
end

return Confuse
