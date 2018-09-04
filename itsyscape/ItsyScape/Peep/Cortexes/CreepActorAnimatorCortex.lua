--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/CreepActorAnimatorCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local CacheRef = require "ItsyScape.Game.CacheRef"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CreepBehavior = require "ItsyScape.Peep.Behaviors.CreepBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local CreepActorAnimatorCortex = Class(Cortex)
CreepActorAnimatorCortex.WALK_PRIORITY = 1
CreepActorAnimatorCortex.SKILL_PRIORITY = 5
CreepActorAnimatorCortex.ATTACK_PRIORITY = math.huge
CreepActorAnimatorCortex.DEFEND_PRIORITY = 10

function CreepActorAnimatorCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(CreepBehavior)
	self:require(MovementBehavior)

	self.walking = {}
	self.idling = {}
end

function CreepActorAnimatorCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	peep:listen('initiateAttack', self.onInitiateAttack, self)
	peep:listen('receiveAttack', self.onReceiveAttack, self)
	peep:listen('die', self.onDie, self)
end

function CreepActorAnimatorCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	peep:silence('initiateAttack', self.onInitiateAttack)
	peep:silence('receiveAttack', self.onReceiveAttack)
	peep:silence('die', self.onDie)
end

function CreepActorAnimatorCortex:playAnimation(peep, priority, resource)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	if actor then
		actor = actor.actor
		actor:playAnimation('combat', priority, resource)
	end
end

function CreepActorAnimatorCortex:onInitiateAttack(peep, p)
	local animations = {
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
			self:playAnimation(
				peep,
				CreepActorAnimatorCortex.ATTACK_PRIORITY,
				resource)
			break
		end
	end
end

function CreepActorAnimatorCortex:onReceiveAttack(peep, p)
	local resource = peep:getResource(
		"animation-defend",
		"ItsyScape.Graphics.AnimationResource")
	if resource then
		self:playAnimation(
			peep,
			CreepActorAnimatorCortex.DEFEND_PRIORITY,
			resource)
	end
end

function CreepActorAnimatorCortex:onDie(peep, p)
	local resource = peep:getResource(
		"animation-die",
		"ItsyScape.Graphics.AnimationResource")
	if resource then
		self:playAnimation(
			peep,
			CreepActorAnimatorCortex.ATTACK_PRIORITY,
			resource)
	end
end

function CreepActorAnimatorCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local velocity = peep:getBehavior(MovementBehavior).velocity
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		-- TODO this needs to be better
		if velocity:getLength() > 0.1 then
			if not self.walking[actor] then
				local resource = peep:getResource(
					"animation-walk",
					"ItsyScape.Graphics.AnimationResource")
				actor:playAnimation('main', CreepActorAnimatorCortex.WALK_PRIORITY, resource)
				self.walking[actor] = true
				self.idling[actor] = nil
			end
		else
			if not self.idling[actor] then
				local resource = peep:getResource(
					"animation-idle",
					"ItsyScape.Graphics.AnimationResource")
				actor:playAnimation('main', CreepActorAnimatorCortex.WALK_PRIORITY, resource)
				self.idling[actor] = true
				self.walking[actor] = false
			end
		end
	end
end

return CreepActorAnimatorCortex
