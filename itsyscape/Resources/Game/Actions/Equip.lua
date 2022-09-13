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
	local transaction = broker:createTransaction()
	transaction:addParty(inventory)
	transaction:addParty(equipment)
	transaction:transfer(equipment, item, nil, 'equip')
	do
		local gameDB = self:getGameDB()
		local resource = gameDB:getResource(item:getID(), "Item")
		if resource then
			local equipmentRecord = gameDB:getRecords(
				"Equipment", { Resource = resource }, 1)[1]
			if equipmentRecord then
				local slot = equipmentRecord:get("EquipSlot")
				if slot == Equipment.PLAYER_SLOT_TWO_HANDED then
					local leftHandItem = equipment:getEquipped(Equipment.PLAYER_SLOT_LEFT_HAND)
					local rightHandItem = equipment:getEquipped(Equipment.PLAYER_SLOT_RIGHT_HAND)
					local twoHandedItem = equipment:getEquipped(Equipment.PLAYER_SLOT_TWO_HANDED)

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
						local twoHandedItem = equipment:getEquipped(Equipment.PLAYER_SLOT_TWO_HANDED)
						if twoHandedItem then
							transaction:transfer(inventory, twoHandedItem)
						end
					end

					local equippedItem = equipment:getEquipped(slot)
					if equippedItem then
						transaction:transfer(inventory, equippedItem)
					end
				end
			end
		end
	end

	local s, r = transaction:commit()
	if not s then
		io.stderr:write("error: ", r, "\n")
		return false, "transaction failed"
	end

	Action.perform(self, state, peep)
	return true
end

return Equip
