--------------------------------------------------------------------------------
-- ItsyScape/UI/ShopWindowController.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local ShopWindowController = Class(Controller)

function ShopWindowController:new(peep, director, shop)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	self.state = { inventory = {} }
	self.inventoryByID = {}
	self.shop = shop or false

	if self.shop then
		for action in brochure:findActionsByResource(shop) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			local a, ActionType = Utility.getAction(game, action, 'buy', true)
			if a and ActionType then
				local actionInstance = ActionType(game, action)
				if actionInstance:is('buy') then
					a.count = actionInstance:count(peep:getState(), flags)
					table.insert(self.state.inventory, a)

					self.inventoryByID[a.id] = actionInstance
				end
			end
		end

		local meta = gameDB:getRecord("Shop", {
			Resource = self.shop
		})

		if meta then
			self.currency = meta:get("Currency")
			self.exchangeRate = meta:get("ExchangeRate")
		else
			self.currency = gameDB:getResource("Coins", "Item")
			self.exchangeRate = 0.1
		end
	end
end

function ShopWindowController:poke(actionID, actionIndex, e)
	if actionID == "buy" then
		self:buy(e)
	elseif actionID == "sell" then
		self:sell(e)
	elseif actionID == "selectInventory" then
		self:selectInventory(e)
	elseif actionID == "selectShop" then
		self:selectShop(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ShopWindowController:pull()
	local state = { inventory = self.state.inventory }
	state.playerInventory = {}

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory.inventory then
		local broker = self:getDirector():getItemBroker() 
		local storage = inventory.inventory
		for key in broker:keys(storage) do
			for item in broker:iterateItemsByKey(storage, key) do
				local serializedItem = self:pullItem(item, true)

				if serializedItem.id ~= self.currency.name then
					state.playerInventory[key] = serializedItem
				end

				break
			end
		end

		state.playerInventory.max = storage:getMaxInventorySpace()
	end

	return state
end

function ShopWindowController:buy(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.inventoryByID[e.id] ~= nil, "action with ID not found")
	assert(type(e.count) == "number", "count must be number")

	if e.count < 0 then
		return
	end

	local action = self.inventoryByID[e.id]
	local player = self:getPeep()
	local count = math.min(action:count(player:getState(), player), e.count)

	action:perform(player:getState(), player, e.count)
end

function ShopWindowController:selectShop(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.inventoryByID[e.id] ~= nil, "action with ID not found")

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.inventoryByID[e.id]:getAction()
	local result = {}
	do
		result.requirements = {}
		for requirement in brochure:getRequirements(action) do
			local resource = brochure:getConstraintResource(requirement)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			table.insert(
				result.requirements,
				{
					type = resourceType.name,
					resource = resource.name,
					name = Utility.getName(resource, gameDB) or resource.name,
					count = requirement.count
				})
		end
	end
	do
		result.inputs = {}
		for input in brochure:getInputs(action) do
			local resource = brochure:getConstraintResource(input)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			table.insert(
				result.inputs,
				{
					type = resourceType.name,
					resource = resource.name,
					name = Utility.getName(resource, gameDB) or resource.name,
					count = input.count
				})
		end
	end
	do
		result.outputs = {}
		for output in brochure:getOutputs(action) do
			local resource = brochure:getConstraintResource(output)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			table.insert(
				result.outputs,
				{
					type = resourceType.name,
					resource = resource.name,
					name = Utility.getName(resource, gameDB) or resource.name,
					count = output.count
				})
		end
	end

	director:getGameInstance():getUI():sendPoke(
		self,
		"populateRequirements",
		nil,
		{ result })
end

function ShopWindowController:pullInventoryItemByIndex(index)
	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory
	else
		return
	end

	local broker = inventory:getBroker()
	local item
	for i in broker:iterateItemsByKey(inventory, index) do
		item = i
		break
	end

	if item then
		local value
		do
			local gameDB = self:getDirector():getGameDB()
			local meta = gameDB:getRecord("Item", {
				Resource = gameDB:getResource(item:getID(), "Item")
			})

			if meta and meta:get("Untradeable") ~= 0 then
				return nil, nil
			end

			value = math.max((meta and meta:get("Value")) or 1, 1)
		end

		return item, value
	end

	return nil, nil
end

function ShopWindowController:pullInventoryItemByID(itemID, noted)
	noted = noted or false

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory
	else
		return
	end

	local broker = inventory:getBroker()
	local item
	for i in broker:iterateItems(inventory) do
		if i:getID() == itemID and i:isNoted() == noted then
			item = i
			break
		end
	end

	if item then
		local value
		do
			local gameDB = self:getDirector():getGameDB()
			local meta = gameDB:getRecord("Item", {
				Resource = gameDB:getResource(item:getID(), "Item")
			})

			if meta and meta:get("Untradeable") ~= 0 then
				return nil, nil
			end

			value = math.max((meta and meta:get("Value")) or 1, 1)
		end

		return item, value
	end

	return nil, nil
end

function ShopWindowController:selectInventory(e)
	assert(type(e.index) == "number", "index must be number")

	local item, value = self:pullInventoryItemByIndex(e.index)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local result = { inputs = {}, outputs = {}, requirements = {} }
	if item then
		table.insert(result.inputs, {
			type = "Item",
			resource = item:getID(),
			name = Utility.getName(gameDB:getResource(item:getID(), "Item"), gameDB) or item:getID(),
			count = 1
		})

		table.insert(result.outputs, {
			type = "Item",
			resource = self.currency.name,
			name = Utility.getName(self.currency, gameDB) or self.currency.name,
			count = math.ceil(value * self.exchangeRate)
		})
	end

	director:getGameInstance():getUI():sendPoke(
		self,
		"populateRequirements",
		nil,
		{ result })
end

function ShopWindowController:sell(e)
	assert(type(e.index) == "number", "index must be number")
	assert(type(e.count) == "number", "count must be number")

	if e.count <= 0 then
		return
	end

	local itemID
	local isNoted

	local count = e.count
	while count > 0 do
		local item, value = self:pullInventoryItemByIndex(e.index)
		if not item then
			if not itemID then
				break
			end

			item, value = self:pullInventoryItemByID(itemID, isNoted)
		else
			itemID = item:getID()
			isNoted = item:isNoted()
		end

		if item and value then
			local itemCount = item:getCount()
			if itemCount == 0 then
				return
			end

			local inventory = self:getPeep():getBehavior(InventoryBehavior)
			if inventory and inventory.inventory then
				inventory = inventory.inventory
			else
				return
			end

			local broker = inventory:getBroker()
			do
				local c = math.min(count, itemCount)

				local transaction = broker:createTransaction()
				transaction:addParty(inventory)
				transaction:consume(item, c)
				transaction:spawn(
					inventory,
					self.currency.name,
					math.ceil(value * self.exchangeRate) * c)
				transaction:commit()

				count = count - c
			end
		else
			break
		end
	end
end

function ShopWindowController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()

	return result
end

return ShopWindowController
