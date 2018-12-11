--------------------------------------------------------------------------------
-- ItsyScape/Game/RangedWeapon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Equipment = require "ItsyScape.Game.Equipment"

local RangedWeapon = Class(Weapon)

function RangedWeapon:getAmmo(peep)
	-- TODO: Make "Ammo" item type.
	-- Query Ammo item for info.
	local quiver = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_QUIVER)
	if quiver then
		local gameDB = self:getManager():getGameDB()
		local ammo = gameDB:getRecord("RangedAmmo", {
			Resource = gameDB:getResource(quiver:getID(), "Item")
		})

		if ammo then
			return ammo:get("Type") or Equipment.AMMO_NONE, quiver
		end
	end

	return Equipment.AMMO_NONE, nil
end

function RangedWeapon:getIsTwoHanded()
	if self.isTwoHanded == nil then
		local id = self:getID()
		local gameDB = self:getManager():getGameDB()

		local equipmentRecord = gameDB:getRecord()
		if equipmentRecord then
			local slot = equipmentRecord:get("EquipSlot")
			if slot and slot ~= Equipment.PLAYER_SLOT_TWO_HANDED then
				self.isTwoHanded = false
			else
				self.isTwoHanded = true
			end
		else
			self.isTwoHanded = true
		end
	end

	return self.isTwoHanded
end

function RangedWeapon:getAmmoType()
	if not self.AMMO then
		error("no default ammo type provided")
	end

	return self.AMMO
end

function RangedWeapon:perform(peep, target)
	local FLAGS = {
		['item-equipment-slot'] = true,
		['item-equipment'] = true
	}

	local ammoType, ammo = self:getAmmo(peep)
	if ammoType == Equipment.AMMO_ANY or ammoType == self:getAmmoType() then
		if peep:getState():take("Item", Equipment.PLAYER_SLOT_QUIVER, 1, FLAGS) then
			Weapon.perform(self, peep, target)

			return
		end
	end

	Log.info('No ammo in quiver, or not right type of ammo.')

	peep:onActionFailed({
		requirements = {
			{
				type = "Item",
				resource = "BronzeArrow",
				name = "Proper ammunition (in quiver).",
				count = 1
			}
		}
	})

	self:applyCooldown(peep)
end

function RangedWeapon:getBonusForStance(peep)
	return Weapon.BONUS_ARCHERY
end

function RangedWeapon:getAttackRange(peep)
	return 6
end

function RangedWeapon:getStyle()
	return Weapon.STYLE_ARCHERY
end

return RangedWeapon
