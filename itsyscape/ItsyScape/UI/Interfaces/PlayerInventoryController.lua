--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerInventoryController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local PlayerInventoryController = Class(Controller)

function PlayerInventoryController:new(peep, director)
	Controller.new(self, peep, director)

	self.numItems = 0
end

function PlayerInventoryController:poke(actionID, actionIndex, e)
	if actionID == "swap" then
		self:swap(e)
	elseif actionID == "drop" then
		self:drop(e)
	elseif actionID == "poke" then
		self:pokeItem(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerInventoryController:pull()
	local inventory = self:getPeep():getBehavior(InventoryBehavior)

	local result = { items = {} }
	if inventory then
		local broker = inventory.inventory:getBroker()
		for key in broker:keys(inventory.inventory) do
			for item in broker:iterateItemsByKey(inventory.inventory, key) do
				local resultItem = self:pullItem(item)
				self:pullActions(item, resultItem)
				result.items[key] = resultItem
				break
			end
		end
	end

	return result
end

function PlayerInventoryController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()

	return result
end

function PlayerInventoryController:pullActions(item, serializedItem)
	serializedItem.actions = {}

	-- Noted items don't have actions.
	if item:isNoted() then
		return
	end

	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		local brochure = self:getDirector():getGameDB():getBrochure()
		for action in brochure:findActionsByResource(itemResource) do
			local definition = brochure:getActionDefinitionFromAction(action)
			local typeName = string.format("Resources.Game.Actions.%s", definition.name)
			local s, r = pcall(require, typeName)
			if not s then
				Log.error("failed to load action %s: %s", typeName, r)
			else
				local ActionType = r
				if ActionType.SCOPES and ActionType.SCOPES['inventory'] then
					local a = ActionType(self:getDirector():getGameDB(), action)
					local t = {
						id = action.id.value,
						type = definition.name,
						verb = a:getVerb() or a:getName()
					}

					table.insert(serializedItem.actions, t)
				end
			end
		end
	end
end

function PlayerInventoryController:pokeItem(e)
	assert(type(e.index) == 'number', "index is not number")
	assert(type(e.id) == 'number', "id is not number")

	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			local broker = inventory.inventory:getBroker()

			for i in broker:iterateItemsByKey(inventory.inventory, e.index) do
				item = i
				break
			end
		end
	end

	if not item then
		Log.error("no item at index %d", e.index)
		return false
	end

	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		local brochure = self:getDirector():getGameDB():getBrochure()
		local foundAction = false
		for action in brochure:findActionsByResource(itemResource) do
			if action.id.value == e.id then
				local definition = brochure:getActionDefinitionFromAction(action)
				local typeName = string.format("Resources.Game.Actions.%s", definition.name)
				local s, r = pcall(require, typeName)
				if not s then
					Log.error("failed to load action %s: %s", typeName, r)
				else
					local ActionType = r
					if ActionType.SCOPES and ActionType.SCOPES['inventory'] then
						local a = ActionType(self:getDirector():getGameDB(), action)
						a:perform(nil, item, self:getPeep())

						foundAction = true
					else
						Log.error(
							"action %s cannot be performed from inventory (on item %s @ %d)",
							typeName,
							item:getID(),
							e.index)
					end
				end
			end
		end

		if not foundAction then
			Log.error(
				"action #%d not found (on item %s @ %d)",
				e.id,
				item:getID(),
				e.index)
		end
	end
end

function PlayerInventoryController:swap(e)
	assert(type(e.a) == 'number', "a is not number")
	assert(type(e.b) == 'number', "b is not number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		local broker = inventory.inventory:getBroker()

		local item1
		for item in broker:iterateItemsByKey(inventory.inventory, e.a) do
			item1 = item
			break
		end

		local item2
		for item in broker:iterateItemsByKey(inventory.inventory, e.b) do
			item2 = item
			break
		end

		if item1 then
			broker:setItemKey(item1, e.b)
		end

		if item2 then
			broker:setItemKey(item2, e.a)
		end
	end
end

function PlayerInventoryController:drop(e)
	assert(type(e.index) == 'number', "index is not number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior).inventory
	if inventory then
		local broker = inventory:getBroker()
		local item
		for i in broker:iterateItemsByKey(inventory, e.index) do
			item = i
			break
		end

		if item then
			local game = self.director:getGameInstance()
			game:getStage():dropItem(item, item:getCount())
		end
	end
end

function PlayerInventoryController:update(delta)
	Controller.update(delta)

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		local count = inventory.inventory:getMaxInventorySpace()
		if count >= 0 and count < math.huge then
			if count ~= self.numItems then
				self:getDirector():getGameInstance():getUI():sendPoke(
					self,
					"setNumItems",
					nil,
					{ count })
				self.numItems = count
			end
		end
	end
end

return PlayerInventoryController
