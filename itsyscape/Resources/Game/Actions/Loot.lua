--------------------------------------------------------------------------------
-- Resources/Game/Actions/Loot.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"
local Action = require "ItsyScape.Peep.Action"

local Loot = Class(Action)
Loot.DROP_TABLE_RESOURCE_TYPE = string.lower("DropTable")

function Loot.totalWeight(loot)
	local weight = 0
	for i = 1, #loot do
		weight = weight + loot[i]:get("Weight") or 0
	end

	return weight
end

function Loot.getDroppedItem(loot)
	local weight = Loot.totalWeight(loot)
	local currentWeight = 0
	local item = loot[1]

	if item then
		currentWeight = item:get("Weight") or 0
	end

	local p = math.random(0, weight)
	for i = 2, #loot do
		if currentWeight > p then
			break
		end

		local nextItem = loot[i]
		local nextItemWeight = loot[i]:get("Weight") or 0
		local nextWeight = currentWeight + nextItemWeight

		item = nextItem
		currentWeight = nextWeight
	end

	return item
end

function Loot:materializeDropTable(peep, inventory, loot)
	local item = Loot.getDroppedItem(loot)
	if item then
		local count = item:get("Count") or 1
		do
			local range = item:get("Range") or 0
			if range > 0 then
				count = count + math.random(-range, range)
			end
		end

		local noted = item:get("Noted") or false
		if noted == 0 then
			noted = false
		end

		local resource = item:get("Item")
		do
			local broker = self:getGame():getDirector():getItemBroker()
			local t = broker:createTransaction()
			t:addParty(inventory)
			t:spawn(inventory, resource.name, count, noted)
			if t:commit() then
				local stage = self:getGame():getStage()
				for i in broker:iterateItems(inventory) do
					stage:dropItem(i, i:getCount())
				end
			end
		end
	end

	return false
end

function Loot:perform(state, peep)
	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()
	local inventory

	for output in brochure:getOutputs(self:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if resourceType.name:lower() == Loot.DROP_TABLE_RESOURCE_TYPE then
			if not inventory then
				inventory = SimpleInventoryProvider(peep)
				self:getGame():getDirector():getItemBroker():addProvider(inventory)
			end
		end

		local loot = gameDB:getRecords("DropTableEntry", { Resource = resource })
		self:materializeDropTable(peep, inventory, loot)
	end

	if inventory then
		self:getGame():getDirector():getItemBroker():removeProvider(inventory)
	end

	return true
end

return Loot
