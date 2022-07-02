--------------------------------------------------------------------------------
-- ItsyScape/UI/ProCombatStatusHUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local Effect = require "ItsyScape.Peep.Effect"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local ProCombatStatusHUDController = Class(Controller)

function ProCombatStatusHUDController:new(peep, director)
	Controller.new(self, peep, director)

	self:updateState()
end

function ProCombatStatusHUDController:poke(actionID, actionIndex, e)
	if actionID == "toggle" then
		self:toggle()
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ProCombatStatusHUDController:pull(e)
	return self.state
end

function ProCombatStatusHUDController:pullStateForPeep(peep)
	local gameDB = self:getDirector():getGameDB()

	local actor = peep:getBehavior(ActorReferenceBehavior)
	do
		if not actor or not actor.actor then
			return nil
		end

		actor = actor.actor
	end

	local target = peep:getBehavior(CombatTargetBehavior)
	if target then
		target = target.actor
	end

	local result = {
		actorID = actor:getID(),
		targetID = target and target:getID(),
		effects = {},
		stats = {}
	}

	do
		for effect in peep:getEffects() do
			local resource = effect:getResource()
			local e = {
				id = resource.name,
				z = resource.id.value,
				name = Utility.getName(resource, gameDB),
				description = Utility.getDescription(resource, gameDB),
				duration = effect:getDuration(),
				debuff = effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE,
				buff = effect:getBuffType() == Effect.BUFF_TYPE_POSITIVE
			}

			table.insert(result.effects, e)
		end

		table.sort(result.effects, function(a, b) return a.z < b.z end)
	end

	do
		local status = peep:getBehavior(CombatStatusBehavior)
		if status then
			result.stats.prayer = {
				current = status.currentPrayer,
				max = status.maximumPrayer
			}

			result.stats.hitpoints = {
				current = status.currentHitpoints,
				max = status.maximumHitpoints
			}
		else
			result.stats = {
				prayer = { current = 0, max = 0 },
				hitpoints = { current = 0, max = 0 }
			}
		end
	end

	return result
end

function ProCombatStatusHUDController:isAttacking()
	return function(peep)
		local status = peep:getBehavior(CombatStatusBehavior)
		local target = peep:getBehavior(CombatTargetBehavior)

		local hasTarget = target and target.actor
		local isAlive = status and not status.dead

		return hasTarget and isAlive
	end
end

function ProCombatStatusHUDController:isBeingAttacked()
	return function(peep)
		local actor = peep:getBehavior(ActorReferenceBehavior)
		if not actor or not actor.actor then
			return false
		end

		if self.targetsByID[actor.actor:getID()] then
			return true
		end
	end
end


function ProCombatStatusHUDController:updateState()
	local director = self:getDirector()

	local result = {
		combatants = {}
	}

	self.combatantsByID = {}
	self.targetsByID = {} 

	local attackers = director:probe(
		self:getPeep():getLayerName(),
		self:isAttacking())

	for i = 1, #attackers do
		local r = self:pullStateForPeep(attackers[i])
		self.targetsByID[r.targetID] = true
		self.combatantsByID[r.actorID] = true

		table.insert(result.combatants, r)

		if r.actorID == director:getGameInstance():getPlayer():getActor():getID() then
			result.player = r
		end
	end

	local victims = director:probe(
		self:getPeep():getLayerName(),
		self:isBeingAttacked())

	for i = 1, #victims do
		local r = self:pullStateForPeep(victims[i])
		table.insert(result.combatants, r)

		if r.actorID == director:getGameInstance():getPlayer():getActor():getID() then
			result.player = r
		end
	end

	self.state = result
end

function ProCombatStatusHUDController:update(delta)
	Controller.update(self, delta)

	self:updateState()
end

return ProCombatStatusHUDController
