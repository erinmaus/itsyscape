--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/SaberToothShrimpSmoke/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Smoke = Class(Projectile)

Smoke.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/SaberToothShrimpSmoke/Smoke.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.125 },
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
			lifetime = { 1.0, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.4, 0.5 }
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
		count = { 5, 10 },
		delay = { 0.125 },
		duration = { math.huge }
	}
}
Smoke.DURATION = 1.5

function Smoke:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystemNode = ParticleSceneNode()
	self.particleSystemNode:setParent(root)
	self.particleSystemNode:initParticleSystemFromDef(Smoke.PARTICLE_SYSTEM, resources)

	self.isAlive = true
end

function Smoke:getDuration()
	if self:isMaybeShrimp() then
		return math.huge
	else	
		return Smoke.DURATION
	end
end

function Smoke:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function Smoke:isMaybeShrimp()
	local destination = self:getDestination()
	return Class.isCompatibleType(destination, Actor)
end

function Smoke:isDestinationStillValid()
	if self.destinationID then
		return self:getGameView():getActorByID(self.destinationID) ~= nil
	end

	return false
end

function Smoke:isMaybeShrimpAlive()
	if self:isMaybeShrimp() and self:isDestinationStillValid() then
		local health = self:getDestination():getCurrentHitpoints()
		return health >= 1
	end

	return true
end

function Smoke:attach()
	Projectile.attach(self)

	if self:isMaybeShrimp() then
		local destination = self:getDestination()
		self.destinationID = destination:getID()
	end
end

function Smoke:update(elapsed)
	Projectile.update(self, elapsed)

	local headPosition
	do
		local gameView = self:getGameView()
		local actor = self:getDestination()
		local actorView = gameView:getActor(actor)
		if actorView then
			local headTransform = actorView:getLocalBoneTransform("head")
			local transform = love.math.newTransform()
			transform:scale(2, 2, 2)
			transform:apply(headTransform)

			headPosition = Vector(transform:transformPoint(0, 0, 0))

			self.particleSystemNode:setParent(actorView:getSceneNode())
		else
			headPosition = Vector.ZERO
		end
	end

	if self.particleSystemNode:getIsReady() then
		self.particleSystemNode:updateLocalPosition(headPosition)
	end

	self:ready()
end

function Smoke:tick()
	Projectile.tick(self)

	if self:isMaybeShrimp() then
		if not self:isMaybeShrimpAlive() and self.isAlive then
			self:resetTime()

			self.isAlive = false
		end
	end

	if not self.isAlive then
		self.particleSystemNode:initEmissionStrategyFromDef({})
	end
end

return Smoke
