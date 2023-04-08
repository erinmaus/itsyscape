--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicChest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local InstancedInventoryBehavior = require "ItsyScape.Peep.Behaviors.InstancedInventoryBehavior"
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"

local BasicChest = Class(Prop)

function BasicChest:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	Utility.Peep.addInventory(self, SimpleInventoryProvider)

	self:addPoke('materialize')
end

function BasicChest:onFinalize(director, game)
	Prop.onFinalize(self, director, game)

	self:registerWithInstance()
end

function BasicChest:registerWithInstance()
	if self.currentInstance then
		self.currentInstance.onPlayerEnter:unregister(self._onPlayerEnter)
		self.currentInstance.onPlayerLeave:unregister(self._onPlayerEnter)
	end

	self.currentInstance = Utility.Peep.getInstance(self)
	if self.currentInstance then
		self._onPlayerEnter = self._onPlayerEnter or function(restore, _, player)
			self:reloadInventory(player:getID(), restore)
		end

		self.currentInstance.onPlayerEnter:register(self._onPlayerEnter, true)
		self.currentInstance.onPlayerLeave:register(self._onPlayerEnter, false)
	end
end

function BasicChest:move(director, key)
	Prop.move(self, director, key)

	self:registerWithInstance()

	if key then
		self:reloadInventory()
	end
end

function BasicChest:reloadInventory(incomingPlayerID, restore)
	local inventoryBehavior = self:getBehavior(InstancedInventoryBehavior)
	if not inventoryBehavior then
		return
	end

	if not incomingPlayerID then
		Log.info("Removing all instanced chest inventories.")

		for playerID, inventory in ipairs(inventoryBehavior.inventory) do
			if inventory then
				local player = self:getDirector():getGameInstance():getPlayerByID(playerID)
				if player then
					Log.info(
						"Removing instanced chest inventory for player '%s' (%d).",
						player:getActor():getName(), player:getID())
				else
					Log.info("Player %d no longer exists.", playerID)
				end

				local inventory = inventoryBehavior.inventory[playerID]
				inventory:getBroker():removeProvider(inventory, true)

				inventoryBehavior.inventory[playerID] = nil
			end
		end
	else
		local player = self:getDirector():getGameInstance():getPlayerByID(incomingPlayerID)
		if player then
			if restore then
				Log.info(
					"Restoring instanced chest inventory for player '%s' (%d).",
					player:getActor():getName(), player:getID())
			else
				Log.info(
					"Removing instanced chest inventory for player '%s' (%d).",
					player:getActor():getName(), player:getID())
			end
		else
			Log.error("Incoming player %d does not exist!", incomingPlayerID)
		end

		if restore then
			local success = Utility.Peep.prepInstancedInventory(self, SimpleInventoryProvider, player:getActor():getPeep())
			if success then
				Log.info("Restored instanced chest inventory.")
			else
				Log.warn("Did not restore instanced chest inventory.")
			end
		else
			local inventory = inventoryBehavior.inventory[incomingPlayerID]
			if inventory then
				inventory:getBroker():removeProvider(inventory, false)
				inventoryBehavior.inventory[incomingPlayerID] = nil

				Log.info("Successfully removed instanced chest inventory.")
			else
				Log.info("Did not remove instanced chest inventory.")
			end
		end
	end
end

function BasicChest.getDroppedItem(loot, weight)
	local currentWeight = 0
	local item = loot[1]

	if item then
		currentWeight = item.weight
	end

	local p = math.random(0, weight)
	for i = 2, #loot do
		if currentWeight > p then
			break
		end

		local nextItem = loot[i]
		local nextItemWeight = loot[i].weight
		local nextWeight = currentWeight + nextItemWeight

		item = nextItem
		currentWeight = nextWeight
	end

	return item
end

function BasicChest:onMaterialize(e)
	local count = e.count

	local rewards = {}
	local totalWeight = 0
	do
		local gameDB = self:getDirector():getGameDB()
		local actions = Utility.getActions(self:getDirector():getGameInstance(), e.dropTable)
		for _, action in ipairs(actions) do
			if action.instance:is("Reward") then
				local rewardEntry = gameDB:getRecord("RewardEntry", {
					Action = action.instance:getAction()
				})

				if rewardEntry then
					table.insert(rewards, {
						action = action.instance,
						weight = rewardEntry:get("Weight")
					})

					totalWeight = totalWeight + rewardEntry:get("Weight")
				end
			end
		end
	end

	local xp = {}
	for i = 1, count do
		local reward = BasicChest.getDroppedItem(rewards, totalWeight)
		self:reward(reward.action, e, xp)
	end

	for skill, xp in pairs(xp) do
		e.peep:getState():give("Skill", skill, xp)
	end
end

function BasicChest:addItemToInstancedInventory(player, itemID, itemCount)
	local inventory = Utility.Peep.prepInstancedInventory(self, SimpleInventoryProvider, player)
	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	local transaction = broker:createTransaction()
	transaction:addParty(inventory)
	transaction:spawn(inventory, itemID, itemCount, true, true)
	local success = transaction:commit()

	local playerModel = Utility.Peep.getPlayerModel(player)
	if not success then
		Log.warn(
			"Couldn't spawn item %s (count = %d) for player %s (%d) in '%s'.",
			itemID, itemCount, playerModel:getActor():getName(), playerModel:getID(), self:getName())
	else
		Log.engine(
			"Successfully spawned item %s (count = %d) for player %s (%d) in '%s'.",
			itemID, itemCount, playerModel:getActor():getName(), playerModel:getID(), self:getName())
	end
end

function BasicChest:reward(action, e, xp)
	local gameDB = action:getGameDB()
	local brochure = gameDB:getBrochure()
	for output in brochure:getOutputs(action:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if resourceType.name:lower() == "skill" then
			xp[resource.name] = (xp[resource.name] or 0) + output.count
		elseif resourceType.name:lower() == "item" then
			if self:hasBehavior(InstancedInventoryBehavior) then
				self:addItemToInstancedInventory(
					e.peep,
					resource.name,
					output.count)
			else
				e.chest:getState():give("Item", resource.name, output.count, { ['item-inventory'] = true, ['item-noted'] = true })
			end
		else
			Log.warn("Unhandled reward: '%s' of type '%s' (%dx)", resource.name, resourceType.name, output.count)
		end
	end
end

return BasicChest
