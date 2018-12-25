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
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local CacheRef = require "ItsyScape.Game.CacheRef"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local HumanoidActorAnimatorCortex = Class(Cortex)
HumanoidActorAnimatorCortex.WALK_PRIORITY = 1
HumanoidActorAnimatorCortex.SKILL_PRIORITY = 5
HumanoidActorAnimatorCortex.ATTACK_PRIORITY = math.huge
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
	peep:listen('resourceObtained', self.onResourceObtained, self)
	peep:listen('transferItemFrom', self.peekEquip, self)
	peep:listen('transferItemTo', self.peekEquip, self)
	peep:silence('actionFailed', self.actionFailed, self)
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
	peep:silence('resourceObtained', self.onResourceObtained)
	peep:silence('transferItemFrom', self.peekEquip)
	peep:silence('transferItemTo', self.peekEquip)
	peep:silence('actionFailed', self.actionFailed, self, peep)
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
		actor:playAnimation('combat', priority, resource)
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
		end
	end
end

function HumanoidActorAnimatorCortex:onReceiveAttack(peep, p)
	local resource = peep:getResource(
		"animation-defend",
		"ItsyScape.Graphics.AnimationResource")
	if resource then
		self:playCombatAnimation(
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
		self:playCombatAnimation(
			peep,
			HumanoidActorAnimatorCortex.ATTACK_PRIORITY,
			resource)
	end
end

function HumanoidActorAnimatorCortex:onResurrect(peep, p)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	if actor then
		actor:playAnimation('combat', false)
	end
end

function HumanoidActorAnimatorCortex:getPeepWeaponType(peep, weapon)
	if not weapon then
		weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		         Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	end

	local x
	if weapon then
		weapon = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if weapon:isCompatibleType(Weapon) then
			x = weapon:getWeaponType()
		end
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

function HumanoidActorAnimatorCortex:onResourceObtained(peep)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	if actor then
		actor:playAnimation('skill', false)
	end
end

function HumanoidActorAnimatorCortex:actionFailed(peep)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	if actor then
		actor:playAnimation('skill', false)
	end
end

function HumanoidActorAnimatorCortex:peekEquip(peep, e)
	local actor = peep:getBehavior(ActorReferenceBehavior).actor
	local logic = peep:getDirector():getItemManager():getLogic(e.item:getID())
	if logic:isCompatibleType(Weapon) then
		if (self.idling[actor] and self.idling[actor] ~= self:getIdleAnimation(peep, e.item)) or
		   (self.walking[actor] and self.walking[actor] ~= self:getWalkAnimation(peep, e.item))
		then
			self.idling[actor] = nil
			self.walking[actor] = nil
		end
	end
end

function HumanoidActorAnimatorCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local velocity = peep:getBehavior(MovementBehavior).velocity
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		-- TODO this needs to be better
		if velocity:getLength() > 0.1 or peep:hasBehavior(TargetTileBehavior) then
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
					actor:playAnimation('main', HumanoidActorAnimatorCortex.WALK_PRIORITY, resource)
					self.idling[actor] = resource
					self.walking[actor] = false
				end
			end
		end
	end
end

return HumanoidActorAnimatorCortex
