--------------------------------------------------------------------------------
-- ItsyScape/Game/GroundInventoryProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local GroundInventoryProvider = Class(InventoryProvider)
GroundInventoryProvider.Key = Class()

function GroundInventoryProvider.Key:new(i, j, layer)
	self.i = i
	self.j = j
	self.layer = layer
end

function GroundInventoryProvider.Key._METATABLE.__eq(a, b)
	return a.i == b.i and a.j == b.j and a.layer == b.layer
end

function GroundInventoryProvider.Key._METATABLE.__lt(a, b)
	if a.i < b.i then
		return true
	elseif a.i == b.i then
		if a.j < b.j then
			return true
		elseif a.j == b.j then
			if a.layer < b.layer then
				return true
			end
		end
	end

	return false
end

function GroundInventoryProvider:new(peep)
	self.peep = peep
	self.onDropItem = Callback()
	self.onTakeItem = Callback()
end

function GroundInventoryProvider:getPeep()
	return self.peep
end

function GroundInventoryProvider:getMaxInventorySpace()
	return math.huge
end

function GroundInventoryProvider:onTransferTo(item, source, count, purpose)
	local sourcePeep = source:getPeep()
	local sourcePeepPosition = sourcePeep:getBehavior(PositionBehavior)
	if sourcePeepPosition then
		local map = self.peep:getDirector():getMap(PositionBehavior.layer or 1)
		if map then
			local i, j = map:toTile(
				sourcePeepPosition.position.x,
				sourcePeepPosition.position.z)
			if i and j then
				local key = GroundInventoryProvider.Key(i, j, sourcePeepPosition.layer or 1)
				self:getBroker():setItemKey(item, key)

				if purpose == 'drop' then
					self:getBroker():tagItem(item, "owner", sourcePeep)
				else
					self:getBroker():tagItem(item, "owner", purpose)
				end

				self.onDropItem(item, key, source, count)
			end
		end
	end
end

function GroundInventoryProvider:onTransferFrom(source, item, count, purpose)
	self.onTakeItem(item, self:getBroker():getItemKey(item), count)
end

return GroundInventoryProvider
