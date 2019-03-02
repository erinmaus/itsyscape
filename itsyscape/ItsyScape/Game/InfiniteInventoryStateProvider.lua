--------------------------------------------------------------------------------
-- ItsyScape/Game/InfiniteInventoryStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local StateProvider = require "ItsyScape.Game.StateProvider"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local InfiniteInventoryStateProvider = Class(StateProvider)

function InfiniteInventoryStateProvider:new(peep)
	self.items = {}
	self.peep = peep
end

function InfiniteInventoryStateProvider:getPriority()
	return State.PRIORITY_IMMEDIATE
end

function InfiniteInventoryStateProvider:add(item)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(item, "Item")
	if resource then
		self.items[item] = resource
	else
		Log.error("can't add Item '%s' to InfiniteInventoryStateProvider: no such item", item)
	end
end

function InfiniteInventoryStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function InfiniteInventoryStateProvider:take(name, count, flags)
	if self.items[name] and not flags['item-noted'] then
		return true
	end
end

function InfiniteInventoryStateProvider:give(name, count, flags)
	if not flags['item-inventory'] then
		return false
	end

	if flags['item-noted'] then
		return false
	end

	return self.items[name] ~= nil
end

function InfiniteInventoryStateProvider:count(name, flags)
	if flags['item-noted'] then
		return 0
	end

	if self.items[name] then
		return math.huge
	end

	return 0
end

return InfiniteInventoryStateProvider
