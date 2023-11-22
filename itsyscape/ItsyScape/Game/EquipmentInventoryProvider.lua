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
EquipmentInventoryProvider.STATS = Equipment.STATS

function EquipmentInventoryProvider:new(peep, slots)
	InventoryProvider.new(self)

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
			return item, broker:getItemTag(item, 'equip-record')
		end
	end

	return nil
end

function EquipmentInventoryProvider:assignKey(item)
	local itemManager = self.peep:getDirector():getItemManager()

	local logic = itemManager:getLogic(item:getID())
	if not logic then
		Log.error("Logic for item '%s' not found.", item:getID())
	elseif logic:isCompatibleType(Equipment) then
		local s, e = xpcall(logic.onEquip, debug.traceback, logic, self.peep, item)
		if not s then
			Log.warn("Couldn't run equip logic for '%s': %s", item:getID(), e)
		end

		self:getPeep():poke('equipItem', {
			item = item,
			count = item:getCount()
		})
	end

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

	self:getPeep():poke('spawnEquipment', {
		item = item,
		count = count
	})
end

function EquipmentInventoryProvider:onTransferTo(item, source, count, purpose)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

function EquipmentInventoryProvider:onTransferFrom(destination, item, count, purpose)
	local broker = self:getBroker()

	local itemManager = self.peep:getDirector():getItemManager()
	local logic = itemManager:getLogic(item:getID())
	if logic:isCompatibleType(Equipment) then
		local s, e = xpcall(logic.onDequip, debug.traceback, logic, self.peep, item)
		if not s then
			Log.warn("Couldn't run dequip logic for '%s': %s", item:getID(), e)
		end
	end

	local equipStatsTag = broker:getItemTag(item, 'equip-record')
	if equipStatsTag then
		for i = 1, #EquipmentInventoryProvider.STATS do
			local stat = EquipmentInventoryProvider.STATS[i]
			self.stats[stat] = self.stats[stat] - equipStatsTag:get(stat)
		end
	end

	local existingKey = broker:getItemKey(item)
	local isDifferentItemInKey
	do
		for existingItem in broker:iterateItemsByKey(self, existingKey) do
			if broker:getItemRef(existingItem) ~= broker:getItemRef(item) then
				isDifferentItemInKey = true
			end
		end
	end

	if not isDifferentItemInKey then
		local equipSlotTag = broker:getItemTag(item, 'equip-slot')
		local equipModelTag = broker:getItemTag(item, 'equip-model')

		if equipSlotTag and equipModelTag and existingKey then
			local actor = self.peep:getBehavior(ActorReferenceBehavior)
			if actor.actor then
				actor = actor.actor

				local ref = CacheRef(
					equipModelTag:get("Type"),
					equipModelTag:get("Filename"))
				actor:unsetSkin(equipSlotTag, Equipment.SKIN_PRIORITY_EQUIPMENT, ref)
			end
		end
	end

	self:getPeep():poke('dequipItem', {
		item = item,
		count = count
	})
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