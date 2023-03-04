--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Earthquake/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Earthquake = Class(Projectile)
Earthquake.DURATION = 3
Earthquake.ALPHA_MULTIPLIER = 2.25
Earthquake.COLOR = Color(1)
Earthquake.POSITION_OFFSET = Vector(0, 2, -1)

function Earthquake:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
	self.decoration:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Projectiles/Power_Earthquake/Texture.png",
		function(texture)
			self.texture = texture
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Power_Earthquake/Model.lstatic",
		function(model)
			local material = self.decoration:getMaterial()
			material:setTextures(self.texture)
			material:setIsTranslucent(true)

			self.decoration:fromGroup(model:getResource(), "Rock")
		end)
end

function Earthquake:getDuration()
	return Earthquake.DURATION
end

function Earthquake:tick()
	if not self.destinationPosition or not self.sourcePosition or not self.size then
		self.destinationPosition = self:getTargetPosition(self:getDestination())
		self.sourcePosition = self:getTargetPosition(self:getSource())

		local min, max = self:getDestination():getBounds()
		local x = max.x - min.z
		local z = max.z - min.z

		self.size = Vector(math.max(x, z)) * 3

		self.destinationPosition.y = self.destinationPosition.y - (max.y - min.y) / 2
		self.destinationPosition = self.sourcePosition:lerp(self.destinationPosition, 0.5)
	end
end

function Earthquake:update(elapsed)
	Projectile.update(self, elapsed)

	if self.destinationPosition and self.sourcePosition and self.size then
		local root = self:getRoot()
		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * Earthquake.ALPHA_MULTIPLIER
		alpha = math.min(alpha, 1)

		local rotation = Quaternion.lookAt(
			self.sourcePosition * Vector.PLANE_XZ,
			self.destinationPosition * Vector.PLANE_XZ)
		local offset = rotation:transformVector(Earthquake.POSITION_OFFSET)

		root:getTransform():setLocalTranslation(self.destinationPosition - (1 - alpha) * offset)
		root:getTransform():setLocalScale(self.scale)
		root:getTransform():setLocalRotation(rotation)

		self.decoration:getMaterial():setColor(Color(
			Earthquake.COLOR.r,
			Earthquake.COLOR.g,
			Earthquake.COLOR.b,
			alpha))
	end
end

return Earthquake
