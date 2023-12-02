--------------------------------------------------------------------------------
-- Resources/Game/Actions/LootBag.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local Action = require "ItsyScape.Peep.Action"
local Loot = require "Resources.Game.Actions.Loot"

local LootBag = Class(Action)
LootBag.SCOPES = { ['inventory'] = true }
LootBag.FLAGS = { ['item-ignore'] = true, ['item-inventory'] = true }
Loot.DROP_TABLE_RESOURCE_TYPE = string.lower("DropTable")

function LootBag:materializeDropTable(peep, inventory, loot, transaction)
	local item = Loot.getDroppedItem(loot)
	if item then
		local count = item:get("Count") or 1
		do
			local range = item:get("Range") or 0
			if range > 0 then
				count = count + love.math.random(-range, range)
			end
		end

		if count <= 0 then
			Log.warn(
				"Item '%s' somehow dropped to zero or less (%d) when calculating drop count for '%s'.",
				item:get("Item").id, count, peep:getName())
			count = 1
		end

		local noted = item:get("Noted") or false
		if noted == 0 then
			noted = false
		end

		local resource = item:get("Item")
		do
			local broker = self:getGame():getDirector():getItemBroker()
			transaction:spawn(inventory, resource.name, count, noted)

			local gameDB = self:getGameDB()
			local legendaryLootCategory = gameDB:getResource("Legendary", "LootCategory")
			local isLegendary = legendaryLootCategory and gameDB:getRecord("LootCategory", {
				Item = resource,
				Category = legendaryLootCategory
			}) ~= nil

			return true, resource, count, isLegendary
		end
	end

	return false
end

function LootBag:perform(state, peep, item)
	if not self:canPerform(state) then
		return false
	end

	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	local broker = self:getGame():getDirector():getItemBroker()
	local transaction = broker:createTransaction()
	transaction:addParty(inventory)
	transaction:consume(item, 1)

	local items = {}
	for output in brochure:getOutputs(self:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if resourceType.name:lower() == Loot.DROP_TABLE_RESOURCE_TYPE then
			local loot = gameDB:getRecords("DropTableEntry", { Resource = resource })
			for i = 1, output.count do
				local success, itemResource, itemCount, itemIsLegendary = self:materializeDropTable(peep, inventory, loot, transaction)

				local details = items[itemResource.name] or {}
				details.count = (details.count or 0) + itemCount
				details.isLegendary = details.isLegendary or itemIsLegendary
				items[itemResource.name] = details
			end
		end
	end

	if transaction:commit() then
		self:transfer(state, peep)
		Action.perform(self, state, peep)

		local gotLegendaryItem = false

		for itemID, itemDetails in pairs(items) do
			gotLegendaryItem = gotLegendaryItem or itemDetails.isLegendary

			for _, lootItem in transaction:iterateItems() do
				if lootItem:getID() == itemID then
					Analytics:lootedItem(peep, item, lootItem, itemDetails.count, itemDetails.isLegendary)
					break
				end
			end
		end

		if gotLegendaryItem then
			local stage = peep:getDirector():getGameInstance():getStage()
			stage:fireProjectile("ConfettiSplosion", Vector.ZERO, peep)
		end

		return true
	end

	return false
end

function LootBag:getFailureReason(state, peep)
	local reason = Loot.getFailureReason(self, state, peep)

	table.insert(reason.requirements, {
		type = "KeyItem",
		resource = "Message",
		name = "Maybe there wasn't enough room in your inventory for the items from the loot bag. Make some space or try again!",
		count = 1
	})

	return reason
end

return LootBag
