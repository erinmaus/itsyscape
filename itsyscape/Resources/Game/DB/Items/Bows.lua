--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bows.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LOGS = {
	["Common"] = {
		tier = 1,
		weight = 8,
		style = "Puny"
	}
}

local ITEMS = {
	["Bow"] = {
		tier = 1,
		niceName = "%s bow"
	},

	["Longbow"] = {
		tier = 5, 
		niceName = "%s longbow"
	}
}


for name, log in pairs(LOGS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", log.style, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Archery",
				Count = ItsyScape.Utility.xpForLevel(log.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(log.tier + itemProps.tier),
			Weight = log.weight,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, log.style),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Wood",
			Value = name,
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", log.style, itemName),
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction
		}
	end
end

-- Common/bronze
do
	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(5, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "PunyBow"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(5, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "PunyLongbow"
	}
end
