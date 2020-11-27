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

	self.meta = {}
end

function BankController:getBankStorage()
	local playerStorage = Utility.Peep.getStorage(self:getPeep())
	local filterStorage = playerStorage:getSection("Bank")
	return filterStorage
end

function BankController:refresh()
	self.state = {
		items = {},
		tabs = {},
		inventory = {},
		filters = {}
	}

	self.items = {
		inventory = {},
		bank = {},
		filters = {}
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

	self:refreshFilters()
	self:refreshQueries()
end

function BankController:refreshFilters()
	self.state.filters = self:getBankStorage():getSection("filters"):get()
	print(require("ItsyScape.Common.StringBuilder").stringifyTable(self.state.filters))
end

function BankController:addFilterQueryResult(sectionIndex, filterIndex, items)
	local item = "Null"
	if #items >= 0 then
		item = items[1]:getID()
	end

	local filterStorage = self:getBankStorage():getSection("filters")
	local filter = filterStorage:getSection(sectionIndex):getSection(filterStorage)
	filter:set("item", item)
end

function BankController:refreshQueries()
	for i = 1, #self.state.filters do
		for j = 1, #self.state.filters[j] do
			local items = self:performQuery(i, j)
			self:addFilterQueryResult(i, j, items)
		end
	end

	self:refreshFilters()
end

function BankController:pullItemMeta(itemID)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(itemID, "Item")

	local meta = {
		tags = {},
		actions = {}
	}

	if not itemResource then
		return meta
	end

	meta.actions = Utility.getActions(self:getDirector():getGameInstance(), itemResource)

	local categories = gameDB:getRecords("ResourceCategory", { Resource = itemResource })
	for i = 1, #categories do
		table.insert(meta.tags, categories[i]:get("Value"))
	end

	local tags = gameDB:getRecords("ResourceCategory", { Resource = itemResource })
	for i = 1, #tags do
		table.insert(meta.tags, tags[i]:get("Value"))
	end

	meta.name = Utility.getName(itemResource, gameDB)
	meta.description = Utility.getDescription(itemResource, itemResource, gameDB)

	self.meta[itemID] = meta
	return meta
end

function BankController:performQueryOnItemDetail(perform, pattern, itemDetail)
	if not perform then
		return true
	end

	pattern = pattern:lower()
	itemDetail = itemDetail:lower()

	local s, m1 = pcall(string.match, itemDetail, pattern)
	local m2 = string.find(itemDetail, pattern)

	return m1 or m2
end

function BankController:performQueryOnItem(queryOps, itemID)
	local itemDetails = self.meta[itemID] or self:pullItemMeta(itemID)

	for i = 1, #queryOps do
		local query = queryOps[i]
		local term = query.term

		local n = self:performQueryOnItemDetail(query.name, term, itemDetails.name)
		local d = self:performQueryOnItemDetail(query.description, term, itemDetails.description)
		local k, a = nil, nil

		if n or d then
			if query.keyword then
				for i = 1, #itemDetails.tags do
					k = k or self:performQueryOnItemDetail(true, term, itemDetails.tags[i])
					if k then
						break
					end
				end
			end

			if query.action then
				for i = 1, #itemDetails.actions do
					local action = itemDetails.actions[i].verb
					a = a or self:performQueryOnItemDetail(true, term, action)
					if a then
						break
					end
				end
			end
		end

		local isMatch = n and d and (k == nil or k) and (a == nil or a)
		if query.flip then
			isMatch = not isMatch
		end

		if not isMatch then
			return false
		end
	end

	return true
end

function BankController:performQuery(sectionIndex, queryIndex)
	local query = self.state.filters[sectionIndex][queryIndex]

	local items = {}
	for queryIndex = 1, #query do
		for itemIndex, #self.items.bank do
			local item = self.items.bank[itemIndex]
			if self:performQueryOnItem(query[queryIndex], item:getID()) then
				table.insert(items, item)
			end
		end
	end

	return items
end

function BankController:poke(actionID, actionIndex, e)
	print('action', actionID)

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
	elseif actionID == "addSection" then
		self:addSection(e)
	elseif actionID == "deleteSection" then
		self:deleteSection(e)
	elseif actionID == "addSectionQuery" then
		self:addSectionQuery(e)
	elseif actionID == "renameSection" then
		self:renameSection(e)
	elseif actionID == "swapSection" then
		self:swapSection(e)
	elseif actionID == "editFilter" then
		self:editFilter(e)
	elseif actionID == "removeFilter" then
		self:removeFilter(e)
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

function BankController:addSection(e)
	assert(type(e.name) == "string", "name is not a string")

	local filterStorage = self:getBankStorage():getSection("filters")
	local length = filterStorage:length()

	filterStorage:set(length + 1, { name = e.name })
	self:refreshFilters()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateFilters",
		nil,
		{})
end

function BankController:addSectionQuery(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")

	local filterStorage = self:getBankStorage():getSection("filters")
	local queriesStorage = filterStorage:getSection(e.sectionIndex)
	local queryIndex = queriesStorage:length() + 1

	queriesStorage:set(queryIndex, {
		item = "Null",
		{
			term = "Potato",
			name = false,
			keyword = false,
			description = false,
			action = false,
			flip = false
		}
	})
	self:refreshFilters()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateFilters",
		nil,
		{})
	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"openFilterEdit",
		nil,
		{ e.sectionIndex, queryIndex })
end

function BankController:renameSection(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.name) == "string", "name is not a string")

	local filterStorage = self:getBankStorage():getSection("filters")
	local sectionStorage = filterStorage:getSection(e.sectionIndex)

	sectionStorage:set('name', e.name)
	self:refreshFilters()
end

function BankController:deleteSection(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")

	local filterStorage = self:getBankStorage():getSection("filters")
	filterStorage:removeSection(e.sectionIndex)
	self:refreshFilters()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateFilters",
		nil,
		{})
end

function BankController:editFilter(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.queryIndex) == "number", "queryIndex is not a number")
	assert(e.queryIndex >= 1, "queryIndex is less than or equal to zero")
	assert(type(e.query) == "table", "query is not a table")

	local filterStorage = self:getBankStorage():getSection("filters")
	local sectionStorage = filterStorage:getSection(e.sectionIndex)
	sectionStorage:set(e.queryIndex, e.query)
	self:refreshFilters()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"openFilterEdit",
		nil,
		{ e.sectionIndex, e.queryIndex })
end

function BankController:removeFilter(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.queryIndex) == "number", "queryIndex is not a number")
	assert(e.queryIndex >= 1, "queryIndex is less than or equal to zero")

	local filterStorage = self:getBankStorage():getSection("filters")
	local sectionStorage = filterStorage:getSection(e.sectionIndex)
	sectionStorage:removeSection(e.queryIndex)
	self:refreshFilters()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateFilters",
		nil,
		{})
end


function BankController:update(delta)
	Controller.update(delta)
end

return BankController
