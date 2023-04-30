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
	self:updateState()
end

function PlayerInventoryController:poke(actionID, actionIndex, e)
	if actionID == "swap" then
		self:swap(e)
	elseif actionID == "drop" then
		self:drop(e)
	elseif actionID == "poke" then
		self:pokeItem(e)
	elseif actionID == "useItemOnItem" then
		self:useItemOnItem(e)
	elseif actionID == "useItemOnProp" then
		self:useItemOnProp(e)
	elseif actionID == "useItemOnActor" then
		self:useItemOnActor(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerInventoryController:updateState()
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

	self.state = result
end

function PlayerInventoryController:pull()
	return self.state
end

function PlayerInventoryController:pullItem(item)
	local result = {}
	result.id = item:getID()
	result.count = item:getCount()
	result.noted = item:isNoted()
	result.name = Utility.Item.getInstanceName(item)
	result.description = Utility.Item.getInstanceDescription(item)

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
			'inventory',
			true)
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
		Utility.performAction(
			self:getGame(),
			itemResource,
			e.id,
			'inventory',
			self:getPeep():getState(), self:getPeep(), item)
	end
end

function PlayerInventoryController:_tryUseItem(item, actions)
	local game = self:getGame()
	local gameDB = game:getGameDB()
	local brochure = gameDB:getBrochure()

	for i = 1, #actions do
		local performAction = false

		if actions[i].instance:is("OpenInventoryCraftWindow") or actions[i].instance:is("OpenCraftWindow") then
			local target = gameDB:getRecord("DelegatedActionTarget", { Action = actions[i].instance:getAction() })
			if target then
				local key = target:get("CategoryKey")
				if key == "" then
					key = nil
				end

				local value = target:get("CategoryValue")
				if value == "" then
					value = nil
				end

				local resources = gameDB:getRecords("ResourceCategory", {
					Key = key,
					Value = value
				})

				for j = 1, #resources do
					local resource = resources[j]:get("Resource")
					for action in brochure:findActionsByResource(resource) do
						local a = Utility.getAction(game, action, 'craft')

						if (a and target:get("ActionType") == "") or (a and a.instance:is(target:get("ActionType"))) then
							local constraints = Utility.getActionConstraints(game, action)

							for j = 1, #constraints.requirements do
								if constraints.requirements[j].resource == item:getID() and constraints.requirements[j].type:lower() == "item" then
									performAction = true
									break
								end
							end

							for j = 1, #constraints.inputs do
								if constraints.inputs[j].resource == item:getID() and constraints.inputs[j].type:lower() == "item" then
									performAction = true
									break
								end
							end

							if performAction then
								break
							end
						end
					end

					if performAction then
						break
					end
				end
			end
		else
			local constraints = Utility.getActionConstraints(game, actions[i].instance:getAction())

			for j = 1, #constraints.requirements do
				if constraints.requirements[j].resource == item:getID() and constraints.requirements[j].type:lower() == "item" then
					performAction = true
					break
				end
			end

			for j = 1, #constraints.inputs do
				if constraints.inputs[j].resource == item:getID() and constraints.inputs[j].type:lower() == "item" then
					performAction = true
					break
				end
			end
		end

		if performAction then
			return true, i
		end
	end

	return false, nil
end

function PlayerInventoryController:useItemOnItem(e)
	assert(type(e.index1) == 'number', "index 1 is not number")
	assert(type(e.index2) == 'number', "index 2 is not number")

	if e.index1 == e.index2 then
		return
	end

	local item1, item2
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			local broker = inventory.inventory:getBroker()

			for i in broker:iterateItemsByKey(inventory.inventory, e.index1) do
				item1 = i
				break
			end

			for i in broker:iterateItemsByKey(inventory.inventory, e.index2) do
				item2 = i
				break
			end
		end
	end

	if not item1 or not item2 then
		Log.error("No item(s) at index %d and/or index %d.", e.index1, e.index2)
		return false
	end

	local game = self:getGame()
	local gameDB = game:getGameDB()

	local item1Resource = gameDB:getResource(item1:getID(), "Item")
	local item2Resource = gameDB:getResource(item2:getID(), "Item")

	if not item1Resource or not item2Resource then
		Log.error(
			"No item resource(s) for item '%s' (index %d) and/or item '%s' (index %d).",
			item1:getID(), e.index1,
			item2:getID(), e.index2)
		return
	end

	local item1Actions = Utility.getActions(game, item1Resource, 'inventory')
	local item2Actions = Utility.getActions(game, item2Resource, 'inventory')

	local success, index = self:_tryUseItem(item1, item2Actions)
	if success then
		local actionID = item2Actions[index].instance:getID()
		Utility.performAction(
			self:getGame(),
			item2Resource,
			actionID,
			'inventory',
			self:getPeep():getState(), self:getPeep(), item2)
		return
	end

	success, index = self:_tryUseItem(item2, item1Actions)
	if success then
		local actionID = item1Actions[index].instance:getID()
		Utility.performAction(
			self:getGame(),
			item1Resource,
			actionID,
			'inventory',
			self:getPeep():getState(), self:getPeep(), item1)
		return
	end

	Utility.Peep.notify(self:getPeep(), "That doesn't do anything...")
end

function PlayerInventoryController:useItemOnProp(e)
	assert(type(e.itemIndex) == 'number', "item index is not number")
	assert(type(e.propID) == 'number', "prop ID is not number")

	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			local broker = inventory.inventory:getBroker()

			for i in broker:iterateItemsByKey(inventory.inventory, e.itemIndex) do
				item = i
				break
			end
		end
	end

	local game = self:getGame()
	local gameDB = game:getGameDB()

	local itemResource = gameDB:getResource(item:getID(), "Item")

	if not itemResource then
		Log.error(
			"No item resource(s) for item '%s' (index %d).",
			item:getID(), e.itemIndex)
		return
	end

	local prop = game:getStage():getPropByID(e.propID)
	if not prop then
		Log.error("No prop with ID %s.", e.propID)
		return
	end

	local actions = prop:getActions('world')
	local success, index = self:_tryUseItem(item, actions)
	if success then
		local actionID = actions[index].instance:getID()
		Utility.performAction(
			self:getGame(),
			Utility.Peep.getResource(prop:getPeep()),
			actionID,
			'world',
			self:getPeep():getState(), self:getPeep(), prop:getPeep())
		return
	end

	Utility.Peep.notify(self:getPeep(), "That doesn't do anything...")
end

function PlayerInventoryController:useItemOnActor(e)
	assert(type(e.itemIndex) == 'number', "item index is not number")
	assert(type(e.actorID) == 'number', "actor ID is not number")

	local item
	do
		local inventory = self:getPeep():getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			local broker = inventory.inventory:getBroker()

			for i in broker:iterateItemsByKey(inventory.inventory, e.itemIndex) do
				item = i
				break
			end
		end
	end

	local game = self:getGame()
	local gameDB = game:getGameDB()

	local itemResource = gameDB:getResource(item:getID(), "Item")

	if not itemResource then
		Log.error(
			"No item resource(s) for item '%s' (index %d).",
			item:getID(), e.itemIndex)
		return
	end

	local actor = game:getStage():getActorByID(e.actorID)
	if not actor then
		Log.error("No actor with ID %s.", e.actorID)
		return
	end

	local actions = actor:getActions('world')
	local success, index = self:_tryUseItem(item, actions)
	if success then
		local actionID = actions[index].instance:getID()
		Utility.performAction(
			self:getGame(),
			Utility.Peep.getResource(actor:getPeep()),
			actionID,
			'world',
			self:getPeep():getState(), self:getPeep(), actor:getPeep())
		return
	end

	Utility.Peep.notify(self:getPeep(), "That doesn't do anything...")
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

	self:updateState()
end

return PlayerInventoryController
