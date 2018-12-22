--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemBroker.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Item = Class()

function Item:new(id, manager)
	self.id = id or "Null"
	self.manager = manager
end

function Item:getID()
	return self.id
end

function Item:getManager()
	return self.manager
end

function Item:getIsTradeable()
	return self.manager:isTradeable(self.id)
end

function Item:canConsume(item, provider)
	return true
end

function Item:canDestroy(item, provider)
	return true
end

function Item:canSpawn(provider)
	return true
end

function Item:canTransfer(item, source, destination, purpose)
	if purpose == 'trade' and
	   not self:getManager():getIsTradeable(self:getID())
	then
		return false
	end

	return true
end

return Item
