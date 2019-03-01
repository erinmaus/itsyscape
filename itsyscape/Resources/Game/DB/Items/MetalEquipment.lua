--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MetalEquipment.lua
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
		hammer = "Hammer"
	}
}

local ITEMS = {
	["Gloves"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s gloves",
		slot = "Gloves",
		bars = 1,
		tier = 0
	},

	["Boots"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s boots",
		slot = "Boots",
		bars = 1,
		tier = 0
	},

	["Helmet"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s full helmet",
		slot = "Helmet",
		bars = 2,
		tier = 0
	},

	["Platebody"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s platebody",
		slot = "Body",
		bars = 5,
		tier = 0
	},

	["Shield"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s shield",
		slot = "Shield",
		bars = 3,
		tier = 1
	},

	["Dagger"] = {
		skills = { "Attack" },
		niceName = "%s dagger",
		slot = "Dagger",
		bars = 1,
		tier = -1
	},

	["Mace"] = {
		skills = { "Strength" },
		niceName = "%s mace",
		slot = "Mace",
		bars = 1,
		tier = 2
	},

	["Longsword"] = {
		skills = { "Strength", "Attack" },
		niceName = "%s longsword",
		slot = "Longsword",
		bars = 3,
		tier = 2
	},

	["Zweihander"] = {
		skills = { "Strength", "Attack" },
		niceName = "%s zweihander",
		slot = "Zweihander",
		bars = 5,
		tier = 4
	}
}

for name, metal in pairs(METALS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip()
		for i = 1, #itemProps.skills do
			EquipAction {
				Requirement {
					Resource = ItsyScape.Resource.Skill(itemProps.skills[i]),
					Count = ItsyScape.Utility.xpForLevel(metal.tier)
				}
			}
		end

		local DequipAction = ItsyScape.Action.Dequip()

		local SmithAction = ItsyScape.Action.Smith()
		SmithAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
				Count = itemProps.bars
			},

			Requirement {
				Resource = ItsyScape.Resource.Item(metal.hammer),
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(math.max(metal.tier + itemProps.bars + itemProps.tier, 1))
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(math.max(metal.tier + itemProps.bars + itemProps.tier + 2, 1)) * itemProps.bars
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(metal.tier + itemProps.bars + itemProps.tier + 2) * itemProps.bars,
			Weight = metal.weight * itemProps.bars,
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

	ItsyScape.Meta.ResourceDescription {
		Value = "Now you definitely won't get a papercut.",
		Language = "en-US",
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

	ItsyScape.Meta.ResourceDescription {
		Value = "Not very fashionable.",
		Language = "en-US",
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

	ItsyScape.Meta.ResourceDescription {
		Value = "Better than nothing.",
		Language = "en-US",
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

	ItsyScape.Meta.ResourceDescription {
		Value = "Warning: don't stand on a hill during a lightning storm and curse the gods.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzePlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10, 0.4),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 0.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(10, 0.5),
		DefenseMagic = -ItsyScape.Utility.styleBonusForItem(10, 0.1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "BronzeShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "At least it's not a wooden shield...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(5, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BronzeDagger"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not very useful for culinary duties.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeDagger"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(7, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(7),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BronzeMace"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Doesn't draw blood, so valued as a weapon by the pious.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeMace"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(8, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(8),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BronzeLongsword"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The epitome of the bronze age.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeLongsword"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForItem(10, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 0.5),
		DefenseRanged = 1,
		DefenseMagic = -ItsyScape.Utility.styleBonusForItem(6, 0.1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(10),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "BronzeZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Heavy and unwieldy, but with enough skill, can do some serious damage.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeZweihander"
	}
end
