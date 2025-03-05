--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata/ItemHealingUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"

local ItemHealingUserdata = Class(ItemUserdata)

function ItemHealingUserdata:new(...)
	ItemUserdata.new(self, ...)

	self.hitpoints = 0
	self.zealous = false
end

function ItemHealingUserdata:setHitpoints(value)
	self.hitpoints = math.max(value, 0)
end

function ItemHealingUserdata:getHitpoints()
	return self.hitpoints
end

function ItemHealingUserdata:setZealous(zealous)
	self.zealous = value or false
end

function ItemHealingUserdata:getZealous()
	return self.zealous
end

function ItemHealingUserdata:getDescription()
	if self:getHitpoints() == 0 then
		return nil
	end

	if self:getZealous() then
		return self:buildDescription("Message_ItemHealingUserdata_ZealousDescription", self.hitpoints)
	else
		return self:buildDescription("Message_ItemHealingUserdata_Description", self.hitpoints)
	end
end

function ItemHealingUserdata:combine(otherUserdata)
	if otherUserdata:getType() ~= self:getType() then
		return false
	end

	self:setHitpoints(self:getHitpoints() + otherUserdata:getHitpoints())
	self:setZealous(self:getZealous() and otherUserdata:getZealous())

	return true
end

function ItemHealingUserdata:serialize()
	return {
		hitpoints = self.hitpoints,
		zealous = self.zealous
	}
end

function ItemHealingUserdata:deserialize(data)
	self.hitpoints = data.hitpoints
	self.zealous = data.zealous
end

function ItemHealingUserdata:fromRecord(record)
	self:setHitpoints(record:get("Hitpoints"))
	self:setZealous(record:get("Zealous") ~= 0)
end

function ItemHealingUserdata:apply(peep)
	peep:poke('heal', { hitPoints = self.hitpoints, zealous = self.zealous })
end

return ItemHealingUserdata
