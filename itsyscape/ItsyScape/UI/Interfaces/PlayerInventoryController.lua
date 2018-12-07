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
local Utility = require "ItsyScape.Game.Utility"
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
		if broker then
			for key in broker:keys(inventory.inventory) do
				for item in broker:iterateItemsByKey(inventory.inventory, key) do
					local resultItem = self:pullItem(item)
					self:pullActions(item, resultItem)
					result.items[key] = resultItem
					break
				end
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
	-- Noted items don't have actions.
	if item:isNoted() then
		serializedItem.actions = {}
		return
	end

	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		serializedItem.actions = Utility.getActions(
			self:getDirector():getGameInstance(),
			itemResource,
			'inventory')
	else
		serializedItem.actions = {}
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

	local itemResource = self:getGame():getGameDB():getResource(item:getID(), "Item")
	if itemResource then
		local success = Utility.performAction(
			self:getGame(),
			itemResource,
			e.id,
			'inventory',
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
			broker:setItemZ(item1, e.b)
		end

		if item2 then
			broker:setItemKey(item2, e.a)
			broker:setItemZ(item2, e.a)
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
