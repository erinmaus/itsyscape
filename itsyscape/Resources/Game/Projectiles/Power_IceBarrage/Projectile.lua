--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/IceBarrage/Projectile.lua
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
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local IceBarrage = Class(Projectile)
IceBarrage.DURATION = 3
IceBarrage.ALPHA_MULTIPLIER = 1.75
IceBarrage.COLOR = Color(0.8, 0.7, 1.0)

function IceBarrage:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
	self.decoration:setParent(root)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Power_IceBarrage/Model.lstatic",
		function(model)
			local material = self.decoration:getMaterial()
			material:setTextures(self:getGameView():getWhiteTexture())
			material:setIsTranslucent(true)

			self.decoration:fromGroup(model:getResource(), "IceCube")
		end)
end

function IceBarrage:getDuration()
	return IceBarrage.DURATION
end

function IceBarrage:tick()
	if not self.position or not self.size then
		self.position = self:getTargetPosition(self:getDestination())

		local min, max = self:getDestination():getBounds()
		local x = max.x - min.z
		local z = max.z - min.z

		self.size = Vector(math.max(x, z))

		self.position.y = self.position.y - (max.y - min.y) / 2
	end
end

function IceBarrage:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position and self.size then
		local root = self:getRoot()
		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * IceBarrage.ALPHA_MULTIPLIER
		alpha = math.min(alpha, 1)

		root:getTransform():setLocalTranslation(self.position)
		root:getTransform():setLocalScale(self.scale)

		self.decoration:getMaterial():setColor(Color(
			IceBarrage.COLOR.r,
			IceBarrage.COLOR.g,
			IceBarrage.COLOR.b,
			alpha))
	end
end

return IceBarrage
