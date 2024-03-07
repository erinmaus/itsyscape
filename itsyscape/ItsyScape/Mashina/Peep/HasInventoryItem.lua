--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/HasInventoryItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local HasInventoryItem = B.Node("HasInventoryItem")
HasInventoryItem.PEEP = B.Reference()
HasInventoryItem.ITEM = B.Reference()
HasInventoryItem.COUNT = B.Reference()

function HasInventoryItem:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local item = state[self.ITEM]
	if not item then
		return B.Status.Failure
	end

	local count = state[self.COUNT] or 1

	if peep:getState():has("Item", item, count, { ['item-inventory'] = true }) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return HasInventoryItem
