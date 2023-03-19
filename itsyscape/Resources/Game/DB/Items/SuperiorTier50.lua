--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/SuperiorTier50.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ARMOR = {
	["AncientCeremonial"] = {
		name = "AncientCeremonial",
		niceName = "Ancient ceremonial",
		category = "Fabric",
		tags = { "magic" },
		action = "Craft",
		tier = 55,
		weight = 3.2,
		tool = "Needle",
		primary = "ZealotSilk",
		secondary = "GildedDragonBones",
		skills = { "Crafting", "Magic" },

		items = {
			{
				skills = { "Magic", "Wisdom" },
				name = "Gloves",
				slot = "Gloves",
				niceName = "%s gloves",
				count = 1
			},
			{
				skills = { "Magic", "Wisdom" },
				name = "Boots",
				slot = "Boots",
				niceName = "%s boots",
				count = 1
			},
			{
				skills = { "Magic", "Wisdom" },
				name = "Helm",
				slot = "Helmet",
				niceName = "%s helm",
				count = 1
			},
			{
				skills = { "Magic", "Wisdom" },
				name = "Robe",
				slot = "Body",
				niceName = "%s robe",
				count = 1
			},
		}
	},

	["Itsy"] = {
		name = "SuperiorItsy",
		niceName = "Superior itsy",
		category = "Metal",
		tags = { "melee" },
		action = "Smith",
		tier = 55,
		weight = 5,
		tool = "Hammer",
		primary = "ItsyBar",
		secondary = "GildedDragonBones",
		skills = { "Smithing" },

		items = {
			{
				skills = { "Attack", "Strength" },
				name = "Gloves",
				slot = "Gloves",
				niceName = "%s gloves",
				count = 1
			},
			{
				skills = { "Attack", "Strength" },
				name = "Boots",
				slot = "Boots",
				niceName = "%s boots",
				count = 1,
			},
			{
				skills = { "Attack", "Strength" },
				name = "Helmet",
				slot = "Helmet",
				niceName = "%s helmet",
				count = 2
			},
			{
				skills = { "Attack", "Strength" },
				name = "Platebody",
				slot = "Body",
				niceName = "%s platebody",
				count = 5
			},
			{
				skills = { "Defense", "Attack", "Strength" },
				name = "Shield",
				slot = "Shield",
				niceName = "%s shield",
				count = 3
			}
		}
	}
}

for name, armor in spairs(ARMOR) do
	for _, itemProps in ipairs(armor.items) do
		local ItemName = string.format("%s%s", armor.name, itemProps.name)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip()
		for i = 1, #itemProps.skills do
			EquipAction {
				Requirement {
					Resource = ItsyScape.Resource.Skill(itemProps.skills[i]),
					Count = ItsyScape.Utility.xpForLevel(armor.tier)
				}
			}
		end

		local DequipAction = ItsyScape.Action.Dequip()

		local MakeAction = ItsyScape.Action[armor.action]()
		do
			MakeAction {
				Input {
					Resource = ItsyScape.Resource.Item(armor.primary),
					Count = itemProps.count
				},

				Input {
					Resource = ItsyScape.Resource.Item(armor.secondary),
					Count = itemProps.count
				}
			}

			for i = 1, #armor.skills do
				MakeAction {
					Requirement {
						Resource = ItsyScape.Resource.Skill(armor.skills[i]),
						Count = ItsyScape.Utility.xpForLevel(math.max(armor.tier + itemProps.count, 1))
					}
				}
			end

			MakeAction {
				Requirement {
					Resource = ItsyScape.Resource.Item(armor.tool),
					Count = 1
				},

				Output {
					Resource = Item,
					Count = 1
				}
			}

			for i = 1, #armor.skills do
				MakeAction {
					Output {
						Resource = ItsyScape.Resource.Skill(armor.skills[i]),
						Count = ItsyScape.Utility.xpForResource(math.max(armor.tier + itemProps.count, 1))
					}
				}
			end
		end

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(armor.tier + itemProps.count + 2) * itemProps.count * 3,
			Weight = armor.weight * itemProps.count,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, armor.niceName),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", armor.name, itemProps.slot),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = armor.category,
			Value = name,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			MakeAction
		}

		for i = 1, #armor.tags do
			ItsyScape.Utility.tag(Item, armor.tags[i])
		end
	end
end

-- Ancient ceremonial
do
	ItsyScape.Meta.Equipment {
		AccuracyMagic  = ItsyScape.Utility.styleBonusForWeapon(50, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
		DefenseStab    = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
		DefenseSlash   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
		DefenseCrush   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
		DefenseMagic   = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
		DefenseRanged  = ItsyScape.Utility.styleBonusForItem(25, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
		Prayer         = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A helmet made out of gold invoking the divine protection of The Empty King.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic  = ItsyScape.Utility.styleBonusForWeapon(45, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		DefenseStab    = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
		DefenseSlash   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
		DefenseCrush   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
		DefenseMagic   = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
		DefenseRanged  = ItsyScape.Utility.styleBonusForItem(25, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
		StrengthMagic  = ItsyScape.Utility.strengthBonusForWeapon(45, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		Prayer         = 10,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Fine silk that smells like lavender even after a thousand years.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic  = ItsyScape.Utility.styleBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		DefenseStab    = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		DefenseSlash   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		DefenseCrush   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		DefenseMagic   = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		DefenseRanged  = ItsyScape.Utility.styleBonusForItem(25, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		StrengthMagic  = ItsyScape.Utility.strengthBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
		Prayer         = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Somehow enchanted with the grace of the ancient wizard these were inspired by.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab    = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
		DefenseSlash   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
		DefenseCrush   = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
		DefenseMagic   = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
		DefenseRanged  = ItsyScape.Utility.styleBonusForItem(25, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
		StrengthMagic  = ItsyScape.Utility.strengthBonusForWeapon(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
		Prayer         = 6,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Gives you the strength of a thousand wizards.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
	}
end

-- Superior itsy
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(15, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(14, 0.4),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(13, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(15, 1.1),
		AccuracySlash = ItsyScape.Utility.styleBonusForItem(10, 1),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(10, 1),
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(10, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "SuperiorItsyGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "These gloves somehow make you more skilled with melee weapons.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SuperiorItsyGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(13, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(15, 0.6),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(13, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(35, 0.8),
		AccuracySlash = ItsyScape.Utility.styleBonusForItem(9, 1),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(9, 1),
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(9, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(20),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "SuperiorItsyBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "These boots help you kick some serious ass.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SuperiorItsyBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(20, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(20, 0.4),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(20, 0.9),
		AccuracySlash = ItsyScape.Utility.styleBonusForItem(15, 1),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(15, 1),
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(15, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(16),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "SuperiorItsyHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Don't let the fancy looks deceive you--this helmet will allow your stare alone to hurt opponents.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SuperiorItsyHelmet"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(21, 0.6),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(22, 0.7),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(21, 0.7),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(28, 1),
		AccuracySlash = ItsyScape.Utility.styleBonusForItem(20, 1),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(20, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(25),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "SuperiorItsyPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Provides incredible offensive abilities at the cost of defense.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SuperiorItsyPlatebody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(65, 0.7),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(65, 0.7),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(65, 0.7),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(65, 1),
		AccuracySlash = ItsyScape.Utility.styleBonusForItem(5, 1),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(5, 1),
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(5, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(10),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "SuperiorItsyShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Unlike the rest of the superior itsy equipment, it somehow provides increased defensive capabilities on top of the offensive prowess.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SuperiorItsyShield"
	}
end
