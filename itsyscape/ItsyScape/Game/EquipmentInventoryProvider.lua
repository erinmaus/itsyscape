--------------------------------------------------------------------------------
-- ItsyScape/Game/EquipmentInventoryProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local EquipmentInventoryProvider = Class(InventoryProvider)
EquipmentInventoryProvider.STATS = {
	"AccuracyStab",
	"AccuracySlash",
	"AccuracyCrush",
	"AccuracyMagic",
	"AccuracyRanged",
	"DefenseStab",
	"DefenseSlash",
	"DefenseCrush",
	"DefenseMagic",
	"DefenseRanged",
	"StrengthMelee",
	"StrengthRanged",
	"StrengthMagic",
	"Prayer"
}

function EquipmentInventoryProvider:new(peep, slots)
	self.peep = peep
	self.stats = {}

	for i = 1, #EquipmentInventoryProvider.STATS do
		local stat = EquipmentInventoryProvider.STATS[i]
		self.stats[stat] = 0
	end
end

function EquipmentInventoryProvider:getPeep()
	return self.peep
end

function EquipmentInventoryProvider:getMaxInventorySpace()
	return math.huge
end

-- Returns the first equipped item in 'slot'.
function EquipmentInventoryProvider:getEquipped(slot)
	local broker = self:getBroker()
	if broker then
		for item in broker:iterateItemsByKey(self, slot) do
			return item
		end
	end

	return nil
end

function EquipmentInventoryProvider:assignKey(item)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(item:getID(), "Item")
	local equipmentRecord = gameDB:getRecords(
		"Equipment", { Resource = resource }, 1)[1]
	if equipmentRecord then
		local slot = equipmentRecord:get("EquipSlot")
		if slot then
			self:getBroker():setItemKey(item, slot)
			self:getBroker():tagItem(item, 'equip-record', equipmentRecord)
			self:getBroker():tagItem(item, 'equip-slot', slot)

			for i = 1, #EquipmentInventoryProvider.STATS do
				local stat = EquipmentInventoryProvider.STATS[i]
				self.stats[stat] = self.stats[stat] + equipmentRecord:get(stat)
			end
		end

		local equipmentModelRecord = gameDB:getRecords(
			"EquipmentModel", { Resource = resource }, 1)[1]
		if equipmentModelRecord then
			local actor = self.peep:getBehavior(ActorReferenceBehavior)
			if actor.actor then
				actor = actor.actor

				local ref = CacheRef(
					equipmentModelRecord:get("Type"),
					equipmentModelRecord:get("Filename"))
				actor:setSkin(slot, Equipment.SKIN_PRIORITY_EQUIPMENT, ref)

				self:getBroker():tagItem(item, 'equip-model', equipmentModelRecord)
			end
		end
	end
end

function EquipmentInventoryProvider:onSpawn(item, count)
	self:assignKey(item)
end

function EquipmentInventoryProvider:onTransferTo(item, source, count, purpose)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

function EquipmentInventoryProvider:onTransferFrom(destination, item, count, purpose)
	local equipStatsTag = self:getBroker():getItemTag(item, 'equip-record')
	if equipStatsTag then
		for i = 1, #EquipmentInventoryProvider.STATS do
			local stat = EquipmentInventoryProvider.STATS[i]
			self.stats[stat] = self.stats[stat] - equipStatsTag:get(stat)
		end
	end

	local equipSlotTag = self:getBroker():getItemTag(item, 'equip-slot')
	local equipModelTag = self:getBroker():getItemTag(item, 'equip-model')
	if equipSlotTag and equipModelTag then
		local actor = self.peep:getBehavior(ActorReferenceBehavior)
		if actor.actor then
			actor = actor.actor

			local ref = CacheRef(
				equipModelTag:get("Type"),
				equipModelTag:get("Filename"))
			actor:unsetSkin(equipSlotTag, ref)
		end
	end
end

function EquipmentInventoryProvider:getStat(stat)
	return self.stats[stat] or 0
end

function EquipmentInventoryProvider:getStats()
	local index = 1
	return function()
		local stat = EquipmentInventoryProvider.STATS[index]
		if index <= #EquipmentInventoryProvider.STATS then
			index = index + 1
		end

		if stat then
			return stat, self.stats[stat] or 0
		else
			return nil, nil
		end
	end
end

function EquipmentInventoryProvider:load(...)
	InventoryProvider.load(self, ...)

	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Equipment")
	if storage then
		for key, section in storage:iterateSections() do
			local item = broker:itemFromStorage(self, section)
			self:assignKey(item)
		end
	end
end

function EquipmentInventoryProvider:unload(...)
	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Equipment", true)
	if storage then
		local index = 1
		for item in broker:iterateItems(self) do
			broker:itemToStorage(item, storage, index)
			index = index + 1
		end
	end

	InventoryProvider.unload(self, ...)
end

return EquipmentInventoryProvider