--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "GanymedesHat" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(99)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(99)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(50, 1),
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(90, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(95, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(100, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(125, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(99, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "GanymedesHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Ganymede/Hat.lua",
	Resource = ItsyScape.Resource.Item "GanymedesHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(115) * 2,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "GanymedesHat"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Such a light fabric, keeping the sun out of the eyes, improving accuracy.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesHat"
}

ItsyScape.Resource.Item "GanymedesBoots" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(99)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(99)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(90, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(90, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(95, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(130, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "GanymedesBoots"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Ganymede/Boots.lua",
	Resource = ItsyScape.Resource.Item "GanymedesBoots"
}

ItsyScape.Meta.ResourceDescription {
	Value = "These boots make you light as air...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesBoots"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(110),
	Weight = -100,
	Resource = ItsyScape.Resource.Item "GanymedesBoots"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's boots",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesBoots"
}

ItsyScape.Resource.Item "GanymedesLightGloves" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(99)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(99)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(95, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(95, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(95, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(50, 1.1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "GanymedesLightGloves"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Ganymede/Gloves.lua",
	Resource = ItsyScape.Resource.Item "GanymedesLightGloves"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(115),
	Weight = 0,
	Resource = ItsyScape.Resource.Item "GanymedesLightGloves"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's gloves",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesLightGloves"
}

ItsyScape.Meta.ResourceDescription {
	Value = "With a magical grip, allows you to draw your arrow more ferociously.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesLightGloves"
}

ItsyScape.Resource.Item "GanymedesTunic" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(99)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(99)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(60, 1.1),
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(105, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(120, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(125, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(120, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60, 1.1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "GanymedesTunic"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Ganymede/Body.lua",
	Resource = ItsyScape.Resource.Item "GanymedesTunic"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120) * 5,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "GanymedesTunic"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's legendary tunic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesTunic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Ganymede wore this tunic as he slayed Svalbard. Upon the monster's death, the blood gave the tunic its magic.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesTunic"
}

ItsyScape.Resource.Item "GanymedesBow" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(99)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(99)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(120),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(90),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
	Resource = ItsyScape.Resource.Item "GanymedesBow"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Ganymede/Longbow.lua",
	Resource = ItsyScape.Resource.Item "GanymedesBow"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's dragon-horn composite bow",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesBow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Made from the horns of Svalbard, the undead dragon that razed Ganymede's home city.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesBow"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120) * 5,
	Weight = 5,
	Resource = ItsyScape.Resource.Item "GanymedesBow"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's Waltz",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GanymedesWaltz"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Allows you to jump by pressing the minigame dash button.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GanymedesWaltz"
}

ItsyScape.Resource.Item "GanymedesStunningStrikeArrow" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(99),
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(95) / 50,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "GanymedesStunningStrikeArrow"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Arrow",
	Value = "Ganymede",
	Resource = ItsyScape.Resource.Item "GanymedesStunningStrikeArrow"
}

ItsyScape.Meta.RangedAmmo {
	Type = ItsyScape.Utility.Equipment.AMMO_ARROW,
	Resource = ItsyScape.Resource.Item "GanymedesStunningStrikeArrow"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's stunning strike arrow",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesStunningStrikeArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "When used with Ganymede's dragon-horn composite bow, applies a small cooldown to the opponent upon hitting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GanymedesStunningStrikeArrow"
}

ItsyScape.Meta.Equipment {
	StrengthRanged = 0, 
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER,
	Resource = ItsyScape.Resource.Item "GanymedesStunningStrikeArrow"
}

ItsyScape.Meta.ResourceName {
	Value = "Ganymede's Stunning Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GanymedesStunningStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Stuns the opponent for 0.2 seconds, plus an additional 1% of damage in seconds, upon a successful hit.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "GanymedesStunningStrike"
}
