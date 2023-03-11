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

function ItemInstance:new(id, ref, manager)
	self.id = id
	self.ref = 0
	self.manager = manager
	self.count = 1
	self.noted = false
	self.userdata = {}
end

function ItemInstance:getRef()
	return self.ref
end

function ItemInstance:getID()
	return self.id
end

function ItemInstance:isNoted()
	return self.noted and self.manager:isNoteable(self.id)
end

function ItemInstance:getManager()
	return self.manager
end

function ItemInstance:unnote()
	self.noted = false
end

function ItemInstance:note()
	if self.manager:isNoteable(self.id) then
		self.noted = true
	end
end

function ItemInstance:addUserdata(userdataID, data)
	local userdata = self.userdata[userdataID] or self.manager:newUserdata(userdataID)

	if not userdata then
		return
	end

	userdata:deserialize(data)

	self.userdata[userdataID] = userdata
end

function ItemInstance:removeUserdata(userdataID)
	self.userdata[userdataID] = nil
end

function ItemInstance:getUserdata(userdataID)
	if userdataID then
		return self.userdata[userdataID]
	else
		return self.userdata
	end
end

function ItemInstance:iterateUserdata()
	return pairs(self.userdata)
end

function ItemInstance:getSerializedUserdata()
	local result = {}

	for userdataID, userdata in pairs(self.userdata) do
		result[userdataID] = userdata:serialize()
	end

	return result
end

function ItemInstance:setUserdata(userdata)
	if type(userdata) == 'table' then
		table.clear(self.userdata)
		for userdataID, userdata in pairs(userdata) do
			self:addUserdata(userdataID, userdata)
		end
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

return ItemInstance
