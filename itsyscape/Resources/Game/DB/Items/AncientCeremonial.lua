--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/AncientCeremonial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "AncientCeremonialHelm" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(50)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	Prayer         = 5,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/AncientCeremonial/Helmet.lua",
	Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(66) * 3,
	Weight = 15,
	Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient ceremonial helm",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A helmet made out of gold invoking the divine protection of The Empty King.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialHelm"
}

ItsyScape.Resource.Item "AncientCeremonialRobe" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(50)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	Prayer         = 10,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/AncientCeremonial/Body.lua",
	Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(67) * 5,
	Weight = 35,
	Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient ceremonial robes",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Fine silk that smells like lavender even after a thousand years.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialRobe"
}

ItsyScape.Resource.Item "AncientCeremonialGloves" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(50)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracyStab   = ItsyScape.Utility.styleBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	AccuracySlash  = ItsyScape.Utility.styleBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	AccuracyCrush  = ItsyScape.Utility.styleBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	AccuracyMagic  = ItsyScape.Utility.styleBonusForWeapon(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	Prayer         = 5,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/AncientCeremonial/Gloves.lua",
	Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(65),
	Weight = 35,
	Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient ceremonial gloves",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Somehow enchanted with the grace of the ancient warrior these were taken from.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialGloves"
}

ItsyScape.Resource.Item "AncientCeremonialBoots" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(50)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	StrengthMelee  = ItsyScape.Utility.strengthBonusForWeapon(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	StrengthMagic  = ItsyScape.Utility.strengthBonusForWeapon(40, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	Prayer         = 6,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/AncientCeremonial/Boots.lua",
	Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(65) * 2,
	Weight = 35,
	Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient ceremonial boots",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Gives you the strength of a thousand warriors.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientCeremonialBoots"
}

ItsyScape.Resource.Item "AncientZweihander" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(50)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracySlash  = ItsyScape.Utility.styleBonusForWeapon(70),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(70, 0.5),
	DefenseRanged  = 1,
	StrengthMelee  = ItsyScape.Utility.strengthBonusForWeapon(70),
	Prayer         = 25,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/AncientCeremonial/Zweihander.lua",
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(75) * 5,
	Weight = 20,
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient zweihander",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Capable of slaying all but the toughest of foes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

