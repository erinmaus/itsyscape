--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MagicWeapons.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local TIERS = {
	["Dinky"] = {
		tier = 1,
		weight = 8,
		wood = "Common"
	}
}

local ITEMS = {
	["Wand"] = {
		niceName = "%s wand",
		logs = 1
	},


	["Cane"] = {
		niceName = "%s cane",
		logs = 2,
	},

	["Staff"] = {
		niceName = "%s staff",
		logs = 5
	}
}

for name, tier in pairs(TIERS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(tier.tier)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Wisdom",
				Count = ItsyScape.Utility.xpForLevel(tier.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local CraftAction = ItsyScape.Action.Craft()
		CraftAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sLogs", tier.wood)),
				Count = itemProps.logs
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(math.max(tier.tier + itemProps.logs, 1)),
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Knife",
				Count = 1,
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(math.max(tier.tier + itemProps.logs + 2, 1)) * itemProps.logs
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(tier.tier + itemProps.logs + 2) * itemProps.logs,
			Weight = itemProps.logs * tier.weight,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, name),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, itemName),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Wood",
			Value = tier.wood,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			CraftAction
		}
	end
end

-- Dinky (common)
do
	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(4, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(4, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "DinkyWand"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Probably more useful as firewood",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DinkyWand"
	}


	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(4, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(5, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "DinkyCane"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Just what Grandpa needed.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DinkyCane"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(5, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(6, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(6),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "DinkyStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not suitable for epic boss battles.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "DinkyStaff"
	}
end
