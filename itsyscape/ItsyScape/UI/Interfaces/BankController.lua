--------------------------------------------------------------------------------
-- ItsyScape/UI/BankController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local sort = require "batteries.sort"
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local BankController = Class(Controller)

function BankController:new(peep, director)
	Controller.new(self, peep, director)

	self.meta = {}
	self.query = ""
	self:refresh()

	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"hide",
		nil,
		{})
end

function BankController:getBankStorage()
	local playerStorage = Utility.Peep.getStorage(self:getPeep())
	local filterStorage = playerStorage:getSection("Bank")
	return filterStorage
end

function BankController:refresh()
	self.state = {
		items = {},
		inventory = {},
		filters = {}
	}

	self.items = {
		inventory = {},
		bank = {},
		filters = {}
	}

	self:refreshInventories()
	self:refreshSections()
	self:populateStateWithItems()
end

function BankController:refreshInventories()
	local broker = self:getDirector():getItemBroker() 
	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory then
		if inventory.bank then
			local storage = inventory.bank
			for item in broker:iterateItems(storage) do
				table.insert(self.items.bank, item)
			end

			self.state.items.max = #self.state.items
		end

		if inventory.inventory then
			local storage = inventory.inventory
			for key in broker:keys(storage) do
				for item in broker:iterateItemsByKey(storage, key) do
					local serializedItem = self:pullItem(item, true)
					self.state.inventory[key] = serializedItem
					self.items.inventory[key] = item
					break
				end
			end

			self.state.inventory.max = storage:getMaxInventorySpace()
		end
	end
end

function BankController:refreshSections()
	self.state.sections = self:getBankStorage():getSection("sections"):get()
end

function BankController:populateStateWithItems()
	local broker = self:getDirector():getItemBroker() 
	self.state.items = {}

	if self.currentSectionIndex and self.currentTabIndex then
		local items = self:performQuery(self.currentSectionIndex, self.currentTabIndex)

		for i = 1, #items do
			local item = items[i].item
			local serializedItem = items[i].meta
			serializedItem.physicalIndex = items[i].physicalIndex
			serializedItem.disabled = not items[i].available

			table.insert(self.state.items, serializedItem)
		end

		self.state.items = self:filterItems(self.state.items)
	else
		local items = self.items.bank

		for i = 1, #items do
			local item = items[i]
			local serializedItem = self:pullItem(item, false)
			serializedItem.physicalIndex = i
			table.insert(self.state.items, serializedItem)
		end

		self.state.items = self:filterItems(self.state.items)
	end

	self.state.items.max = #self.state.items
end

function BankController:pullItemMeta(itemID)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(itemID, "Item")

	meta = {}
	meta.id = itemID
	meta.count = 0
	meta.available = false
	meta.name = Utility.getName(itemResource, gameDB)
	meta.description = Utility.getDescription(itemResource, gameDB)

	return meta
end

function BankController:searchForItem(tab, itemID)
	if tab[itemID] then
		for i = 1, #tab do
			if tab[i] == itemID then
				return true, i
			end
		end
	end

	return false, nil
end

function BankController:pullItemQueryMeta(itemID)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(itemID, "Item")

	local meta = {
		id = itemID,
		tags = {},
		actions = {},
		name = "",
		description = ""
	}

	if not itemResource then
		return meta
	end

	meta.actions = Utility.getActions(self:getDirector():getGameInstance(), itemResource)

	local categories = gameDB:getRecords("ResourceCategory", { Resource = itemResource })
	for i = 1, #categories do
		table.insert(meta.tags, categories[i]:get("Value"))
	end

	local tags = gameDB:getRecords("ResourceTag", { Resource = itemResource })
	for i = 1, #tags do
		table.insert(meta.tags, tags[i]:get("Value"))
	end

	meta.name = Utility.getName(itemResource, gameDB)
	meta.description = Utility.getDescription(itemResource, gameDB)

	self.meta[itemID] = meta
	return meta
end

function BankController:performQueryOnItemDetail(pattern, itemDetail)
	pattern = pattern:lower()
	itemDetail = itemDetail:lower()

	local match = string.find(itemDetail, pattern)
	return match or false
end

function BankController:performQueryOnItem(query, itemID)
	local itemDetails = self.meta[itemID] or self:pullItemQueryMeta(itemID)

	local name = true
	if query.name then
		for i = 1, #query.name do
			local result = self:performQueryOnItemDetail(query.name[i].term, itemDetails.name)
			if query.name[i].flip then
				result = not result
			end

			name = name and result
		end
	end

	local description = true
	if query.description then
		for i = 1, #query.description do
			local result = self:performQueryOnItemDetail(query.description[i].term, itemDetails.description)
			if query.description[i].flip then
				result = not result
			end

			description = description and result
		end
	end

	local tag, action = nil, nil
	do
		if query.tag then
			for j = 1, #query.tag do
				local result

				for k = 1, #itemDetails.tags do
					result = self:performQueryOnItemDetail(query.tag[j].term, itemDetails.tags[k])
					if query.tag[j].flip then
						result = not result
					end

					if result then
						break
					end
				end

				if result ~= nil then
					if tag == nil then
						tag = result
					else
						tag = tag and result
					end
				end
			end

			tag = tag or false
		end

		if query.action then
			for j = 1, #query.action do
				local result
				for k = 1, #itemDetails.actions do
					result = self:performQueryOnItemDetail(query.action[j].term, itemDetails.actions[k].instance:getVerb() or itemDetails.actions[k].instance:getName())
					if query.action[j].flip then
						result = not result
					end

					if result then
						break
					end
				end

				if result ~= nil then
					if action == nil then
						action = result
					else
						action = action and result
					end
				end
			end

			action = action or false
		end
	end

	local isMatch = name and description and (tag == nil or tag) and (action == nil or action)
	return isMatch
end

local SANITIZE_CHARACTERS = {
	["%"] = true,
	["."] = true,
	["["] = true,
	["]"] = true,
	["^"] = true,
	["$"] = true,
	["*"] = true,
	["+"] = true,
	["-"] = true,
	["?"] = true,
}

function BankController:sanitizeQuery(query)
	return query:gsub(".", function(char)
		if SANITIZE_CHARACTERS[char] then
			return "%" .. char
		end
	end)
end

function BankController:buildQuery(query)
	local result = {}

	local function capture(keyword, invert, value)
		local t = { term = value, flip = invert == "!" }

		local key = keyword:lower()
		if result[key] then
			table.insert(result[key], key)
		else
			result[key] = { t }
		end

		return ""
	end

	query = self:sanitizeQuery(query)
	for keyword, invert, value in query:gmatch("(%w*)=(!?)\"([%w%s]-)\"") do
		capture(keyword, invert, value)
	end

	for keyword, invert, value in query:gmatch("(%w*)=(!?)(%w*)") do
		capture(keyword, invert, value)
	end

	query = query:gsub("(%w*=!?%w*)", "")
	query = query:gsub("(%w*=!?\"[%w%s]-\")", "")
	query = query:gsub("^%s*", "")
	query = query:gsub("%s*$", "")

	if query ~= "" then
		capture("name", "", query)
	end

	return result
end

function BankController:filterItems(items)
	local query = self.query
	if not query or query == "" then
		return items
	end

	query = self:buildQuery(query)

	local result = {}
	for i = 1, #items do
		if self:performQueryOnItem(query, items[i].id) then
			table.insert(result, items[i])
		end
	end

	return result
end

function BankController:performQuery(sectionIndex, tabIndex)
	local broker = self:getDirector():getItemBroker() 

	local tab = self.state.sections[sectionIndex][tabIndex]

	local items = {}
	for itemIndex = 1, #self.items.bank do
		local item = self.items.bank[itemIndex]
		local found, index = self:searchForItem(tab, item:getID())

		if found then
			item.available = true
			item.tabIndex = index

			table.insert(items, {
				item = item,
				meta = self:pullItem(item, false),
				available = true,
				tabIndex = index,
				physicalIndex = broker:getItemKey(item)
			})
		end
	end

	self:fillTabWithMissingItems(sectionIndex, tabIndex, items)
	self:sortTabItems(items)

	return items
end

function BankController:fillTabWithMissingItems(sectionIndex, tabIndex, items)
	local tab = self.state.sections[sectionIndex][tabIndex]

	for i = 1, #tab do
		local itemID = tab[i]

		local found = false
		for j = 1, #items do
			if items[j].item and items[j].item:getID() == itemID then
				found = true
				break
			end
		end

		if not found then
			local item = self:pullItemMeta(itemID)

			table.insert(items, {
				item = false,
				meta = item,
				available = false,
				physicalIndex = 0,
				tabIndex = i
			})
		end
	end
end

function BankController:sortTabItems(items)
	table.sort(items, function(a, b)
		if a.tabIndex < b.tabIndex then
			return true
		elseif a.tabIndex == b.tabIndex then
			return a.physicalIndex < b.physicalIndex
		end

		return false
	end)
end

function BankController:poke(actionID, actionIndex, e)
	if actionID == "swapInventory" then
		self:swapInventory(e)
	elseif actionID == "swapBank" then
		self:swapBank(e)
	elseif actionID == "insertBank" then
		self:insert(e)
	elseif actionID == "sortBank" then
		self:sortBank(e)
	elseif actionID == "withdraw" then
		self:withdraw(e)
	elseif actionID == "deposit" then
		self:deposit(e)
	elseif actionID == "addSection" then
		self:addSection(e)
	elseif actionID == "deleteSection" then
		self:deleteSection(e)
	elseif actionID == "addSectionTab" then
		self:addSectionTab(e)
	elseif actionID == "addItemToSectionTab" then
		self:addItemToSectionTab(e)
	elseif actionID == "removeItemFromSectionTab" then
		self:removeItemFromSectionTab(e)
	elseif actionID == "removeSectionTab" then
		self:removeSectionTab(e)
	elseif actionID == "renameSection" then
		self:renameSection(e)
	elseif actionID == "swapSection" then
		self:swapSection(e)
	elseif actionID == "openTab" then
		self:openTab(e)
	elseif actionID == "sortTab" then
		self:sortTab(e)
	elseif actionID == "closeTab" then
		self:closeTab(e)
	elseif actionID == "removeTab" then
		self:removeTab(e)
	elseif actionID == "search" then
		self:search(e)
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

function BankController:pullItem(item, includeNoted)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	if includeNoted then
		result.noted = item:isNoted()
	else
		result.noted = false
	end

	result.name = Utility.Item.getInstanceName(item)
	result.description = Utility.Item.getInstanceDescription(item)

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

	if self.currentSectionIndex and self.currentTabIndex then
		local sectionsStorage = self:getBankStorage():getSection("sections")
		local tabsStorage = sectionsStorage:getSection(self.currentSectionIndex)

		local tab = tabsStorage:get(self.currentTabIndex):get()

		assert(e.a >= 1, e.a <= #tab, "a is out of range")
		assert(e.b >= 1, e.b <= #tab, "b is out of range")

		tab[e.a], tab[e.b] = tab[e.b], tab[e.a]

		tabsStorage:set(self.currentTabIndex, tab)

		return
	end

	local physicalIndexA = self.state.items[e.a].physicalIndex
	local physicalIndexB = self.state.items[e.b].physicalIndex

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank then
		if e.tab < 1 then
			local broker = inventory.bank:getBroker()

			local item1
			for item in broker:iterateItemsByKey(inventory.bank, physicalIndexA) do
				item1 = item
				break
			end

			local item2
			for item in broker:iterateItemsByKey(inventory.bank, physicalIndexB) do
				item2 = item
				break
			end

			if item1 then
				broker:setItemKey(item1, physicalIndexB)
				broker:setItemZ(item1, physicalIndexB)
			end

			if item2 then
				broker:setItemKey(item2, physicalIndexA)
				broker:setItemZ(item2, physicalIndexA)
			end
		end
	end
end

function BankController:insert(e)
	assert(type(e.tab) == 'number', "tab is not a number")
	assert(type(e.a) == "number", "a is not a number")
	assert(type(e.b) == "number", "b is not a number")

	if self.currentSectionIndex and self.currentTabIndex then
		local sectionsStorage = self:getBankStorage():getSection("sections")
		local tabsStorage = sectionsStorage:getSection(self.currentSectionIndex)

		local tab = tabsStorage:get(self.currentTabIndex):get()

		assert(e.a >= 1, e.a <= #tab, "a is out of range")
		assert(e.b >= 1, e.b <= #tab, "b is out of range")

		local itemID = table.remove(tab, e.a)
		table.insert(tab, e.b, itemID)

		tabsStorage:set(self.currentTabIndex, tab)

		return
	end

	local physicalIndexA = self.state.items[e.a].physicalIndex
	local physicalIndexB = self.state.items[e.b].physicalIndex

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank then
		if e.tab < 1 then
			local broker = inventory.bank:getBroker()

			local item1
			for item in broker:iterateItemsByKey(inventory.bank, physicalIndexA) do
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
					if key >= physicalIndexA then
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
					if key >= physicalIndexB then
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
				broker:setItemKey(item1, physicalIndexB)
				broker:setItemZ(item1, physicalIndexB)
			end
		end
	end
end

function BankController:deposit(e)
	assert(type(e.index == "number"), "index is not a number")
	assert(type(e.count == "number"), "count is not a number")

	local item = self.items.inventory[e.index]

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank and inventory.inventory then
		if item then
			inventory.bank:deposit(item, e.count, true)
		end
	end

	if self.currentSectionIndex and self.currentTabIndex then
		local sectionsStorage = self:getBankStorage():getSection("sections")
		local tabsStorage = sectionsStorage:getSection(self.currentSectionIndex)
		local tabStorage = tabsStorage:getSection(self.currentTabIndex)

		if not tabStorage:get(item:getID()) then
			tabStorage:set(tabStorage:length() + 1, item:getID())
			tabStorage:set(item:getID(), true)
		end
	end
end

function BankController:withdraw(e)
	assert(type(e.index) == "number", "index is not a number")
	assert(type(e.count) == "number", "count is not a number")
	assert(type(e.noted) == "boolean", "noted is not a boolean")

	local physicalIndex = self.state.items[e.index].physicalIndex

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank and inventory.inventory then
		local item = self.items.bank[physicalIndex]
		if item then
			inventory.bank:withdraw(inventory.inventory, item:getID(), e.count, e.noted, true)
		end
	end
end

function BankController:addSection(e)
	assert(type(e.name) == "string", "name is not a string")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local length = sectionsStorage:length()

	sectionsStorage:set(length + 1, { name = e.name })
	self:refreshSections()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})
end

function BankController:removeSectionTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(e.sectionIndex <= #self.state.sections, "sectionIndex is greater than # of sections")
	assert(type(e.tabIndex) == "number", "tabIndex is not a number")
	assert(e.tabIndex >= 1, "tabIndex is less than or equal to zero")
	assert(e.tabIndex <= #self.state.sections[e.sectionIndex], "tabIndex is greater than # of sections")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local tabsStorage = sectionsStorage:getSection(e.sectionIndex)
	tabStorage:removeSection(e.tabIndex)

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})
end

function BankController:addSectionTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.itemIndex) == "number", "itemIndex is not number")
	assert(e.itemIndex >= 1, "itemIndex is less than 1")
	assert(e.itemIndex <= #self.state.items, "itemIndex is greater than # of items")

	local broker = self:getDirector():getItemBroker()

	local physicalIndex = self.state.items[e.itemIndex].physicalIndex

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local tabsStorage = sectionsStorage:getSection(e.sectionIndex)
	local tabIndex = tabsStorage:length() + 1

	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.bank then
			for i in broker:iterateItemsByKey(inventory.bank, physicalIndex) do
				item = i
				break
			end
		end
	end

	if not item then
		return
	end

	local tabStorage = tabsStorage:getSection(tabIndex)
	tabStorage:set(1, item:getID())
	tabStorage:set(item:getID(), true)

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})

	self:refreshSections()
end

function BankController:addItemToSectionTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.tabIndex) == "number", "tabIndex is not a number")
	assert(e.tabIndex >= 1, "tabIndex is less than or equal to zero")
	assert(type(e.itemIndex) == "number", "itemIndex is not number")
	assert(e.itemIndex >= 1, "itemIndex is less than 1")
	assert(e.itemIndex <= #self.state.items, "itemIndex is greater than # of items")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local tabsStorage = sectionsStorage:getSection(e.sectionIndex)
	local tabStorage = tabsStorage:getSection(e.tabIndex)

	local physicalIndex = self.state.items[e.itemIndex].physicalIndex

	local item
	do
		local broker = self:getDirector():getItemBroker() 
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.bank then
			for i in broker:iterateItemsByKey(inventory.bank, physicalIndex) do
				item = i
				break
			end
		end
	end

	if not item then
		return
	end

	if not tabStorage:get(item:getID()) then
		tabStorage:set(tabStorage:length() + 1, item:getID())
		tabStorage:set(item:getID(), true)
	end
end

function BankController:removeItemFromSectionTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.tabIndex) == "number", "tabIndex is not a number")
	assert(e.tabIndex >= 1, "tabIndex is less than or equal to zero")
	assert(type(e.itemIndex) == "number", "itemIndex is not number")
	assert(e.itemIndex >= 1, "itemIndex is less than 1")
	assert(e.itemIndex <= #self.state.items, "itemIndex is greater than # of items")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local tabsStorage = sectionsStorage:getSection(e.sectionIndex)
	local tabStorage = tabsStorage:getSection(e.tabIndex)

	local physicalIndex = self.state.items[e.itemIndex].physicalIndex

	local item
	do
		local broker = self:getDirector():getItemBroker() 
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.bank then
			for i in broker:iterateItemsByKey(inventory.bank, physicalIndex) do
				item = i
				break
			end
		end
	end

	if not item then
		return
	end

	if tabStorage:length() == 1 then
		tabsStorage:removeSection(e.tabIndex)
	else
		for i = 1, tabStorage:length() do
			if tabStorage:get(i) == item:getID() then
				tabStorage:set(i, nil)
				tabStorage:set(item:getID(), nil)
				break
			end
		end
	end

	self:refreshSections()
end

function BankController:renameSection(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.name) == "string", "name is not a string")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local sectionStorage = sectionsStorage:getSection(e.sectionIndex)

	sectionStorage:set("name", e.name)
	self:refreshSections()
end

function BankController:deleteSection(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	sectionsStorage:removeSection(e.sectionIndex)
	self:refreshSections()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})
end

function BankController:openTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.tabIndex) == "number", "tabIndex is not a number")
	assert(e.tabIndex >= 1, "tabIndex is less than or equal to zero")

	self.currentSectionIndex = e.sectionIndex
	self.currentTabIndex = e.tabIndex

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})
end

function BankController:_getItemRequirements(itemID)
	local itemRequirement = {
		maxEquipXP = 0,
		maxCraftXP = 0,
		maxEquipSkillName = "",
		maxCraftSkillName = "",
		equipSlotIndex = -1
	}

	local game = self:getGame()
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()

	local resource = gameDB:getResource(itemID, "Item")

	for action in brochure:findActionsByResource(resource) do
		local inventoryAction = Utility.getAction(game, action, 'inventory')
		local craftAction = Utility.getAction(game, action, 'craft')

		if inventoryAction and inventoryAction.instance:is("Equip") then
			local constraints = Utility.getActionConstraints(game, action)

			for j = 1, #constraints.requirements do
				if constraints.requirements[j].type:lower() == "skill" and constraints.requirements[j].resource:lower() ~= "defense" then
					if constraints.requirements[j].count > itemRequirement.maxEquipXP then
						itemRequirement.maxEquipXP = constraints.requirements[j].count
						itemRequirement.maxEquipSkillName = constraints.requirements[j].resource
					end
				end
			end

			local record = gameDB:getRecord("Equipment", {
				Resource = resource
			})

			if record then
				itemRequirement.equipSlotIndex = record:get("EquipSlot")
			end
		elseif craftAction then
			local constraints = Utility.getActionConstraints(game, action)

			for j = 1, #constraints.requirements do
				if constraints.requirements[j].type:lower() == "skill" then
					if constraints.requirements[j].count > itemRequirement.maxCraftXP then
						itemRequirement.maxCraftXP = constraints.requirements[j].count
						itemRequirement.maxCraftSkillName = constraints.requirements[j].resource
					end
				end
			end
		end
	end

	return itemRequirement
end

function BankController._compareItemSort(itemRequirements, a, b)
	local reqA = itemRequirements[a]
	local reqB = itemRequirements[b]

	if reqA.maxEquipSkillName < reqB.maxEquipSkillName then
		return true
	elseif reqA.maxEquipSkillName == reqB.maxEquipSkillName then
		if reqA.maxEquipXP > reqB.maxEquipXP then
			return true
		elseif reqA.maxEquipXP == reqB.maxEquipXP then
			if reqA.equipSlotIndex < reqB.equipSlotIndex then
				return true
			elseif reqA.equipSlotIndex == reqB.equipSlotIndex then
				if reqA.maxCraftSkillName < reqB.maxCraftSkillName then
					return true
				elseif reqA.maxCraftSkillName == reqB.maxCraftSkillName then
					if reqA.maxCraftXP > reqB.maxCraftXP then
						return true
					elseif reqA.maxCraftXP == reqB.maxCraftXP then
						return a < b
					end
				end
			end
		end
	end

	return false
end

function BankController:sortBank(e)
	local itemRequirements = {}

	for i = 1, #self.items.bank do
		local itemID = self.items.bank[i]:getID()
		if not itemRequirements[itemID] then
			itemRequirements[itemID] = self:_getItemRequirements(itemID)
		end
	end

	sort.stable_sort(self.items.bank, function(a, b)
		return BankController._compareItemSort(itemRequirements, a:getID(), b:getID())
	end)

	local broker = self:getDirector():getItemBroker()
	for i = 1, #self.items.bank do
		broker:setItemKey(self.items.bank[i], i)
		broker:setItemZ(self.items.bank[i], i)
	end
end

function BankController:sortTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.tabIndex) == "number", "tabIndex is not a number")
	assert(e.tabIndex >= 1, "tabIndex is less than or equal to zero")

	local game = self:getGame()
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local tabsStorage = sectionsStorage:getSection(e.sectionIndex)

	local tab = tabsStorage:get(e.tabIndex):get()

	local itemRequirements = {}

	for i = 1, #tab do
		local itemID = tab[i]
		itemRequirements[itemID] = self:_getItemRequirements(itemID)
	end

	sort.stable_sort(tab, function(a, b)
		local r = BankController._compareItemSort(itemRequirements, a, b)
		return r
	end)

	tabsStorage:set(e.tabIndex, tab)
end

function BankController:closeTab(e)
	self.currentSectionIndex = nil
	self.currentTabIndex = nil

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})
end

function BankController:removeTab(e)
	assert(type(e.sectionIndex) == "number", "sectionIndex is not a number")
	assert(e.sectionIndex >= 1, "sectionIndex is less than or equal to zero")
	assert(type(e.tabIndex) == "number", "tabIndex is not a number")
	assert(e.tabIndex >= 1, "tabIndex is less than or equal to zero")

	local sectionsStorage = self:getBankStorage():getSection("sections")
	local sectionStorage = sectionsStorage:getSection(e.sectionIndex)
	sectionStorage:removeSection(e.tabIndex)
	self:refreshSections()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateSections",
		nil,
		{})
end

function BankController:search(e)
	assert(type(e.query) == "nil" or type(e.query) == "string", "expected string or nil for search query")

	self.query = e.query or ""
end

function BankController:update(delta)
	Controller.update(delta)
end

return BankController
