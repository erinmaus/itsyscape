--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Common/Cannonball.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Actor = require "ItsyScape.Game.Model.Actor"
local Prop = require "ItsyScape.Game.Model.Prop"
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Cannonball = Class(Projectile)
Cannonball.SPEED = 10

Cannonball.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/Common/Cannonball_Smoke.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.25 },
			yRange = { 0, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.5, 1.5 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.35, 0.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.3, 0.5 }
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
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 15 },
		delay = { 0.125 },
		duration = { 0.5 }
	}
}

function Cannonball:attach()
	Projectile.attach(self)

	self.duration = math.huge
end

function Cannonball:getTextureFilename()
	return Class.ABSTRACT()
end

function Cannonball:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Cannonball.PARTICLE_SYSTEM, resources)

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)
end

function Cannonball:getDuration()
	return self.duration
end

function Cannonball:tick()
	if not self.spawnPosition or not self.fallPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource(), Vector(0, 0, 1.5))
		self.fallPosition = self:getTargetPosition(self:getDestination())

		self.duration = math.min((self.spawnPosition - self.fallPosition):getLength() / self.SPEED, 1)
	end
end

function Cannonball:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.fallPosition then
		local root = self:getRoot()
		local delta = self:getDelta()
		local mu = Tween.powerEaseOut(delta, 4)
		local position = self.spawnPosition:lerp(self.fallPosition, mu)
		if delta > 0.5 then
			position.y = position.y * Tween.sineEaseOut(delta / 0.5)
		end

		self.particleSystem:getTransform():setLocalTranslation(self.spawnPosition)
		self.quad:getTransform():setLocalTranslation(position)
	end
end

return Cannonball
