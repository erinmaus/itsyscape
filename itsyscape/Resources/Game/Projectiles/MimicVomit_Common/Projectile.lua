--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MimicVomit_Common/Projectile.lua
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
local Projectile = require "ItsyScape.Graphics.Projectile"
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local MimicVomitCommon = Class(Projectile)

MimicVomitCommon.SPEED = 5
MimicVomitCommon.LIGHT_COLOR = Color.fromHexString("FFFFFF")

function MimicVomitCommon:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function MimicVomitCommon:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(self.PARTICLE_SYSTEM, resources)

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(self.LIGHT_COLOR)
end

function MimicVomitCommon:getDuration()
	return self.duration
end

function MimicVomitCommon:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Vector(0, 1, 0)

		self.hitPosition = self:getTargetPosition(self:getDestination()) + Vector(0, 1, 0)
		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function MimicVomitCommon:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)
		local position = self.spawnPosition:lerp(self.hitPosition, mu)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		local rotation = Quaternion.lookAt(self.spawnPosition, self.hitPosition)

		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
		local lookRotation = Quaternion.lookAt(self.spawnPosition, self.hitPosition)
		local rotation = lookRotation * xRotation

		self.particleSystem:getTransform():setLocalOffset(position)
		self.particleSystem:getTransform():setLocalRotation(rotation)
		self.particleSystem:updateLocalPosition(position)

		self.particleSystem:getMaterial():setColor(Color(1, 1, 1, alpha))
		self.light:setAttenuation((1 - alpha) * 3 + 2)
	end
end

return MimicVomitCommon
