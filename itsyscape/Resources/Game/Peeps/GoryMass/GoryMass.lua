--------------------------------------------------------------------------------
-- Resources/Peeps/GoryMass/GoryMass.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local GoryMass = Class(Creep)
GoryMass.MIN_SCALE = Vector(0.5, 0.75, 0.5)
GoryMass.MAX_SCALE = Vector(1, 1, 1)
GoryMass.MIN_OVERSHOOT = 8
GoryMass.MAX_OVERSHOOT = 12
GoryMass.DELTA_MULTIPLIER_MOVING = 2
GoryMass.DELTA_MULTIPLIER_STATIONARY = 4
GoryMass.STOP_ROLLING_THRESHOLD_SQUARED = 3 ^ 2
GoryMass.ROTATION_MULTIPLIER = math.pi
GoryMass.GIVE_UP_TIME = 0.5

function GoryMass:new(resource, name, ...)
	Creep.new(self, resource, name or 'GoryMass_Base', ...)

	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3, 3, 3)
	size.offset = Vector.UNIT_Y * -1.5

	local status = self:getBehavior(CombatStatusBehavior)
	status.maxChaseDistance = math.huge

	self:addPoke('startRoll')
	self:addPoke('stopRoll')

	self.time = 0
	self.targetTime = 0

	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)
end

function GoryMass:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/GoryMass.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/GoryMass_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/GoryMass_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/GoryMass/GoryMass.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxAcceleration = 16
	movement.maxSpeed = 10
	movement.float = 1.5

	Utility.Peep.equipXWeapon(self, "GoryMass_Attack")

	Creep.ready(self, director, game)
end

function GoryMass:isMoving()
	return self:hasTarget() and not self.isPendingMove
end

function GoryMass:hasTarget()
	return self.targetPosition ~= nil
end

function GoryMass:onStartRoll(target)
	if not target then
		Log.warn("No target for gory mass; cannot attack.")
		return
	end

	if Utility.Peep.canAttack(self) and not self.targetPosition then
		local selfPosition = Utility.Peep.getAbsolutePosition(self) * Vector.PLANE_XZ

		local targetPosition
		if Class.isCompatibleType(target, Vector) then
			targetPosition = target
		else
			if Utility.Peep.getLayer(self) ~= Utility.Peep.getLayer(target) then
				return
			end

			local selfI, selfJ = Utility.Peep.getTile(self)
			local targetI, targetJ = Utility.Peep.getTile(target)

			local map = self:getDirector():getMap(Utility.Peep.getLayer(self))
			local lineOfSightClear = map and map:lineOfSightPassable(selfI, selfJ, targetI, targetJ)

			if not lineOfSightClear then
				local success, path = Utility.Peep.getWalk(
					self,
					targetI, targetJ, Utility.Peep.getLayer(self),
					1.5)

				if not success then
					return
				end

				local node = path:getNodeAtIndex(2)
				if not node then
					return
				end

				targetPosition = map:getTileCenter(node.i, node.j) * Vector.PLANE_XZ
			else
				targetPosition = Utility.Peep.getAbsolutePosition(target) * Vector.PLANE_XZ
			end
		end

		local direction = (targetPosition - selfPosition):getNormal()
		local overshoot = love.math.random() * (GoryMass.MAX_OVERSHOOT - GoryMass.MIN_OVERSHOOT) + GoryMass.MIN_OVERSHOOT

		self.targetPosition = targetPosition + direction * overshoot
		self.hits = {}

		local cooldown = self:getBehavior(AttackCooldownBehavior)
		if cooldown and cooldown.cooldown > 0 then
			self.isPendingMove = true
		else
			self.isPendingMove = false
		end
	end
end

function GoryMass:onStopRoll()
	self.targetPosition = nil

	local movement = self:getBehavior(MovementBehavior)
	movement.acceleration = Vector.ZERO
	movement.velocity = Vector.ZERO

	local weapon = Utility.Peep.getEquippedWeapon(self, true)
	if weapon then
		weapon:applyCooldown(self)
	end

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		if Utility.Peep.canAttack(self) then
			mashina.currentState = "idle"
		else
			mashina.currentState = false
		end
	end
end

function GoryMass:onMovedOutOfBounds()
	self.isOutOfBounds = true
end

function GoryMass:onReceiveAttack(attackPoke)
	self:poke('startRoll', attackPoke:getAggressor())
end

function GoryMass:getSelfPosition()
	return Utility.Peep.getAbsolutePosition(self) * Vector.PLANE_XZ
end

function GoryMass:onDie()
	self:poke('stopRoll')

	local rotation = self:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.IDENTITY
end

function GoryMass:faceTarget()
	local selfPosition = self:getSelfPosition()
	local rotation = self:getBehavior(RotationBehavior)
	local lookAt = Quaternion.lookAt(selfPosition, self.targetPosition)
	local spin = Quaternion.fromAxisAngle(Vector.UNIT_X, self.targetTime * GoryMass.ROTATION_MULTIPLIER)
	rotation.rotation = lookAt * spin
end

function GoryMass:followTarget()
	local selfPosition = self:getSelfPosition()
	local difference = self.targetPosition - selfPosition
	if difference:getLengthSquared() < GoryMass.STOP_ROLLING_THRESHOLD_SQUARED then
		self:poke('stopRoll')
	else
		local movement = self:getBehavior(MovementBehavior)
		movement.acceleration = (self.targetPosition - selfPosition):getNormal() * movement.maxAcceleration

		self:faceTarget()
		self:splodeTargets()
	end
end

function GoryMass:wobble()
	if Utility.Peep.canAttack(self) then
		local scaleDelta = (math.sin(self.time) + 1) / 2
		local scale = self:getBehavior(ScaleBehavior)
		scale.scale = (GoryMass.MAX_SCALE - GoryMass.MIN_SCALE) * scaleDelta + GoryMass.MIN_SCALE
	end
end

function GoryMass:splodeTargets()
	local selfPosition = self:getSelfPosition()
	local director = self:getDirector()
	local hits = director:probe(self:getLayerName(), function(peep)
		local position = Utility.Peep.getAbsolutePosition(peep) * Vector.PLANE_XZ

		local isOnSameLayer = Utility.Peep.getLayer(peep) == Utility.Peep.getLayer(self)
		local isWithinRadius = (position - selfPosition):getLengthSquared() < GoryMass.STOP_ROLLING_THRESHOLD_SQUARED
		local isAttackable = Utility.Peep.canAttack(peep) and Utility.Peep.isAttackable(peep)
		local isDifferentThanSelf = peep ~= self

		return isOnSameLayer and isWithinRadius and isAttackable and isDifferentThanSelf
	end)

	for i = 1, #hits do
		local peep = hits[i]
		if not self.hits[peep] then
			self.hits[peep] = true
			self:splode(peep)
		end
	end
end

function GoryMass:splode(peep)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("GoryMassSplosion", self, peep)

	local weapon = Utility.Peep.getEquippedWeapon(self, true)
	if weapon then
		local resource = Utility.Peep.getResource(peep)

		weapon:perform(self, peep)

		if not resource or resource.name ~= "GoryMass" then
			weapon:perform(self, self)
		end
	end
end

function GoryMass:update(...)
	Creep.update(self, ...)

	local selfPosition = Utility.Peep.getAbsolutePosition(self) * Vector.PLANE_XZ

	local game = self:getDirector():getGameInstance()
	local delta = game:getDelta()
	local multiplier

	if self.isOutOfBounds then
		self.isOutOfBoundsTime = (self.isOutOfBoundsTime or 0) + delta

		if self.isOutOfBoundsTime > GoryMass.GIVE_UP_TIME then
			self:poke("stopRoll")

			self.isOutOfBoundsTime = nil
		end

		self.isOutOfBounds = false
	end

	if self:isMoving() then
		multiplier = GoryMass.DELTA_MULTIPLIER_MOVING
		self.targetTime = self.time + delta

		self:followTarget()
	else
		multiplier = GoryMass.DELTA_MULTIPLIER_STATIONARY
	end
	self.time = self.time + delta * multiplier

	if self.isPendingMove then
		local cooldown = self:getBehavior(AttackCooldownBehavior)
		if cooldown and cooldown.cooldown <= 0 then
			self.isPendingMove = false
		end
	end

	self:wobble()
end

return GoryMass
