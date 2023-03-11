--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata/ItemHealingBoostUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"

local ItemHealingBoostUserdata = Class(ItemUserdata)

function ItemHealingBoostUserdata:new(...)
	ItemUserdata.new(self, ...)

	self.hitpoints = 0
	self.zealous = false
end

function ItemHealingBoostUserdata:setHitpoints(value)
	self.hitpoints = math.max(value, 0)
end

function ItemHealingBoostUserdata:getHitpoints()
	return self.hitpoints
end

function ItemHealingBoostUserdata:setZealous(zealous)
	self.zealous = value or false
end

function ItemHealingBoostUserdata:getZealous()
	return self.zealous
end

function ItemHealingBoostUserdata:getDescription()
	if self:getHitpoints() == 0 then
		return nil
	end

	if self:getZealous() then
		return self:buildDescription("Message_ItemHealingUserdata_ZealousDescription", self.hitpoints)
	else
		return self:buildDescription("Message_ItemHealingUserdata_Description", self.hitpoints)
	end
end

function ItemHealingBoostUserdata:combine(otherUserdata)
	if otherUserdata:getType() ~= self:getType() then
		return false
	end

	self:setHitpoints(self:getHitpoints() + otherUserdata:getHitpoints())
	self:setZealous(self:getZealous() and otherUserdata:getZealous())

	return true
end

function ItemHealingBoostUserdata:serialize()
	return {
		hitpoints = self.hitpoints,
		zealous = self.zealous
	}
end

function ItemHealingBoostUserdata:deserialize(data)
	self.hitpoints = data.hitpoints
	self.zealous = data.zealous
end

function ItemHealingBoostUserdata:fromRecord(record)
	self:setHitpoints(record:get("Hitpoints"))
	self:setZealous(record:get("Zealous") ~= 0)
end

return ItemHealingBoostUserdata
