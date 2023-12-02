--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Consume.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Consume = B.Node("Consume")
Consume.ITEM = B.Reference()
Consume.NOTED = B.Reference()
Consume.QUANTITY = B.Reference()

function Consume:update(mashina, state, executor)
	local item, noted, quantity = state[self.ITEM], state[self.NOTED] or false, state[self.QUANTITY] or 1
	if not item then
		return B.Status.Failure
	end

	local sourceInventory = mashina:getBehavior(InventoryBehavior)
	if sourceInventory and sourceInventory.inventory then
		sourceInventory = sourceInventory.inventory
		broker = sourceInventory:getBroker()

		if noted then
			local sourceItem
			for i in broker:iterateItems(sourceInventory) do
				if i:getID() == item and i:isNoted() and i:getCount() == quantity then
					sourceItem = i
					break
				end
			end

			if not sourceItem then
				return B.Status.Failure
			end

			local t = broker:createTransaction()
			t:addParty(sourceInventory)
			t:consume(sourceItem, quantity)
			if t:commit() then
				return B.Status.Success
			else
				return B.Status.Failure
			end
		else
			local remainder = quantity
			local sourceItems = {}
			for i in broker:iterateItems(sourceInventory) do
				if (i:getID() == item or item == true) and not i:isNoted() then
					local q = math.min(i:getCount(), remainder)
					table.insert(sourceItems, { i, q })

					remainder = remainder - q
				end

				if remainder <= 0 then
					assert(remainder == 0, "quantity underflow")
					break
				end
			end

			if remainder > 0 and remainder ~= math.huge then
				return B.Status.Failure
			end

			local t = broker:createTransaction()
			t:addParty(sourceInventory)

			for i = 1, #sourceItems do
				t:consume(sourceItems[i][1], sourceItems[i][2])
			end

			if t:commit() then
				return B.Status.Success
			else
				return B.Status.Failure
			end
		end
	end

	return B.Status.Failure
end

return Consume
