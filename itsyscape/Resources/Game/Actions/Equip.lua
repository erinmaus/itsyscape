--------------------------------------------------------------------------------
-- Resources/Game/Actions/Equip.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"

local Equip = Class(Action)
Equip.SCOPES = { ['inventory'] = true }

function Equip:canPerform(state)
	return Action.canPerform(self, state, { ["item-inventory"] = true })
end

function Equip:perform(state, peep, item, target)
	if not self:canPerform(state) then
		return false
	end

	local director = peep:getDirector()
	local inventory = peep:getBehavior(InventoryBehavior)
	local equipment = (target or peep):getBehavior(EquipmentBehavior)
	if inventory and inventory.inventory and
	   equipment and equipment.equipment
	then
		inventory = inventory.inventory
		equipment = equipment.equipment
	else
		return false, "no inventory"
	end

	local broker = director:getItemBroker()
	local itemKeyInInventory = broker:getItemKey(item)

	local transaction = broker:createTransaction()
	transaction:addParty(inventory)
	transaction:addParty(equipment)
	transaction:transfer(equipment, item, nil, 'equip')

	local leftHandItem, rightHandItem, twoHandedItem, equippedItem
	local slot
	do
		local gameDB = self:getGameDB()
		local resource = gameDB:getResource(item:getID(), "Item")
		if resource then
			local equipmentRecord = gameDB:getRecords(
				"Equipment", { Resource = resource }, 1)[1]
			if equipmentRecord then
				slot = equipmentRecord:get("EquipSlot")
				if slot == Equipment.PLAYER_SLOT_TWO_HANDED then
					leftHandItem = equipment:getEquipped(Equipment.PLAYER_SLOT_LEFT_HAND)
					rightHandItem = equipment:getEquipped(Equipment.PLAYER_SLOT_RIGHT_HAND)
					twoHandedItem = equipment:getEquipped(Equipment.PLAYER_SLOT_TWO_HANDED)

					if leftHandItem then
						transaction:transfer(inventory, leftHandItem, nil, 'equip')
					end

					if rightHandItem then
						transaction:transfer(inventory, rightHandItem, nil, 'equip')
					end

					if twoHandedItem then
						transaction:transfer(inventory, twoHandedItem, nil, 'equip')
					end
				else
					if slot == Equipment.PLAYER_SLOT_RIGHT_HAND or
					   slot == Equipment.PLAYER_SLOT_LEFT_HAND
					then
						twoHandedItem = equipment:getEquipped(Equipment.PLAYER_SLOT_TWO_HANDED)
						if twoHandedItem then
							transaction:transfer(inventory, twoHandedItem)
						end
					end

					equippedItem = equipment:getEquipped(slot)
					if equippedItem and not (equippedItem:isStackable() and equippedItem:getID() == item:getID()) then
						transaction:transfer(inventory, equippedItem)
					else
						equippedItem = nil
					end
				end
			end
		end
	end

	if not slot then
		Log.warn(
			"Item '%s' doesn't have an equipment slot associated with it; cannot equip '%s' (from inventory of '%s').",
			item:getID(), (target or peep):getName(), peep:getName())

		return false, "new item doesn't have slot"
	end

	local s, r = transaction:commit()
	if not s then
		io.stderr:write("error: ", r, "\n")
		return false, "transaction failed"
	end

	if not equippedItem then
		if leftHandItem or rightHandItem or twoHandedItem then
			if slot == Equipment.PLAYER_SLOT_LEFT_HAND then
				equippedItem = leftHandItem or twoHandedItem
			elseif slot == Equipment.PLAYER_SLOT_RIGHT_HAND then
				equippedItem = rightHandItem or twoHandedItem
			elseif slot == Equipment.PLAYER_SLOT_TWO_HANDED then
				equippedItem = rightHandItem or leftHandItem or twoHandedItem
			end
		end
	end

	if equippedItem then
		Log.info(
			"Dequipped item '%s' was in slot '%s'; trying to ensure equipped item goes to key (aka inventory slot) '%d'.",
			equippedItem:getID(), Equipment.PLAYER_SLOT_NAMES[slot], itemKeyInInventory)

		local key = broker:getItemKey(equippedItem)
		if key ~= itemKeyInInventory and itemKeyInInventory then
			Log.info("Dequipped item '%s' has key %d, want %d.", equippedItem:getID(), key, itemKeyInInventory)

			local existingItemAtKey
			for item in broker:iterateItemsByKey(inventory, itemKeyInInventory) do
				existingItemAtKey = item
				break
			end

			if existingItemAtKey then
				Log.info("Existing item '%s' at slot %d; temporarily unassigning key.", existingItemAtKey:getID(), itemKeyInInventory)
				broker:setItemKey(existingItemAtKey, nil)
			end

			Log.info("Setting dequipped item key to %d.", itemKeyInInventory)
			broker:setItemKey(equippedItem, itemKeyInInventory)

			if existingItemAtKey then
				Log.info("Re-assigning blocking item '%s' to a different slot.", existingItemAtKey:getID())
				inventory:assignKey(existingItemAtKey)
				Log.info("Reassigned blocking item '%s' to key %d.", existingItemAtKey:getID(), broker:getItemKey(existingItemAtKey) or -1)
			end
		end
	end

	Action.perform(self, state, peep)
	return true
end

return Equip
