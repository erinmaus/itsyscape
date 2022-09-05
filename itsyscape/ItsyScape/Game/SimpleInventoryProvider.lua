--------------------------------------------------------------------------------
-- ItsyScape/Game/SimpleInventoryProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"

local SimpleInventoryProvider = Class(InventoryProvider)

function SimpleInventoryProvider:new(peep, player)
	InventoryProvider.new(self)

	self.peep = peep
	self.player = player
end

function SimpleInventoryProvider:getPeep()
	return self.peep
end

function SimpleInventoryProvider:getMaxInventorySpace()
	return math.huge
end

function SimpleInventoryProvider:onSpawn(item, count)
	self:getPeep():poke('spawnItem', {
		item = item,
		count = count
	})
end

function SimpleInventoryProvider:onTransferTo(item, source, count, purpose)
	self:getPeep():poke('transferItemTo', {
		source = source:getPeep(),
		item = item,
		count = count,
		purpose = purpose
	})
end

function SimpleInventoryProvider:onTransferFrom(destination, item, count, purpose)
	self:getPeep():poke('transferItemFrom', {
		destination = destination:getPeep(),
		item = item,
		count = count,
		purpose = purpose
	})
end

function SimpleInventoryProvider:load(...)
	InventoryProvider.load(self, ...)

	if self.player then
		Log.engine(
			"Reloading instanced SimpleInventoryProvider for player %s (%d).",
			self.player:getName(), Utility.Peep.getPlayerModel(self.player):getID())
	end

	local broker = self:getBroker()
	local storage = Utility.Item.getStorage(
		self.peep,
		(self.player and "SimpleInstanced") or "Simple",
		false,
		self.player)
	if storage then
		for key, section in storage:iterateSections() do
			Log.engine(
				"Restoring item %s (count = %d, noted = %s).",
				section:get("item-id"), section:get("item-count"), Log.boolean(section:get("item-noted")))
			broker:itemFromStorage(self, section)
		end
	end
end

function SimpleInventoryProvider:unload(...)
	local broker = self:getBroker()

	if self.player then
		local playerModel = Utility.Peep.getPlayerModel(self.player)
		Log.engine(
			"Unloading instanced SimpleInventoryProvider for player %s (%d).",
			self.player:getName(), (playerModel and playerModel:getID()) or 0)
	end

	local storage = Utility.Item.getStorage(
		self.peep,
		(self.player and "SimpleInstanced") or "Simple",
		true,
		self.player)
	if storage then
		local index = 1
		for item in broker:iterateItems(self) do
			Log.engine(
				"Storing item %s (count = %d, noted = %s).",
				item:getID(), item:getCount(), Log.boolean(item:isNoted()))
			broker:itemToStorage(item, storage, index)
			index = index + 1
		end
	end

	InventoryProvider.unload(self, ...)
end

return SimpleInventoryProvider
