--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Common/Grenade.lua
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
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Grenade = Class(Projectile)
Grenade.REVOLUTIONS = 2
Grenade.DURATION = 2.5
Grenade.DESPAWN_BOMB_TIME = 1
Grenade.CLAMP_BOTTOM = 1
Grenade.SPLOSION_ATTENUTATION = 10
Grenade.PARTICLE_SYSTEM = {
	numParticles = 100,
	texture = "Resources/Game/Projectiles/Common/Grenade.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 3, 4 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.4, 0.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.3 },
			fadeOutPercent = { 0.7 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 25, 50 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

function Grenade:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.grenade = DecorationSceneNode()

	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			self.grenade:fromGroup(mesh:getResource(), "Bomb")
			self.grenade:setParent(root)
		end)
	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.grenade:getMaterial():setTextures(texture)
			self.grenade:setParent(root)
		end)

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:initParticleSystemFromDef(Grenade.PARTICLE_SYSTEM, resources)

	self.light = PointLightSceneNode()
	self.light:setAttenuation(0)
	self.light:setColor(Color(1, 0.4, 0.0))
	self.light:setParent(self.particleSystem)

	self.spawnedSplosion = false
end

function Grenade:getModelFilename()
	return "Resources/Game/Projectiles/Common/Grenade.lstatic"
end

function Grenade:getDuration()
	return Grenade.DURATION
end

function Grenade:tick()
	if not self.sourcePosition or not self.destinationPosition then
		self.sourcePosition = self:getTargetPosition(self:getSource()) + Vector.UNIT_Y
		self.destinationPosition = self:getTargetPosition(self:getDestination())

		local rotation = Quaternion.lookAt(self.sourcePosition, self.destinationPosition)
		self.rotationDirection = rotation:transformVector(Vector.UNIT_Z)
	end
end

local function bezier3(a, b, c, delta)
	return (1 - delta) ^ 2 * a + (2 * (1 - delta)) * delta * b + delta ^ 2 * c
end

function Grenade:update(elapsed)
	Projectile.update(self, elapsed)

	local root = self:getRoot()

	if self.sourcePosition and self.destinationPosition then
		local delta = self:getTime() / Grenade.DESPAWN_BOMB_TIME
		if delta >= 1 and not self.spawnedSplosion then
			self.spawnedSplosion = true

			self.particleSystem:setParent(root)
		elseif delta < 1 then
			delta = Tween.sineEaseInOut(delta * 2)
			local position = bezier3(
				self.sourcePosition,
				Vector.PLANE_XZ * self.sourcePosition:lerp(self.destinationPosition, 0.5) + (Vector.UNIT_Y * math.max(self.sourcePosition.y, self.destinationPosition.y) + Vector.UNIT_Y * 10),
				self.destinationPosition,
				delta)

			local rotation = Quaternion.fromAxisAngle(self.rotationDirection, delta * math.pi * 2 * self.REVOLUTIONS)

			root:getTransform():setLocalTranslation(position)
			root:getTransform():setLocalRotation(rotation)
		else
			local delta = 1 - (self:getTime() - Grenade.DESPAWN_BOMB_TIME) / (Grenade.DURATION - Grenade.DESPAWN_BOMB_TIME)
			self.grenade:getMaterial():setColor(Color(1, 1, 1, delta))
			self.light:setAttenuation(math.abs(math.sin(delta * math.pi)) * Grenade.SPLOSION_ATTENUTATION)
		end
	end
end

return Grenade
