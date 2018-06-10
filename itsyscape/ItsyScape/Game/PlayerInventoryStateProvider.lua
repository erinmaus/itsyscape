--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerInventoryStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local StateProvider = require "ItsyScape.Game.StateProvider"
local InventoryBehavior = require "ItsyScape.Peeps.Behaviors.InventoryBehavior"

local PlayerInventoryStateProvider = Class(StateProvider)

function PlayerInventoryStateProvider:new(peep)
	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		self.inventory = inventory.inventory
	else
		self.inventory = false
	end

	self.peep = peep
end

-- Flags:
--  * noted: only search for noted items; otherwise, search for unnoted items.
function PlayerInventoryStateProvider:has(name, count, flags)
	if not self.inventory then
		return false
	end

	local noted = false
	if flags['noted'] then
		noted = true
	end

	local broker = self.inventory:getBroker()
	local count = 0
	for item in broker:iterateItems(self.inventory) do
		if item:getID() == name and item:isNoted() == noted then
			count = count + item:getCount()
		end
	end

	return count >= count
end

return PlayerInventoryStateProvider
