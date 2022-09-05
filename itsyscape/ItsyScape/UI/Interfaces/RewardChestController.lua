--------------------------------------------------------------------------------
-- ItsyScape/UI/RewardChestController.lua
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
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"
local Controller = require "ItsyScape.UI.Controller"
local InstancedInventoryBehavior = require "ItsyScape.Peep.Behaviors.InstancedInventoryBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local RewardChestController = Class(Controller)

function RewardChestController:new(peep, director, chest)
	Controller.new(self, peep, director)

	self.chest = chest
	self:refresh()

	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"hide",
		nil,
		{})
end

function RewardChestController:getInventory()
	local inventory
	do
		local inventoryBehavior = self.chest:getBehavior(InstancedInventoryBehavior)
		if inventoryBehavior then
			inventory = Utility.Peep.prepInstancedInventory(self.chest, SimpleInventoryProvider, self:getPeep())
		end
	end

	if not inventory then
		local inventoryBehavior = self.chest:getBehavior(InventoryBehavior)
		inventory = inventoryBehavior and inventoryBehavior.inventory
	end

	return inventory
end

function RewardChestController:refresh()
	self.state = {
		items = {}
	}

	self.items = {}

	local inventory = self:getInventory()
	if inventory then
		local broker = self:getDirector():getItemBroker() 
		local storage = inventory
		for item in broker:iterateItems(storage) do
			local serializedItem = self:pullItem(item)
			table.insert(self.state.items, serializedItem)
			table.insert(self.items, item)
		end

		self.state.items.max = #self.state.items
	end
end

function RewardChestController:poke(actionID, actionIndex, e)
	if actionID == "collect" then
		self:collect(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
		return
	end
end

function RewardChestController:pull()
	return self.state
end

function RewardChestController:close()
	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"show",
		nil,
		{})
end

function RewardChestController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = false
	result.name = Utility.Item.getName(result.id, self:getDirector():getGameDB()) or ("*" .. result.id)
	result.description = Utility.Item.getDescription(result.id, self:getDirector():getGameDB()) or "It's an item."

	return result
end

function RewardChestController:collect(e)
	local reward = self.chest:getBehavior(InventoryBehavior)
	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	if inventory and inventory.bank and
	   reward and reward.inventory
	then
		reward = reward.inventory
		inventory = inventory.bank
		assert(reward:getBroker() == inventory:getBroker())

		local broker = reward:getBroker()
		local items = {}
		for item in broker:iterateItems(reward) do
			table.insert(items, item)
		end

		for i = 1, #items do
			inventory:deposit(items[i], items[i]:getCount(), true)
		end
	end

	self:getGame():getUI():closeInstance(self)
end

function RewardChestController:update(delta)
	Controller.update(delta)
end

return RewardChestController
