--------------------------------------------------------------------------------
-- Resources/Peeps/Props/DragonFireball.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PendingStrategyGradeBehavior = require "ItsyScape.Peep.Behaviors.PendingStrategyGradeBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local DragonFireball = Class(PassableProp)

DragonFireball.DEFAULT_MOUTH_POSITION = Vector(0, 6, 14)

DragonFireball.DEFAULT_EXPLOSION_RADIUS = 6
DragonFireball.DEFAULT_KNOCKBACK = 8

DragonFireball.DEFAULT_ACCELERATION_MAGNITUDE = 8
DragonFireball.DEFAULT_VELOCITY_MAGNITUDE     = 12

function DragonFireball:new(...)
	PassableProp.new(self, ...)

	self:addPoke("shoot")
	self:addPoke("hit")
	self:addPoke("explode")
end

function DragonFireball:onShoot(e)
	if self.isShot then
		return
	end

	self.currentDragon = e.dragon or false
	self.currentTarget = e.peep or false
	self.currentWeapon = e.weapon or false

	local absoluteTargetPosition = self.currentTarget and Utility.Peep.getAbsolutePosition(self.currentTarget) or Vector.ZERO
	local relativeTargetPosition = Utility.Map.absolutePositionToRelativePosition(self:getDirector(), Utility.Peep.getLayer(self), absoluteTargetPosition)

	local dragonTransform = self.currentDragon and Utility.Peep.getAbsoluteTransform(self.currentDragon)
	local absoluteDragonMouthPosition = (e.position or self.DEFAULT_MOUTH_POSITION):transform(dragonTransform)
	local relativeDragonMouthPosition = Utility.Map.absolutePositionToRelativePosition(self:getDirector(), Utility.Peep.getLayer(self), absoluteDragonMouthPosition)

	self.startPosition = relativeDragonMouthPosition
	self.targetPosition = relativeTargetPosition

	self.currentAccelerationMagnitude = e.accelerationMagnitude or self.DEFAULT_ACCELERATION_MAGNITUDE
	self.currentVelocityMagnitude = e.velocityMagnitude or self.DEFAULT_VELOCITY_MAGNITUDE

	self.currentDirection = self.startPosition:direction(self.targetPosition)
	self.currentAcceleration = self.currentDirection * self.currentAccelerationMagnitude
	self.currentVelocity = self.currentDirection * self.currentVelocityMagnitude
	self.currentRadius = e.radius or self.DEFAULT_EXPLOSION_RADIUS

	self.currentKnockback = e.knockback or self.DEFAULT_KNOCKBACK

	Utility.Peep.setPosition(self, self.startPosition)

	self.currentHits = {}

	self.isShot = true
end

function DragonFireball:_updatePosition(delta)
	self.currentVelocity = self.currentVelocity + self.currentAcceleration * delta

	local position = Utility.Peep.getPosition(self) + self.currentVelocity * delta
	Utility.Peep.setPosition(self, position)
end

function DragonFireball:_tryHit(radius)
	local hits = self:getDirector():probe(self:getLayerName(),
		Probe.attackable(self.currentDragon or self),
		function(p)
			if Utility.Peep.isDisabled(p) then
				return false
			end

			local distance = Utility.Peep.getAbsoluteDistance(self, p)
			return distance <= radius
		end)

	if #hits == 0 then
		return
	end

	for _, hit in ipairs(hits) do
		if not self.currentHits[hit] then
			if self.currentDragon and self.currentWeapon then
				hit:addBehavior(PendingStrategyGradeBehavior)
				self.currentWeapon:perform(self.currentDragon, hit)

				Utility.Combat.dodgeFailure(hit, self.currentDragon)
				Utility.Combat.knockback(hit, self, self.currentKnockback)

				self:poke("hit", hit)

				Log.info("'%s' shot by '%s' hit peep '%s'.", self:getName(), self.currentDragon:getName(), hit:getName())
			end

			self.currentHits[hit] = true
		end
	end
end

function DragonFireball:_tryExplode()
	local position = Utility.Peep.getAbsolutePosition(self)

	local instance = Utility.Peep.getInstance(self)
	for _, layer in instance:iterateLayers() do
		local instanceMap = instance:getMap(layer)
		local meta = instanceMap and instanceMap:getMeta()
		if not meta.skybox then
			local mapScript = instance:getMapScriptByLayer(layer)
			local map = Utility.Peep.getMap(mapScript)

			local transform = Utility.Peep.getMapTransform(mapScript)
			local relativePosition = position:inverseTransform(transform)
			if relativePosition.x >= 0 and relativePosition.x <= map:getWidth() * map:getCellSize() and
			   relativePosition.z >= 0 and relativePosition.z <= map:getHeight() * map:getCellSize()
			then
				local y = map:getInterpolatedHeight(relativePosition.x, relativePosition.z)
				if relativePosition.y <= y then
					self:_tryHit(self.currentRadius)

					local stage = self:getDirector():getGameInstance():getStage()
					stage:fireProjectile("CannonSplosionHit", Vector.ZERO, Utility.Peep.getAbsolutePosition(self), Utility.Peep.getLayer(self))

					if self.currentTarget and not self.currentHits[self.currentTarget] then
						Utility.Combat.dodgeSuccess(self.currentTarget, self.currentDragon)
					end

					Utility.Peep.poof(self)
					return true
				end
			end
		end
	end

	return false
end

function DragonFireball:update(director, game)
	PassableProp.update(self, director, game)

	if not self.isShot then
		return
	end

	local delta = game:getDelta()
	self:_updatePosition(delta)

	if not self:_tryExplode() then
		self:_tryHit(0)
	end
end

function DragonFireball:getPropState()
	return {
		isShot = not not self.isShot
	}
end

return DragonFireball
