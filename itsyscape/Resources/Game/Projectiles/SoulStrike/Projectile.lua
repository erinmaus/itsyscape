--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/SoulStrike/Projectile.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local SoulStrike = Class(Projectile)
SoulStrike.SPEED = 2
SoulStrike.SCALE = Vector.ONE / 4
SoulStrike.WAVE = 1
SoulStrike.COLOR = Color.fromHexString("fad4e5")

function SoulStrike:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function SoulStrike:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
	self.decoration:setParent(root)

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/SoulStrike/Model.lstatic",
		function(model)
			local material = self.decoration:getMaterial()
			material:setTextures(self:getGameView():getWhiteTexture())
			material:setIsTranslucent(true)

			self.decoration:fromGroup(model:getResource(), "SoulStrike")
		end)
end

function SoulStrike:getDuration()
	return self.duration
end

function SoulStrike:tick()
	if not self.spawnPosition or not self.hitPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function SoulStrike:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(self.hitPosition, mu)
		local yOffset = math.sin(self:getTime() * math.pi) * SoulStrike.WAVE
		local zOffset = math.cos(self:getTime() * math.pi) * SoulStrike.WAVE
		local offset = Vector(0, yOffset, zOffset)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		position = position + offset

		local angle = math.cos(self:getTime() * math.pi) * math.pi / 2
		local rotation1 = Quaternion.lookAt(self.hitPosition, self.spawnPosition)
		local rotation2 = Quaternion.fromAxisAngle(Vector.UNIT_X, angle)
		local rotation = rotation2 * rotation1

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)
		root:getTransform():setLocalScale(SoulStrike.SCALE)

		self.decoration:getMaterial():setColor(Color(
			SoulStrike.COLOR.r,
			SoulStrike.COLOR.g,
			SoulStrike.COLOR.b,
			alpha))

		self.light:setAttenuation(alpha * 2 + 2)
	end
end

return SoulStrike
