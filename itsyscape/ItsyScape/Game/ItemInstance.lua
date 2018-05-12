--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local ItemInstance = Class()

function ItemInstance:new(id, manager)
	self.id = id
	self.manager = manager
	self.quantity = 1
	self.noted = false
	self.userdata = {}
end

function ItemInstance:getID()
	return self.id
end

function ItemInstance:isNoted()
	return self.noted and self.manager:isNoteable(self.id)
end

function ItemInstance:unnote()
	self.noted = false
end

function ItemInstance:note()
	if self.manager:isNoteable(self.id) then
		self.noted = true
	end
end

function ItemInstance:getUserdata()
	if self.manager:hasUserdata(self.id) then
		return self.userdata
	else
		return nil
	end
end

function ItemInstance:getQuantity()
	if self.manager:isStackable(self.id) or self:isNoted() then
		return self.quantity
	else
		self.quantity = 1
	end
end

function ItemInstance:isStackable()
	return self.manager:isStackable(self.id)
end

function ItemInstance:setQuantity(quantity)
	if self:isNoted() or self.manager:isStackable(self.id) then
		self.quantity = quantity or 1
	end
end

function ItemInstance:clone()
	local instance = ItemInstance(self.id, self.manager)
	instance.quantity = quantity
	instance.noted = self.noted
	instance.quantity = self.quantity
	-- TODO clone userdata
	instance.userdata = self.userdata

	return instance
end

return ItemInstance
