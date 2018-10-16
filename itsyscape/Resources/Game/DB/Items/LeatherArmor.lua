--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/LeatherArmor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LEATHERS = {
	["MooishLeather"] = {
		name = "Mooish leather",
		tier = 1,
		weight = 2,
		thread = "PlainThread"
	}
}

local ITEMS = {
	["Gloves"] = {
		niceName = "%s gloves",
		slot = "Gloves",
		hides = 1
	},

	["Boots"] = {
		niceName = "%s boots",
		slot = "Boots",
		hides = 1
	},

	["Coif"] = {
		niceName = "%s coif",
		slot = "Coif",
		hides = 2
	},

	["Body"] = {
		niceName = "%s body",
		slot = "Body",
		hides = 5
	},
}

for name, leather in pairs(LEATHERS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Defense",
				Count = ItsyScape.Utility.xpForLevel(leather.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local CraftAction = ItsyScape.Action.Craft()
		CraftAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sHide", name)),
				Count = itemProps.hides
			},

			Input {
				Resource = ItsyScape.Resource.Item(leather.thread),
				Count = math.floor(itemProps.hides * 1.5)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Needle",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier + itemProps.hides, 1))
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(math.max(leather.tier + itemProps.hides + 2, 1)) * itemProps.hides
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(leather.tier + itemProps.hides + 2) * itemProps.hides,
			Weight = leather.weight * itemProps.hides,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, leather.name),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, itemProps.slot),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Leather",
			Value = name,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			CraftAction
		}
	end
end

-- Leather
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(1, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "MooishLeatherGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(1, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "MooishLeatherBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(2, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(4, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "MooishLeatherCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(3, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(3, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(3, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(7, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(3, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "MooishLeatherBody"
	}
end
