---------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RPCState = require "ItsyScape.Game.RPC.State"

local ItemUserdata = Class()

function ItemUserdata:new(id, manager)
	self.id = id
	self.manager = manager
	self.resource = manager:getGameDB():getResource(id, "ItemUserdata")
end

function ItemUserdata:getID()
	return self.id
end

function ItemUserdata:getItemManager()
	return self.manager
end

function ItemUserdata:getGameDB()
	return self.manager:getGameDB()
end

function ItemUserdata:getResource()
	return self.resource
end

function ItemUserdata:getName()
	return Utility.getName(self.resource, self:getGameDB()) or ("*" .. self.resource.name)
end

function ItemUserdata:getDescription()
	return Utility.getDescription(self.resource, self:getGameDB())
end

function ItemUserdata:buildDescription(stringID, ...)
	local formatStringKeyItem = self.manager:getGameDB():getResource(stringID, "KeyItem")
	if not formatStringKeyItem then
		return "*" .. stringID
	end

	local formatStringKeyItemDescription = self.manager:getGameDB():getRecord("ResourceDescription", {
		Language = "en-US",
		Resource = formatStringKeyItem
	})
	if not formatStringKeyItemDescription then
		return "*" .. stringID
	end

	local formatString = formatStringKeyItemDescription:get("Value")

	return string.format(formatString, ...)
end

function ItemUserdata:getDescription()
	return nil
end

function ItemUserdata:combine(otherUserdata)
	-- Nothing.
end

function ItemUserdata:serialize()
	return {}
end

function ItemUserdata:deserialize(data)
	-- Nothing.
end

function ItemUserdata:isSame(otherUserdata)
	local isSameType = self:getType() == otherUserdata:getType()
	local isStateEqual = RPCState.deepEquals(self:serialize(), otherUserdata:serialize())
	
	return isSameType and isStateEqual
end

return ItemUserdata
