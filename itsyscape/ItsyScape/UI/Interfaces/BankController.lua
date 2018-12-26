--------------------------------------------------------------------------------
-- ItsyScape/UI/BankController.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local BankController = Class(Controller)

function BankController:new(peep, director)
	Controller.new(self, peep, director)

	self:refresh()

	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"hide",
		nil,
		{})
end

function BankController:refresh()
	self.state = {
		items = {},
		tabs = {},
		inventory = {}
	}


	self.items = {
		inventory = {},
		bank = {}
	}

	local tabs = {}

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory then
		local broker = self:getDirector():getItemBroker() 
		if inventory.bank then
			local storage = inventory.bank
			for item in broker:iterateItems(storage) do
				local serializedItem = self:pullItem(item, false)
				self:pullActions(item, serializedItem)
				table.insert(self.state.items, serializedItem)
				table.insert(self.items.bank, item)
			end

			self.state.items.max = #self.state.items
		end

		if inventory.inventory then
			local storage = inventory.inventory
			for key in broker:keys(storage) do
				for item in broker:iterateItemsByKey(storage, key) do
					local serializedItem = self:pullItem(item, true)
					self:pullActions(item, serializedItem)

					self.state.inventory[key] = serializedItem
					self.items.inventory[key] = item
					break
				end
			end

			self.state.inventory.max = storage:getMaxInventorySpace()
		end
	end
end

function BankController:poke(actionID, actionIndex, e)
	if actionID == "swapInventory" then
		self:swapInventory(e)
	elseif actionID == "swapBank" then
		self:swapBank(e)
	elseif actionID == "insertBank" then
		self:insert(e)
	elseif actionID == "withdraw" then
		self:withdraw(e)
	elseif actionID == "deposit" then
		self:deposit(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
		return
	end

	self:refresh()
end

function BankController:pull()
	return self.state
end

function BankController:close()
	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"show",
		nil,
		{})
end

function BankController:pullActions(item, serializedItem)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		serializedItem.actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			'bank')
	else
		serializedItem.actions = {}
	end
end

function BankController:pullItem(item, includeNoted)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	if includeNoted then
		result.noted = item:isNoted()
	else
		result.noted = false
	end

	return result
end

function BankController:swapInventory(e)
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
			broker:setItemZ(item1, e.b)
		end

		if item2 then
			broker:setItemKey(item2, e.a)
			broker:setItemZ(item2, e.a)
		end
	end
end

function BankController:swapBank(e)
	assert(type(e.tab) == 'number', "tab is not a number")
	assert(type(e.a) == "number", "a is not a number")
	assert(type(e.b) == "number", "b is not a number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank then
		if e.tab < 1 then
			local broker = inventory.bank:getBroker()

			local item1
			for item in broker:iterateItemsByKey(inventory.bank, e.a) do
				item1 = item
				break
			end

			local item2
			for item in broker:iterateItemsByKey(inventory.bank, e.b) do
				item2 = item
				break
			end

			if item1 then
				broker:setItemKey(item1, e.b)
				broker:setItemZ(item1, e.b)
			end

			if item2 then
				broker:setItemKey(item2, e.a)
				broker:setItemZ(item2, e.a)
			end
		end
	end
end

function BankController:insert(e)
	assert(type(e.tab) == 'number', "tab is not a number")
	assert(type(e.a) == "number", "a is not a number")
	assert(type(e.b) == "number", "b is not a number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank then
		if e.tab < 1 then
			local broker = inventory.bank:getBroker()

			local item1
			for item in broker:iterateItemsByKey(inventory.bank, e.a) do
				item1 = item
				break
			end

			if item1 then
				broker:setItemKey(item1, -1)
				broker:setItemZ(item1, -1)
			end

			do
				local items = {}
				for key in broker:keys(inventory.bank) do
					if key >= e.a then
						for item in broker:iterateItemsByKey(inventory.bank, key) do
							table.insert(items, { item = item, key = key })
						end
					end
				end

				for i = 1, #items do
					broker:setItemKey(items[i].item, items[i].key - 1)
					broker:setItemZ(items[i].item, items[i].key - 1)
				end
			end

			do
				local items = {}
				for key in broker:keys(inventory.bank) do
					if key >= e.b then
						for item in broker:iterateItemsByKey(inventory.bank, key) do
							table.insert(items, { item = item, key = key })
						end
					end
				end

				for i = 1, #items do
					broker:setItemKey(items[i].item, items[i].key + 1)
					broker:setItemZ(items[i].item, items[i].key + 1)
				end
			end

			if item1 then
				broker:setItemKey(item1, e.b)
				broker:setItemZ(item1, e.b)
			end
		end
	end
end

function BankController:deposit(e)
	assert(type(e.index == "number"), "index is not a number")
	assert(type(e.count == "number"), "count is not a number")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank and inventory.inventory then
		local item = self.items.inventory[e.index]
		if item then
			inventory.bank:deposit(item, e.count, true)
		end
	end
end

function BankController:withdraw(e)
	assert(type(e.index) == "number", "index is not a number")
	assert(type(e.count) == "number", "count is not a number")
	assert(type(e.noted) == "boolean", "noted is not a boolean")

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank and inventory.inventory then
		local item = self.items.bank[e.index]
		if item then
			inventory.bank:withdraw(inventory.inventory, item:getID(), e.count, e.noted, true)
		end
	end
end

function BankController:update(delta)
	Controller.update(delta)
end

return BankController
