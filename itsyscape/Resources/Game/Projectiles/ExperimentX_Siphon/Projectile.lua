--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/ExperimentX_Siphon/Projectile.lua
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
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Siphon = Class(Projectile)
Siphon.MAX_ATTENUATION = 12

Siphon.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/ExperimentX_Siphon/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.25 },
			speed = { 0.75, 1.5 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.8, 0.2, 0.2, 0.0 },
				{ 1.0, 0.2, 0.2, 0.0 },
				{ 0.5, 0.1, 0.1, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.6, 1.2 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.4, 0.6 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 30, 60 },
			acceleration = { -40, -20 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 6, 12 },
		delay = { 1 / 32 },
		duration = { math.huge }
	}
}

Siphon.SPEED = 2

function Siphon:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function Siphon:_loadAdventurer(boneName)
	local resources = self:getResources()
	local root = self:getRoot()

	local particleSystem = ParticleSceneNode()
	particleSystem:setParent(root)
	particleSystem:initParticleSystemFromDef(Siphon.PARTICLE_SYSTEM, resources)

	local light = PointLightSceneNode()
	light:setParent(root)
	light:setColor(Color(1.0, 0.2, 0.2))
	light:setAttenuation(Siphon.MAX_ATTENUATION)

	self.adventurers[boneName] = {
		boneName = boneName,
		particleSystem = particleSystem,
		light = light
	}
end

function Siphon:load()
	Projectile.load(self)

	self.adventurers = {}
	self:_loadAdventurer("wizard.body")
	self:_loadAdventurer("archer.body")
	self:_loadAdventurer("warrior.body")
end

function Siphon:getDuration()
	return self.duration
end

function Siphon:tick()
	local gameView = self:getGameView()
	local source = self:getSource()
	local sourceView = gameView:getActor(source)

	local isPending = false

	for _, adventurer in pairs(self.adventurers) do
		if not adventurer.spawnPosition then
			adventurer.spawnPosition = sourceView:getBoneWorldPosition(adventurer.boneName)
			isPending = true
		end
	end

	if isPending then
		local spawnPosition = self:getTargetPosition(self:getSource())
		local hitPosition = self:getTargetPosition(self:getDestination())

		self.duration = math.max((spawnPosition - hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function Siphon:update(elapsed)
	Projectile.update(self, elapsed)

	if self.duration then
		local hitPosition = self:getTargetPosition(self:getDestination())

		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.sineEaseOut(delta)

		local alpha = 1
		if delta > 0.5 then
			alpha = 1 - (delta - 0.5) / 0.5
		end

		for _, adventurer in pairs(self.adventurers) do
			if adventurer.spawnPosition then
				local position = adventurer.spawnPosition:lerp(hitPosition, mu)

				local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)
				local lookRotation = Quaternion.lookAt(adventurer.spawnPosition, hitPosition)
				local rotation = xRotation * lookRotation

				adventurer.light:getTransform():setLocalTranslation(position)
				adventurer.light:setAttenuation((1 - alpha) * Siphon.MAX_ATTENUATION)

				adventurer.particleSystem:getTransform():setLocalRotation(rotation)
				adventurer.particleSystem:getTransform():setLocalOffset(position)
				adventurer.particleSystem:getMaterial():setColor(Color(1, 1, 1, alpha))
				adventurer.particleSystem:updateLocalPosition(position)
			end
		end
	end
end

return Siphon
