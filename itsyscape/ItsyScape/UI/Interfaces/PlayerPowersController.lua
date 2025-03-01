--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerPowersController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local Spell = require "ItsyScape.Game.Spell"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Controller = require "ItsyScape.UI.Controller"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"

local PlayerPowersController = Class(Controller)

function PlayerPowersController:new(peep, director)
	Controller.new(self, peep, director)

	self.style = "Attack"

	self:update(0)
end

function PlayerPowersController:poke(actionID, actionIndex, e)
	if actionID == "activateOffensivePower" then
		self:activate(self.state.offensive, e)
	elseif actionID == "activateDefensivePower" then
		self:activate(self.state.defensive, e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerPowersController:getPendingPowerID()
	local peep = self:getPeep()
	local pending = peep:getBehavior(PendingPowerBehavior)
	if pending and pending.power then
		return pending.power:getResource().name
	end

	return nil
end

function PlayerPowersController:getAvailablePowers()
	local offensivePowers = {}
	local defensivePowers = {}

	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for power in gameDB:getResources("Power") do
		local isSameStyle = false
		local isDefensive = false
		local style
		local xp
		
		for action in brochure:findActionsByResource(power) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name:lower() == "activate" then
				for requirement in brochure:getRequirements(action) do
					local resource = brochure:getConstraintResource(requirement)
					if resource.name == self.style then
						style = resource.name
						isSameStyle = true
						xp = requirement.count
						break
					elseif resource.name == "Defense" then
						style = resource.name
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
			local instance
			do
				local PowerType = Utility.Peep.getPowerType(power, gameDB)
				instance = PowerType(self:getGame(), power)
				coolDownDescription = string.format("Zeal: %d%%", instance:getCost(self:getPeep()) * 100)
			end

			local result = {
				index = power.id.value,
				id = power.name,
				name = Utility.getName(power, gameDB) or "*" .. power.name,
				description = {
					Utility.getDescription(power, gameDB),
					string.format("Requires level %d %s.", Curve.XP_CURVE:getLevel(xp), style),
					coolDownDescription
				},
				level = Curve.XP_CURVE:getLevel(xp),
				enabled = instance:getAction():canPerform(self:getPeep():getState()) and instance:getAction():canTransfer(self:getPeep():getState())
			}

			local skill, powers
			if isSameStyle then
				skill = self.style
				powers = offensivePowers
			elseif isDefensive then
				skill = "Defense"
				powers = defensivePowers
			end

			table.insert(powers, result)
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

function PlayerPowersController:updatePowers()
	local offensivePowers, defensivePowers = self:getAvailablePowers()

	self.currentOffensivePowers = offensivePowers
	self.currentDefensivePowers = defensivePowers
end

function PlayerPowersController:activate(powers, e)
	local power = powers[e.index]
	if power then
		local peep = self:getPeep()
		local gameDB = self:getDirector():getGameDB()

		if power.id == self.state.pendingID then
			peep:removeBehavior(PendingPowerBehavior)
		else
			local powerResource = gameDB:getResource(power.id, "Power")
			if powerResource then
				local PowerType = Utility.Peep.getPowerType(powerResource, gameDB)
				if PowerType then
					local power = PowerType(self:getGame(), powerResource)

					local _, b = peep:addBehavior(PendingPowerBehavior)
					b.power = power
				end
			end
		end
	end
end

function PlayerPowersController:updateStyle()
	local peep = self:getPeep()

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
end

function PlayerPowersController:updateState()
	local result = {
		style = self.style,
		offensive = self.currentOffensivePowers,
		defensive = self.currentDefensivePowers,
		pendingID = self:getPendingPowerID()
	}

	self.state = result
end

function PlayerPowersController:pull()
	return self.state
end

function PlayerPowersController:sendRefresh()
	local ui = self:getDirector():getGameInstance():getUI()
	ui:sendPoke(self, "refresh", nil, {})
end

function PlayerPowersController:update(delta)
	Controller.update(self, delta)

	local oldStyle = self.style

	self:updateStyle()
	self:updatePowers()
	self:updateState()

	if self.style ~= oldStyle then
		self:sendRefresh()
	end
end

return PlayerPowersController
