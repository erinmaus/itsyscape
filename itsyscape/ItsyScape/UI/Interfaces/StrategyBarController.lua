--------------------------------------------------------------------------------
-- ItsyScape/UI/StrategyBarController.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Controller = require "ItsyScape.UI.Controller"
local Effect = require "ItsyScape.Peep.Effect"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"

local StrategyBarController = Class(Controller)
StrategyBarController.VIEW_SELF = 1
StrategyBarController.VIEW_TARGET = 2
StrategyBarController.MAX_STRIP_SIZE = 7

function StrategyBarController:new(peep, director)
	Controller.new(self, peep, director)

	self.currentInterfaceID = false
	self.currentInterfaceIndex = false

	self:updateState()
end

function StrategyBarController:getCurrentPowerStripStorage()
	local storage = self:getDirector():getPlayerStorage(self:getPeep())
	local powers = storage:getRoot():getSection("StrategyBar"):getSection("Powers")
	local strip = powers:getSection(self.style):getSection(1)

	return strip
end

function StrategyBarController:loadPowers()
	local strip = self:getCurrentPowerStripStorage()

	self.powers = {}
	for i = 1, strip:length() do
		local power = strip:getSection(i)
		self.powers[power:get("index")] = {
			type = power:get("type"),
			id = power:get("id")
		}
	end

	self:getPeep():removeBehavior(PendingPowerBehavior)
end

function StrategyBarController:savePowers()
	local strip = self:getCurrentPowerStripStorage()
	strip:reset()

	for i = 1, StrategyBarController.MAX_STRIP_SIZE do
		local power = self.powers[i]
		if power then
			strip:set(i, {
				index = i,
				type = power.type,
				id = power.id
			})
		end
	end
end

function StrategyBarController:poke(actionID, actionIndex, e)
	if actionID == "activate" then
		self:activate(e)
	elseif actionID == "bind" then
		self:bind(e)
	elseif actionID == "unbind" then
		self:unbind(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function StrategyBarController:pull(e)
	return self.state
end

function StrategyBarController:activate(e)
	assert(type(e.index) == 'number', "index must be number")
	assert(e.index >= 1, "index must be greater than zero")

	local gameDB = self:getDirector():getGameDB()

	local p = self.state.powers[e.index]
	if p and not e.bind then
		local peep = self:getPeep()

		if e.index == self.state.pending then
			peep:removeBehavior(PendingPowerBehavior)
		else
			local powerResource = gameDB:getResource(p.id, "Power")
			if powerResource then
				local PowerType = Utility.Peep.getPowerType(powerResource, gameDB)
				if PowerType then
					local power = PowerType(self:getGame(), powerResource)

					local _, b = peep:addBehavior(PendingPowerBehavior)
					b.power = power
				end
			end
		end
	else
		self:bindAbility(e.index)
	end
end

function StrategyBarController:bindAbility(index)
	local style = self.state.style

	local abilities = {}

	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for power in gameDB:getResources("Power") do
		local isSameStyle = false
		local xp
		
		for action in brochure:findActionsByResource(power) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name:lower() == "activate" then
				for requirement in brochure:getRequirements(action) do
					local resource = brochure:getConstraintResource(requirement)
					if resource.name == style then
						isSameStyle = true
						xp = requirement.count
						break
					end
				end
			end

			if isSameStyle then
				break
			end
		end

		if isSameStyle then
			if self:getPeep():getState():count("Skill", style) >= xp then
				table.insert(abilities, {
					index = power.id.value,
					id = power.name,
					name = Utility.getName(power, gameDB) or "*" .. power.name,
					description = Utility.getDescription(power, gameDB),
					level = Curve.XP_CURVE:getLevel(xp)
				})
			end
		end
	end

	table.sort(abilities, function(a, b)
			if a.level < b.level then
				return true
			elseif a.level == b.level then
				return a.index < b.index
			else
				return false
			end
		end)

	table.insert(abilities, 1, index)

	local ui = self:getDirector():getGameInstance():getUI()
	ui:sendPoke(
		self,
		"bindAbility",
		nil,
		abilities)
end

function StrategyBarController:unbind(e)
	assert(type(e.index) == 'number', "index must be number")
	assert(e.index >= 1, "index must be greater than zero")
	assert(e.index <= StrategyBarController.MAX_STRIP_SIZE, "index must be less than max strip size")

	self.powers[e.index] = nil

	self:savePowers()
end

function StrategyBarController:bind(e)
	assert(type(e.index) == 'number', "index must be number")
	assert(e.index >= 1, "index must be greater than zero")
	assert(e.index <= StrategyBarController.MAX_STRIP_SIZE, "index must be less than max strip size")

	self.powers[e.index] = {
		type = "Power", id = e.ability
	}

	self:savePowers()
end

function StrategyBarController:updateStyle()
	local peep = self:getPeep()

	local oldStyle = self.style
	self.style = nil

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
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
		self:loadPowers()
	end
end

function StrategyBarController:updateState()
	local gameDB = self:getDirector():getGameDB()
	local peep = self:getPeep()

	self:updateStyle()

	local result = { style = self.style, powers = {} }
	for i = 1, StrategyBarController.MAX_STRIP_SIZE do
		local p = self.powers[i]
		if p then
			result.powers[i] = {
				type = p.type,
				id = p.id
			}
		end
	end

	local b = peep:getBehavior(PowerCoolDownBehavior)
	if not b then
		peep:addBehavior(PowerCoolDownBehavior)
		b = peep:getBehavior(PowerCoolDownBehavior)
	end

	local pending = peep:getBehavior(PendingPowerBehavior)
	if b then
		local time = self:getGame():getCurrentTick() * self:getGame():getDelta()
		for i = 1, StrategyBarController.MAX_STRIP_SIZE do
			local p = result.powers[i]
			if p then
				if p.type == "Power" then
					local resource = gameDB:getResource(p.id, "Power")
					if b.powers[resource.id.value] then
						local coolDown = b.powers[resource.id.value] - time
						if coolDown > 0 then
							result.powers[i].coolDown = math.floor(coolDown)
						end
					end

					local coolDownDescription
					do
						local PowerType = Utility.Peep.getPowerType(resource, gameDB)
						local power = PowerType(self:getGame(), resource)
						coolDownDescription = string.format("Cooldown: %d seconds", power:getCoolDown(self:getPeep()))
					end

					p.description = {
						Utility.getDescription(resource, gameDB),
						coolDownDescription
					}

					p.name = Utility.getName(resource, gameDB) or ("*" .. resource.name)

					if pending and
					   pending.power and
					   p.id == pending.power:getResource().name
					then
						result.pending = i
					end
				end
			end
		end
	end

	self.state = result
end

function StrategyBarController:update(delta)
	Controller.update(self, delta)

	self:updateState()
end

return StrategyBarController
