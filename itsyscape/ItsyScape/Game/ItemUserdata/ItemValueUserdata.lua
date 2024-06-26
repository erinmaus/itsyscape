--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata/ItemValueUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"
local Utility = require "ItsyScape.Game.Utility"

local ItemValueUserdata = Class(ItemUserdata)

function ItemValueUserdata:new(...)
	ItemUserdata.new(self, ...)

	self.value = 0
end

function ItemValueUserdata:setValue(value)
	self.value = math.floor(math.max(value, 0))
end

function ItemValueUserdata:getValue()
	return self.value
end

function ItemValueUserdata:getDescription()
	return self:buildDescription("Message_ItemValueUserdata_Description", Utility.Text.prettyNumber(self.value))
end

function ItemValueUserdata:combine(otherUserdata)
	if otherUserdata:getType() ~= self:getType() then
		return false
	end

	self:setValue(self:getValue() + otherUserdata:getValue())

	return true
end

function ItemValueUserdata:serialize()
	return {
		value = self.value
	}
end

function ItemValueUserdata:deserialize(data)
	self.value = math.floor(data.value)
end

function ItemValueUserdata:fromRecord(record)
	self:setValue(record:get("Value"))
end

return ItemValueUserdata
