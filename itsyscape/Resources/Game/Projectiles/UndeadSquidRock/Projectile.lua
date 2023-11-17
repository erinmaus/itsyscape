--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/UndeadSquidRock/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local UndeadSquidRock = Class(Projectile)

UndeadSquidRock.DROP_OFF  = 10
UndeadSquidRock.ELEVATION = 10

UndeadSquidRock.DURATION = 2.5

UndeadSquidRock.PARTICLE_SYSTEM = {
	numParticles = 100,
	texture = "Resources/Game/Projectiles/UndeadSquidRock/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 5, 6 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.75, 1.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.75 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -180, 180 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.9 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 15 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

function UndeadSquidRock:getTextureFilename()
	return "Resources/Game/Projectiles/UndeadSquidRock/Texture.png"
end

function UndeadSquidRock:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)
	self.quad:getTransform():setLocalScale(Vector.ONE * 1.25)

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(UndeadSquidRock.PARTICLE_SYSTEM, resources)
	self.particleSystem:pause()
end

function UndeadSquidRock:getDuration()
	return self.DURATION
end

function UndeadSquidRock:tick()
	Projectile.tick(self)

	if not self.isReady then
		self.startPosition = self:getTargetPosition(self:getSource())
		self.hitPosition = self:getTargetPosition(self:getDestination())
		self.yCurve = love.math.newBezierCurve(
			self.startPosition.y, 0,
			math.max(self.startPosition.y + UndeadSquidRock.ELEVATION, self.hitPosition.y + UndeadSquidRock.ELEVATION), 0,
			self.hitPosition.y - UndeadSquidRock.DROP_OFF, 0)

		self.particleSystem:getTransform():setLocalTranslation(self.hitPosition)
		self.isReady = true
	end
end

function UndeadSquidRock:update(delta)
	Projectile.update(self, delta)

	if not self.isReady then
		return
	end

	local delta = self:getDelta()
	local position = self.startPosition:lerp(self.hitPosition, delta)
	position.y = self.yCurve:evaluate(delta)

	if delta > 0.5 and position.y <= self.hitPosition.y + 1 then
		self.particleSystem:play()
	end

	local angle = self:getTime() * math.pi * 2
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
	self.quad:getTransform():setLocalRotation(rotation)
	self.quad:getTransform():setLocalTranslation(position)
end

return UndeadSquidRock
