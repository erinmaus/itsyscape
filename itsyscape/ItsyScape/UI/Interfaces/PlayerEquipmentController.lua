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

	local result = { items = {} }
	if equipment then
		local broker = equipment.equipment:getBroker()
		for key in broker:keys(equipment.equipment) do
			for item in broker:iterateItemsByKey(equipment.equipment, key) do
				local resultItem = self:pullItem(item)
				self:pullActions(item, resultItem)
				result.items[key] = resultItem
				break
			end
		end
	end

	return result
end

function PlayerEquipmentController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()

	return result
end

function PlayerEquipmentController:pullActions(item, serializedItem)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		serializedItem.actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			'equipment')
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
			self:getPeep():getState(), item, self:getPeep())

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
