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
	},

	["Iron"] = {
		tier = 10,
		weight = 31,
		hammer = "Hammer"
	},

	["BlackenedIron"] = {
		niceName = "Blackened iron",
		tier = 20,
		weight = 31,
		hammer = "Hammer"
	},

	["Mithril"] = {
		tier = 30,
		weight = 1.3,
		hammer = "Hammer"
	},

	["Adamant"] = {
		tier = 40,
		weight = 25,
		hammer = "Hammer",
		trim = {
			"Gloves",
			"Boots",
			"Helmet",
			"Platebody",
			"Shield"
		}
	},

	["Itsy"] = {
		tier = 50,
		weight = 5,
		hammer = "Hammer"
	}
}

local ITEMS = {
	["Gloves"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s gloves",
		slot = "Gloves",
		bars = 1,
		tier = 0,
		trim = 15
	},

	["Boots"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s boots",
		slot = "Boots",
		bars = 1,
		tier = 0,
		trim = 15
	},

	["Helmet"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s full helmet",
		slot = "Helmet",
		bars = 2,
		tier = 0,
		trim = 20
	},

	["Platebody"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s platebody",
		slot = "Body",
		bars = 5,
		tier = 0,
		trim = 50
	},

	["Shield"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s shield",
		slot = "Shield",
		bars = 3,
		tier = 1,
		trim = 25
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

for name, metal in spairs(METALS) do
	for _, itemName in ipairs(metal.trim or {}) do
		local itemProps = ITEMS[itemName]

		local ItemName = string.format("Trimmed%s%s", name, itemName)
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

		local SmithAction = ItsyScape.Action.Craft()
		SmithAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%s%s", name, itemName)),
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sTrim", name)),
				Count = itemProps.trim or 10
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
			Value = string.format(itemProps.niceName, string.format("Trimmed %s", (metal.niceName or name):lower())),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/Trimmed%s.lua", name, itemProps.slot),
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

		ItsyScape.Utility.tag(Item, "melee")
	end

	for itemName, itemProps in spairs(ITEMS) do
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
			Value = string.format(itemProps.niceName, metal.niceName or name),
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

		ItsyScape.Utility.tag(Item, "melee")
	end
end

-- Bronze
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(2),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(2),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(2),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(2),
		DefenseMagic = 0,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "BronzeGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Now you definitely won't get a papercut.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(2),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(2),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(2),
		DefenseMagic = 0,
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(2),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "BronzeBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not very fashionable.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(4),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(4),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(4),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(4),
		DefenseMagic = 0,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "BronzeHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Better than nothing.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(6),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(6),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(6),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(6),
		DefenseMagic = 0,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "BronzePlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Warning: don't stand on a hill during a lightning storm and curse the gods.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzePlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(10),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(10),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(10),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(10),
		DefenseMagic = 0,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "BronzeShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "At least it's not a wooden shield...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(5, 1.0),
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
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(7, 1.0),
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
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(8, 1.0),
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
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(10, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(10, 0.5),
		DefenseRanged = 1,
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

-- Iron
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(15),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(14),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(13),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(15),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "IronGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Don't let these gloves get wet.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(1),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(15),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(13),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(1),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(7),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "IronBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Awfully heavy for minimal defense.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(1.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(10),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(10),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(10.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "IronHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Useless against a Rust Eater.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(11),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(12),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(11),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(18),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "IronPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Okay protection for your body.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(11),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(12),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(10),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(12),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(7),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "IronShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Blocks pebbles but probably not rocks.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(10),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(11),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "IronDagger"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Submerge it in seawater for a few years and you'll get your own trusty rusty dagger!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronDagger"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(57, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(57),
		Prayer = 12,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "IronMace"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Crushes skulls. If those skulls are made of paper.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronMace"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(15),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "IronLongsword"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "More useful as a butter knife than a sword.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronLongsword"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(15, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(11, 0.6),
		DefenseRanged = 1,
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IronZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "At least there's a cool animation if you use Tornado.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IronZweihander"
	}
end

-- Blackened iron
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(22),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(21),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(23),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(22),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(11),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "BlackenedIronGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Show off your inner goth.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(2),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(24),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(21),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(9),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(20),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "BlackenedIronBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "These would be better if they were platforms.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(2.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(24),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(24),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(25),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(12),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "BlackenedIronHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Look bad ass while slashing and bashing.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(26),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(27),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(26),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(28),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "BlackenedIronPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Completes that classic 'Dark Knight' look!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(27),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(27),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(27),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(28),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(11),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "BlackenedIronShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "I wonder where the red comes from.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(25, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(23),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BlackenedIronDagger"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Perfect for assassins.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronDagger"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(27, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(27),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BlackenedIronMace"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "For those pious ne'er-do-wells.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronMace"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(28, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(28),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "BlackenedIronLongsword"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Look great while slashing at your foes.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronLongsword"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(29, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(29, 0.65),
		DefenseRanged = 1,
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(29),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "BlackenedIronZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Stylishly slay those pesky archery users from afar.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackenedIronZweihander"
	}
end

-- Mithril
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(32),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(31),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(33),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(32),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "MithrilGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lightweight and strong.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(3),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(34),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(31),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(3),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(17),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "MithrilBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Stronger than steel, but lighter than air.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(3.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(34),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(34),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(35),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(23),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "MithrilHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keeps your hair cool and prevents concussions!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(36),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(37),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(36),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(38),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(27),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "MithrilPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Feels like wearing a shirt.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(37),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(37),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(37),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(38),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(22),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "MithrilShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Easy to wield.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(35, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(33),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MithrilDagger"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Sharp!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilDagger"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(37, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(37),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MithrilMace"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Gives great concussions with minimal bounce back.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilMace"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(38, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(38),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "MithrilLongsword"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Sounds like a whistle when slicing.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilLongsword"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(39, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(39, 0.65),
		DefenseRanged = 1,
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(39),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "MithrilZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Perfectly balanced, as all things should be.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MithrilZweihander"
	}
end

-- Adamant
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(42),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(41),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(43),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(42),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(22),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "AdamantGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Now you definitely won't get a papercut.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(41),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(44),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(41),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(27),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(40),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "AdamantBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Makes it hard to run but nearly impossible to stub your toe.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(44),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(44),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(44),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(45),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(30),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "AdamantHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What did you say?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(46),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(47),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(46),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(48),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(27),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "AdamantPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Provides great defense against many types of foes but will fry the user if hit with a spell.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(47),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(44),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(47),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(48),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(30),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "AdamantShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "99% adamant, 1% wooden handle.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(45, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(43),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "AdamantDagger"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A dagger of amazing craftspersonship.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantDagger"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(47, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(47),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "AdamantMace"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Can cave in a skull or three with ease.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantMace"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(48, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(48),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "AdamantLongsword"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Slashes through skin, muscle, and bone like butter.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantLongsword"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(51, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(51, 0.6),
		DefenseRanged = 1,
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(53),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "AdamantZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A formidable weapon that deals heavy damage to foes far away.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantZweihander"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(42),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(41),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(43),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(42),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(22),
		Prayer = 2,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "TrimmedAdamantGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Gloves made in the image of Theodyssius, Bastiel's champion. Where she went after Bastiel's banishment, none know... Or so the Arbiters say.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TrimmedAdamantGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(41),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(44),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(41),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(27),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(40),
		Prayer = 2,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "TrimmedAdamantBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tought boots lined with feathers.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TrimmedAdamantBoots"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = 5,
		AccuracySlash = 5,
		AccuracyCrush = 5,
		DefenseStab = ItsyScape.Utility.styleBonusForHead(44),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(44),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(44),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(45),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(30),
		Prayer = 3,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "TrimmedAdamantHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "No matter where you are, the eye sees.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TrimmedAdamantHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(46),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(47),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(46),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(48),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(27),
		Prayer = 4,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "TrimmedAdamantPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Made of a similar alloy to Theodyssius's platebody. The alloy is lost to history, however, and even scraps are almost worth their weight in gold.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TrimmedAdamantPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(47),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(44),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(47),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(48),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(30),
		Prayer = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "TrimmedAdamantShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A tower shield that requires significant focus to wield.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TrimmedAdamantShield"
	}
end

-- Itsy
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(55),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(54),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(53),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(55),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(30),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "ItsyGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The ultimate protection against animated nail clippers.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(52),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(55),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(53),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(50.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(55),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "ItsyBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "And there's more! These boots are waterproof!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(54),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(50),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(55),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(57),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(35),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "ItsyHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A classic style of helm made of the strongest natural metal.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(61),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(62),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(61),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(58),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(35),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "ItsyPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The only weaknesses? Magic...! And ants.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(55),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(55),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(55),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(60),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(35),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "ItsyShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "No realmly arrow can pierce this shield.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyShield"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(55, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(53),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ItsyDagger"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Unlike most daggers, the antibacterial properties make it safe for cooking... just clean any blood!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyDagger"
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(57, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(57),
		Prayer = 12,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ItsyMace"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A weapon perfect for those who are both pious and strong!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyMace"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(58, 1.0),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(58),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = ItsyScape.Resource.Item "ItsyLongsword"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Slashes through lesser metals like butter.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyLongsword"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(51, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(51, 0.6),
		DefenseRanged = 1,
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "ItsyZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Behead your foes in a single cleave or your money back!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ItsyZweihander"
	}

		ItsyScape.Resource.Item "AdamantTrim" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(40) / 5,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "AdamantTrim"
	}

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Trim",
		XProgressive = "Trimming",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Metal",
		CategoryValue = "Adamant",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "AdamantTrim" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Adamant trim",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantTrim"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An alloy whose alchemy was lost to history after the Old Ones were banished from the Realm. Fragments can be used to trim adamant armor.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AdamantTrim"
	}
end
