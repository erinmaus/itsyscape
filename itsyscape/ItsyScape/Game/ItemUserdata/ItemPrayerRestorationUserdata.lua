--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata/ItemPrayerRestorationUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local ItemPrayerRestorationUserdata = Class(ItemUserdata)

function ItemPrayerRestorationUserdata:new(...)
	ItemUserdata.new(self, ...)

	self.prayerPoints = 0
	self.zealous = false
end

function ItemPrayerRestorationUserdata:setPrayerPoints(value)
	self.prayerPoints = math.max(value, 0)
end

function ItemPrayerRestorationUserdata:getPrayerPoints()
	return self.prayerPoints
end

function ItemPrayerRestorationUserdata:setZealous(zealous)
	self.zealous = value or false
end

function ItemPrayerRestorationUserdata:getZealous()
	return self.zealous
end

function ItemPrayerRestorationUserdata:getDescription()
	if self:getPrayerPoints() == 0 then
		return nil
	end

	if self:getZealous() then
		return self:buildDescription("Message_ItemHealingUserdata_ZealousDescription", self.prayerPoints)
	else
		return self:buildDescription("Message_ItemHealingUserdata_Description", self.prayerPoints)
	end
end

function ItemPrayerRestorationUserdata:combine(otherUserdata)
	if otherUserdata:getType() ~= self:getType() then
		return false
	end

	self:setPrayerPoints(self:getPrayerPoints() + otherUserdata:getPrayerPoints())
	self:setZealous(self:getZealous() and otherUserdata:getZealous())

	return true
end

function ItemPrayerRestorationUserdata:serialize()
	return {
		prayerPoints = self.prayerPoints,
		zealous = self.zealous
	}
end

function ItemPrayerRestorationUserdata:deserialize(data)
	self.prayerPoints = data.prayerPoints
	self.zealous = data.zealous
end

function ItemPrayerRestorationUserdata:fromRecord(record)
	self:setPrayerPoints(record:get("PrayerPoints"))
	self:setZealous(record:get("Zealous") ~= 0)
end

function ItemPrayerRestorationUserdata:apply(peep)
	local combat = peep:getBehavior(CombatStatusBehavior)
	if combat then
		local newPrayerPoints = combat.currentPrayer + self:getPrayerPoints()
		if not self:getZealous() then
			newPrayerPoints = math.min(newPrayerPoints, combat.maximumPrayer)
		else
			newPrayerPoints = math.min(newPrayerPoints, combat.maximumPrayer + self:getPrayerPoints())
		end

		combat.currentPrayer = newPrayerPoints
	end
end

return ItemPrayerRestorationUserdata
