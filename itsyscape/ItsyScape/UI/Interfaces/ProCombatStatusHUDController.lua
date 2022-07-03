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
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local Effect = require "ItsyScape.Peep.Effect"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"

local ProCombatStatusHUDController = Class(Controller)

function ProCombatStatusHUDController:new(peep, director)
	Controller.new(self, peep, director)

	self:bindToPlayer(peep)
	self.isDirty = true

	self:update(0)
end

function ProCombatStatusHUDController:bindToPlayer(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats

		self._onLevelUp = function(stats, skill, oldLevel)
			self.isDirty = true
		end
		stats.onLevelUp:register(self._onLevelUp)
	end
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

function ProCombatStatusHUDController:getPendingPowerID()
	local peep = self:getPeep()
	local pending = peep:getBehavior(PendingPowerBehavior)
	if pending and pending.power then
		return pending.power:getResource().name
	end

	return nil
end

function ProCombatStatusHUDController:updatePowersState(powers)
	local peep = self:getPeep()
	local gameDB = self:getDirector():getGameDB()

	local b = peep:getBehavior(PowerCoolDownBehavior)
	if not b then
		peep:addBehavior(PowerCoolDownBehavior)
		b = peep:getBehavior(PowerCoolDownBehavior)
	end

	if b then
		local time = self:getGame():getCurrentTick() * self:getGame():getDelta()
		for i = 1, #powers do
			local p = powers[i]

			local resource = gameDB:getResource(p.id, "Power")
			if b.powers[resource.id.value] then
				local coolDown = b.powers[resource.id.value] - time
				if coolDown > 0 then
					p.coolDown = math.floor(coolDown)
				end
			end
		end
	end
end

function ProCombatStatusHUDController:updateState()
	local director = self:getDirector()

	local result = {
		combatants = {},
		powers = {
			offensive = self.currentOffensivePowers,
			defensive = self.currentDefensivePowers,
			pendingID = self:getPendingPowerID()
		},
		style = self.style
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

	self:updatePowersState(result.powers.offensive)
	self:updatePowersState(result.powers.defensive)

	self.state = result
end

function ProCombatStatusHUDController:getAvailablePowers()
	local offensivePowers = {}
	local defensivePowers = {}

	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for power in gameDB:getResources("Power") do
		local isSameStyle = false
		local isDefensive = false
		local xp
		
		for action in brochure:findActionsByResource(power) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name:lower() == "activate" then
				for requirement in brochure:getRequirements(action) do
					local resource = brochure:getConstraintResource(requirement)
					if resource.name == self.style then
						isSameStyle = true
						xp = requirement.count
						break
					elseif resource.name == "Defense" then
						isDefensive = true
						xp = requirement.count
						break
					end
				end
			end

			if isSameStyle or isDefensive then
				break
			end
		end

		if isSameStyle or isDefensive then
			local coolDownDescription
			do
				local PowerType = Utility.Peep.getPowerType(power, gameDB)
				local instance = PowerType(self:getGame(), power)
				coolDownDescription = string.format("Cooldown: %d seconds", instance:getCoolDown(self:getPeep()))
			end

			local result = {
				index = power.id.value,
				id = power.name,
				name = Utility.getName(power, gameDB) or "*" .. power.name,
				description = {
					Utility.getDescription(power, gameDB),
					coolDownDescription
				},
				level = Curve.XP_CURVE:getLevel(xp)
			}

			local skill, powers
			if isSameStyle then
				skill = self.style
				powers = offensivePowers
			elseif isDefensive then
				skill = "Defense"
				powers = defensivePowers
			end

			if self:getPeep():getState():count("Skill", skill) >= xp then
				table.insert(powers, result)
			end
		end
	end

	table.sort(offensivePowers, function(a, b)
			if a.level < b.level then
				return true
			elseif a.level == b.level then
				return a.index < b.index
			else
				return false
			end
		end)

	table.sort(defensivePowers, function(a, b)
			if a.level < b.level then
				return true
			elseif a.level == b.level then
				return a.index < b.index
			else
				return false
			end
		end)

	return offensivePowers, defensivePowers
end

function ProCombatStatusHUDController:updateStyle()
	local peep = self:getPeep()

	local oldStyle = self.style
	self.style = nil

	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	if weapon then
		weapon = self:getDirector():getItemManager():getLogic(weapon:getID())

		if weapon and weapon:isCompatibleType(Weapon) then
			local style = weapon:getStyle()
			if style == Weapon.STYLE_MAGIC then
				self.style = "Magic"
			elseif style == Weapon.STYLE_ARCHERY then
				self.style = "Archery"
			elseif style == Weapon.STYLE_MELEE then
				self.style = "Attack"
			end
		end
	end

	self.style = self.style or "Attack"

	if self.style ~= oldStyle then
		self.isDirty = true
	end
end

function ProCombatStatusHUDController:updatePowers()
	local offensivePowers, defensivePowers = self:getAvailablePowers()

	self.currentOffensivePowers = offensivePowers
	self.currentDefensivePowers = defensivePowers
end

function ProCombatStatusHUDController:update(delta)
	Controller.update(self, delta)

	self:updateStyle()
	if self.isDirty then
		self:updatePowers()
		self.isDirty = false
	end

	self:updateState()
end

return ProCombatStatusHUDController
