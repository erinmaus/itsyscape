--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerEquipmentController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"

local PlayerEquipmentController = Class(Controller)

function PlayerEquipmentController:new(peep, director)
	Controller.new(self, peep, director)
end

function PlayerEquipmentController:poke(actionID, actionIndex, e)
	if actionID == "swap" then
		self:swap(e)
	elseif actionID == "poke" then
		self:pokeItem(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerEquipmentController:pull()
	local equipment = self:getPeep():getBehavior(EquipmentBehavior)

	local result = { items = {}, stats = {} }
	if equipment and equipment.equipment then
		local broker = equipment.equipment:getBroker()
		if not broker then
			Log.error("Broker not found.")
			return result
		end

		for key in broker:keys(equipment.equipment) do
			for item in broker:iterateItemsByKey(equipment.equipment, key) do
				local resultItem = self:pullItem(item)
				self:pullActions(item, resultItem)

				if key == Equipment.PLAYER_SLOT_TWO_HANDED then
					key = Equipment.PLAYER_SLOT_RIGHT_HAND
				end
				
				result.items[key] = resultItem
				break
			end
		end

		for name, value in equipment.equipment:getStats() do
			result.stats[name] = value
		end
	end

	return result
end

function PlayerEquipmentController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()
	result.name = Utility.Item.getInstanceName(item)
	result.description = Utility.Item.getInstanceDescription(item)

	return result
end

function PlayerEquipmentController:pullActions(item, serializedItem)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		serializedItem.actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			'equipment',
			true)
	else
		serializedItem.actions = {}
	end
end

function PlayerEquipmentController:pokeItem(e)
	assert(type(e.index) == 'number', "index is not number")
	assert(type(e.id) == 'number', "id is not number")

	local item
	do
		local equipment = self:getPeep():getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			local broker = equipment.equipment:getBroker()

			for i in broker:iterateItemsByKey(equipment.equipment, e.index) do
				item = i
				break
			end

			if not item and e.index == Equipment.PLAYER_SLOT_RIGHT_HAND then
				for i in broker:iterateItemsByKey(equipment.equipment, Equipment.PLAYER_SLOT_TWO_HANDED) do
					item = i
					break
				end
			end
		end
	end

	if not item then
		Log.error("no item at index %d", e.index)
		return false
	end

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		local success = Utility.performAction(
			self:getGame(),
			itemResource,
			e.id,
			'equipment',
			self:getPeep():getState(), self:getPeep(), item)

		if not success then
			Log.error(
				"action #%d not found (on item %s @ %d)",
				e.id,
				item:getID(),
				e.index)
		end
	end
end

return PlayerEquipmentController
