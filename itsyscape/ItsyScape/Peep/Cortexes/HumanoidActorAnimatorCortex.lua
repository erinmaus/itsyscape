--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/HumanoidActorAnimatorCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Shield = require "ItsyScape.Game.Shield"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local CacheRef = require "ItsyScape.Game.CacheRef"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TilePathNode = require "ItsyScape.World.TilePathNode"

local HumanoidActorAnimatorCortex = Class(Cortex)
HumanoidActorAnimatorCortex.WALK_PRIORITY = 1
HumanoidActorAnimatorCortex.SKILL_PRIORITY = 5
HumanoidActorAnimatorCortex.ATTACK_PRIORITY = 1000
HumanoidActorAnimatorCortex.DEATH_PRIORITY = 2000
HumanoidActorAnimatorCortex.DEFEND_PRIORITY = 10

function HumanoidActorAnimatorCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(HumanoidBehavior)
	self:require(MovementBehavior)

	self.walking = {}
	self.idling = {}
end

function HumanoidActorAnimatorCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	peep:listen('initiateAttack', self.onInitiateAttack, self)
	peep:listen('receiveAttack', self.onReceiveAttack, self)
	peep:listen('die', self.onDie, self)
	peep:listen('resurrect', self.onResurrect, self)
	peep:listen('resourceHit', self.onResourceHit, self)
	peep:listen('actionPerformed', self.onActionPerformed, self)
	peep:listen('transferItemFrom', self.peekEquip, self)
	peep:listen('transferItemTo', self.peekEquip, self)
	peep:listen('spawnEquipment', self.peekEquip, self)
	peep:listen('switchStyle', self.peekStyle, self)
	peep:listen('actionFailed', self.actionFailed, self)
	peep:listen('travel', self.onTravel, self)
end

function HumanoidActorAnimatorCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.walking[peep] = nil
	self.idling[peep] = nil

	peep:silence('initiateAttack', self.onInitiateAttack)
	peep:silence('receiveAttack', self.onReceiveAttack)
	peep:silence('die', self.onDie)
	peep:silence('resurrect', self.onResurrect)
	peep:silence('resourceHit', self.onResourceHit)
	peep:silence('actionPerformed', self.onActionPerformed)
	peep:silence('transferItemFrom', self.peekEquip)
	peep:silence('transferItemTo', self.peekEquip)
	peep:silence('spawnEquipment', self.peekEquip)
	peep:silence('switchStyle', self.peekStyle)
	peep:silence('actionFailed', self.actionFailed, self, peep)
	peep:silence('travel', self.onTravel, self)
end

function HumanoidActorAnimatorCortex:playSkillAnimation(peep, priority, resource)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor then
		actor = actor.actor
		actor:playAnimation('skill', priority, resource)
	end
end

function HumanoidActorAnimatorCortex:playCombatAnimation(peep, priority, resource)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor then
		actor = actor.actor
		actor:playAnimation('combat-attack', priority, resource)
	end
end

function HumanoidActorAnimatorCortex:playDeathAnimation(peep, priority, resource)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor then
		actor = actor.actor
		actor:playAnimation('combat-die', priority, resource)
	end
end

function HumanoidActorAnimatorCortex:playDefendAnimation(peep, priority, resource)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor then
		actor = actor.actor
		actor:playAnimation('combat-defend', priority, resource)
	end
end

function HumanoidActorAnimatorCortex:onInitiateAttack(peep, p)
	local animations = {
		string.format("animation-attack-%s-%s", p:getAttackType(), p:getWeaponType()),
		string.format("animation-attack-%s", p:getWeaponType()),
		string.format("animation-attack-%s", p:getAttackType()),
		"animation-attack"
	}

	local playedAnimation = false
	local time
	for i = 1, #animations do
		local resource = peep:getResource(
			animations[i],
			"ItsyScape.Graphics.AnimationResource")
		if resource then
			self:playCombatAnimation(
				peep,
				HumanoidActorAnimatorCortex.ATTACK_PRIORITY,
				resource)
			break
		else
			Log.info("Missing '%s' animation for peep '%s'.", animations[i], peep:getName())
		end
	end
end

function HumanoidActorAnimatorCortex:onReceiveAttack(peep, p)
	local hasShield = false
	do
		local rightHandItem = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_LEFT_HAND)
		if rightHandItem then
			local shieldLogic = peep:getDirector():getItemManager():getLogic(rightHandItem:getID())
			if shieldLogic:isCompatibleType(Shield) then
				hasShield = true
			end
		end
	end

	local direction = peep:getBehavior(MovementBehavior).facing

	local resource
	if hasShield then
		if direction == MovementBehavior.FACING_LEFT then
			resource = peep:getResource(
				"animation-defend-shield-left",
				"ItsyScape.Graphics.AnimationResource")
		elseif direction == MovementBehavior.FACING_RIGHT then
			resource = peep:getResource(
				"animation-defend-shield-right",
				"ItsyScape.Graphics.AnimationResource")
		end
	end

	if not resource then
		resource = peep:getResource(
			"animation-defend",
			"ItsyScape.Graphics.AnimationResource")
	end

	if resource then
		self:playDefendAnimation(
			peep,
			HumanoidActorAnimatorCortex.DEFEND_PRIORITY,
			resource)
	end
end

function HumanoidActorAnimatorCortex:onDie(peep, p)
	local resource = peep:getResource(
		"animation-die",
		"ItsyScape.Graphics.AnimationResource")
	if resource then
		self:playDeathAnimation(
			peep,
			HumanoidActorAnimatorCortex.DEATH_PRIORITY,
			resource)
	end
end

function HumanoidActorAnimatorCortex:onResurrect(peep, p)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	if actor then
		local resource = peep:getResource(
			"animation-resurrect",
			"ItsyScape.Graphics.AnimationResource")
		if resource then
			self:playCombatAnimation(
				peep,
				HumanoidActorAnimatorCortex.ATTACK_PRIORITY,
				resource)
		else
			actor:playAnimation('combat', false)
		end
	end
end

function HumanoidActorAnimatorCortex:onTravel(peep)
	local position = peep:getBehavior(PositionBehavior)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	if actor then
		actor:teleport(position.position)
	end
end

function HumanoidActorAnimatorCortex:getPeepWeaponType(peep, weapon)
	if not weapon then
		weapon = Utility.Peep.getEquippedWeapon(peep, true)
	end

	local x
	if weapon and weapon:isCompatibleType(Weapon) then
		x = weapon:getWeaponType()
	end

	return x
end

function HumanoidActorAnimatorCortex:getIdleAnimation(peep, weapon)
	local x = self:getPeepWeaponType(peep, weapon)
	return self:getXAnimation(peep, "idle", x)
end

function HumanoidActorAnimatorCortex:getWalkAnimation(peep, weapon)
	local x = self:getPeepWeaponType(peep, weapon)
	return self:getXAnimation(peep, "walk", x)
end

function HumanoidActorAnimatorCortex:getXAnimation(peep, prefix, x)
	local animations = {
		string.format("animation-%s", prefix)
	}

	if x then
		table.insert(animations, 1, string.format("animation-%s-%s", prefix, x))
	end

	for i = 1, #animations do
		local resource = peep:getResource(
			animations[i],
			"ItsyScape.Graphics.AnimationResource")
		if resource then
			return resource
		end
	end

	return nil
end

function HumanoidActorAnimatorCortex:onResourceHit(peep, p)
	local skill = p.skill or "none"
	local animations = {
		string.format("animation-skill-%s", p.skill),
		"animation-skill"
	}

	local playedAnimation = false
	local time
	for i = 1, #animations do
		local resource = peep:getResource(
			animations[i],
			"ItsyScape.Graphics.AnimationResource")
		if resource then
			self:playSkillAnimation(
				peep,
				HumanoidActorAnimatorCortex.SKILL_PRIORITY,
				resource)
			break
		end
	end
end

function HumanoidActorAnimatorCortex:onActionPerformed(peep, p)
	local actionName = p.action:getName():lower()
	local resource = peep:getResource(
		string.format("animation-action-%s", actionName),
		"ItsyScape.Graphics.AnimationResource")
	if resource then
		self:playSkillAnimation(
			peep,
			HumanoidActorAnimatorCortex.SKILL_PRIORITY,
			resource)
	end
end

function HumanoidActorAnimatorCortex:actionFailed(peep)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	if actor then
		actor:playAnimation('skill', false)
	end
end

function HumanoidActorAnimatorCortex:peekEquip(peep, e)
	local item = nil
	if e.purpose == 'equip' then
		item = e.item
	end

	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	local logic = peep:getDirector():getItemManager():getLogic(e.item:getID())
	if logic:isCompatibleType(Weapon) then
		if (self.idling[actor] and self.idling[actor] ~= self:getIdleAnimation(peep, logic)) or
		   (self.walking[actor] and self.walking[actor] ~= self:getWalkAnimation(peep, logic))
		then
			self.idling[actor] = nil
			self.walking[actor] = nil
		end
	end
end

function HumanoidActorAnimatorCortex:peekStyle(peep, e)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	local logic = Utility.Peep.getEquippedWeapon(peep, true)
	if logic and logic:isCompatibleType(Weapon) then
		if (self.idling[actor] and self.idling[actor] ~= self:getIdleAnimation(peep, logic)) or
		   (self.walking[actor] and self.walking[actor] ~= self:getWalkAnimation(peep, logic))
		then
			self.idling[actor] = nil
			self.walking[actor] = nil
		end
	end
end

function HumanoidActorAnimatorCortex:isWalking(peep)
	local movement = peep:getBehavior(MovementBehavior)
	local velocity = movement.velocity
	local canMove = movement.maxSpeed > 0 and movement.maxAcceleration > 0
	                and movement.velocityMultiplier > 0 and movement.accelerationMultiplier > 0

    local targetTile = peep:getBehavior(TargetTileBehavior)
    local isMoving = targetTile and (Class.isCompatibleType(targetTile.pathNode, TilePathNode) or not targetTile.pathNode)

    return (velocity:getLength() > 0.1 or isMoving) and canMove
end

function HumanoidActorAnimatorCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		-- TODO this needs to be better
		if self:isWalking(peep) then
			if not self.walking[actor] then
				local resource = self:getWalkAnimation(peep)
				if resource then
					actor:playAnimation('main', HumanoidActorAnimatorCortex.WALK_PRIORITY, resource)
					self.walking[actor] = resource
					self.idling[actor] = nil
				end
			end
		else
			if not self.idling[actor] then
				local resource = self:getIdleAnimation(peep)
				if resource then
					actor:playAnimation('main', HumanoidActorAnimatorCortex.WALK_PRIORITY, resource, false, math.random())
					self.idling[actor] = resource
					self.walking[actor] = false
				end
			end
		end
	end
end

return HumanoidActorAnimatorCortex
