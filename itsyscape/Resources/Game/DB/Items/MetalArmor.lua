--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MetalArmor.lua
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
		weight = 12.5
	}
}

local ITEMS = {
	["Gloves"] = {
		niceName = "%s gloves",
		slot = "Gloves",
		bars = 1
	},

	["Boots"] = {
		niceName = "%s boots",
		slot = "Boots",
		bars = 1
	},

	["Helmet"] = {
		niceName = "%s full helmet",
		slot = "Helmet",
		bars = 2
	},

	["Platebody"] = {
		niceName = "%s platebody",
		slot = "Body",
		bars = 5
	},
}

for name, metal in pairs(METALS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Defense",
				Count = ItsyScape.Utility.xpForLevel(metal.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local SmithAction = ItsyScape.Action.Smith()
		SmithAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
				Count = itemProps.bars
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(math.max(metal.tier + itemProps.bars, 1))
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(math.max(metal.tier + itemProps.bars + 2, 1)) * itemProps.bars
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(metal.tier + itemProps.bars + 2) * itemProps.bars,
			Weight = metal.weight,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, name),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, itemProps.slot),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Metal",
			Value = name,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			SmithAction
		}
	end
end

-- Bronze
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(2, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(2, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(2, 1),
		DefenseMagic = -ItsyScape.Utility.styleBonusForItem(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "BronzeGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(2, 0.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(2, 0.2),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(2, 1),
		DefenseMagic = -ItsyScape.Utility.styleBonusForItem(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "BronzeBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(4, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(4, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(4, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(4, 1),
		DefenseMagic = -ItsyScape.Utility.styleBonusForItem(4, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "BronzeHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(6, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(6, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(6, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(6, 1),
		DefenseMagic = -ItsyScape.Utility.styleBonusForItem(6, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "BronzePlatebody"
	}
end
