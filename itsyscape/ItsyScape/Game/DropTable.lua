--------------------------------------------------------------------------------
-- ItsyScape/Game/DropTable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

local DropTable = Class()

DropTable.Drop = Class()

function DropTable.Drop:new(dropTable)
	self.dropTable = dropTable
end

function DropTable.Drop:getDropTable()
	return self.dropTable
end

DropTable.ItemDrop = Class(DropTable.Drop)

-- 'item' is a Mapp Resource
function DropTable.ItemDrop:new(dropTable, item)
	DropTable.Drop.new(self, dropTable)

	self.item = item
	self.count = 1
	self.range = 0
	self.isNoted = false
end

function DropTable.ItemDrop:getItemID()
	return self.item.name
end

function DropTable.ItemDrop:getItemResource()
	return self.item
end

function DropTable.ItemDrop:setCount(value)
	assert(self.count > 0)
	self.count = value
end

function DropTable.ItemDrop:getCount()
	return self.count
end

function DropTable.ItemDrop:setRange(value)
	assert(value >= 0)
	self.range = math.floor(value)
end

function DropTable.ItemDrop:getRange()
	return self.range
end

function DropTable.ItemDrop:setIsNoted(value)
	self.isNoted = not not value
end

function DropTable.ItemDrop:getIsNoted()
	return self.isNoted
end

DropTable.ActionDrop = Class(DropTable.Drop)

-- 'item' is an Action instance; not a Mapp Action
function DropTable.ActionDrop:new(dropTable, action)
	DropTable.Drop.new(self, dropTable)

	self.action = action
end

function DropTable.ActionDrop:getActionInstance()
	return self.action
end

DropTable.Entry = Class()

function DropTable.Entry:new(dropTable, drop, category)
	self.onChangeWeight = Callback()

	self.dropTable = dropTable
	self.drop = drop
	self.weight = 0
	self.category = category or false
end

function DropTable.Entry:getDropTable()
	return self.dropTable
end

function DropTable.Entry:getDrop()
	return self.drop
end

function DropTable.Entry:getWeight(value)
	return self.weight
end

function DropTable.Entry:setWeight(value)
	assert(value >= 0)

	self:onChangeWeight(self.weight, value)
	self.weight = value
end

function DropTable.Entry:getCategory()
	return self.category
end

function DropTable:new(peep)
	self.peep = peep or false
	self.totalWeight = 0

	self.entries = {}
end

function DropTable._onChangeWeight(_, oldWeight, newWeight)
	self.totalWeight = self.totalWeight - oldWeight + newWeight
end

function DropTable:addAction(action, weight, category)
	local drop = DropTable.ActionDrop(self, action)

	local entry = DropTable.Entry(self, drop, category)
	entry.onChangeWeight:register(self._onChangeWeight, self)
	entry:setWeight(weight)

	table.insert(self.entries, entry)

	return drop, entry
end

function DropTable:addItem(item, weight, category)
	local drop = DropTable.ItemDrop(self, item)

	local entry = DropTable.Entry(self, drop, category)
	entry.onChangeWeight:register(self._onChangeWeight, self)
	entry:setWeight(weight)

	table.insert(self.entries, entry)

	return drop, entry
end

function DropTable:roll(value)
	local totalWeight = self.totalWeight
	local currentWeight = 0
	local current = self.entries[1]

	if current then
		currentWeight = current:getWeight()
	end

	local p = (value or love.math.random()) * totalWeight
	for i = 2, #self.entries do
		if currentWeight > p then
			break
		end

		current = self.entries[i]
		currentWeight = currentWeight + current:getWeight()
	end

	return current
end

function DropTable:_fromActions(actions, prop, playerPeep)
	if not actions then
		return
	end

	for _, action in ipairs(actions) do
		local gatherableAction = gameDB:getRecord("GatherableAction", {
			Action = action.instance:getAction()
		})

		if gatherableAction then
			local weight = gatherableAction:get("Weight")
			local category = gatherableAction:get("LootCategory")

			self:addAction(action.instance, weight, category)
		end
	end
end

function DropTable:fromGatherables(prop, playerPeep)
	-- TODO use a LuckEffect to modify the drop table
	if not playerPeep then
		local instance = Utility.Peep.getInstance(prop)
		local player = instance and instance:getPartyLeader()
		playerPeep = player and player:getActor() and player:getActor():getPeep()
	end

	local gameDB = prop:getDirector():getGameDB()

	local resource = Utility.Peep.getResource(prop)
	local mapObject = Utility.Peep.getMapObject(prop)

	local actions1 = resource and Utility.getActions(prop:getDirector():getGameInstance(), resource)
	self:_fromActions(actions1)

	local actions2 = mapObject and Utility.getActions(prop:getDirector():getGameInstance(), mapObject)
	self:_fromActions(actions2)
end

return DropTable
