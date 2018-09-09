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
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"

local SimpleInventoryProvider = Class(InventoryProvider)

function SimpleInventoryProvider:new(peep)
	self.peep = peep
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
		count = count
	})
end

return SimpleInventoryProvider
