--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/DropInventoryItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local DropInventoryItem = B.Node("DropInventoryItem")
DropInventoryItem.ITEM = B.Reference()
DropInventoryItem.COUNT = B.Reference()

function DropInventoryItem:update(mashina, state, executor)
	local stage = mashina:getDirector():getGameInstance():getStage()

	local item = state[self.ITEM]
	local count = state[self.COUNT] or math.huge
	local currentCount = 0
	local inventory = Utility.Peep.getInventory(mashina)
	for _, i in ipairs(inventory) do
		if (Class.isCallable(item) and item(i)) or i:getID() == item then
			local dropCount
			if count and count ~= math.huge then
				local c = math.max(count - currentCount, 0)
				dropCount = math.min(c, i:getCount())

				currentCount = currentCount + dropCount
			else
				dropCount = math.huge
			end

			stage:dropItem(i, math.min(dropCount, i:getCount()), mashina)
		end
	end

	if currentCount == 0 then
		return B.Status.Failure
	end

	return B.Status.Success
end

return DropInventoryItem
