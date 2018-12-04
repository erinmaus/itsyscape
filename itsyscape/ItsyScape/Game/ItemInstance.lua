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
	self.count = 1
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

function ItemInstance:setUserdata(userdata)
	if self.manager:hasUserdata(self.id) and type(userdata) == 'table' then
		self.userdata = userdata
	end
end

function ItemInstance:getCount()
	if self.manager:isStackable(self.id) or self:isNoted() then
		return self.count
	else
		return 1
	end
end

function ItemInstance:isStackable()
	return self.manager:isStackable(self.id) or self:isNoted()
end

function ItemInstance:setCount(count)
	if self:isNoted() or self.manager:isStackable(self.id) then
		self.count = math.max(math.floor(count or 1), 1)
	end
end

function ItemInstance:clone()
	local instance = ItemInstance(self.id, self.manager)
	instance.count = count
	instance.noted = self.noted
	instance.count = self.count
	-- TODO clone userdata
	instance.userdata = self.userdata

	return instance
end

return ItemInstance
