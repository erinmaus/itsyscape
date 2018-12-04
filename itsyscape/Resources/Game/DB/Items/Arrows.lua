--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Arrows.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local METALS = {
	["Bronze"] = {
		tier = 1,
		weight = 12.5,
		wood = "CommonLogs",
		hammer = "Hammer"
	}
}

for name, metal in pairs(METALS) do
	local ItemName = string.format("%sArrow", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	ItsyScape.Meta.Item {
		Value = math.min(math.floor(ItsyScape.Utility.valueForItem(metal.tier + 2) / 10), 10) * metal.tier,
		Weight = metal.weight / 10,
		Stackable = 1,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Arrow",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.RangedAmmo {
		Type = ItsyScape.Utility.Equipment.AMMO_ARROW,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s arrow", name),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(metal.tier + 3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER,
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction
	}
end
