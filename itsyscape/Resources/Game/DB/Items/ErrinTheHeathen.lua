--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "ErrinTheHeathensHat" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(100)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(105, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(120, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(125, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(100, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	Prayer         = 20,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Helmet.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Fashion for a godslayer.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Resource.Item "ErrinTheHeathensBoots" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(100)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(105, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(120, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(125, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(100, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT),
	Prayer         = 5,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Boots.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Only the finest black cthulhuian leather.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Boots",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Resource.Item "ErrinTheHeathensGloves" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(100)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(105, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(120, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(125, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(100, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT),
	Prayer         = 20,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Gloves.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Gloves",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Keeps your hands toasty while you purge the faithful.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Resource.Item "ErrinTheHeathensCoat" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(100)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(105, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(110, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(120, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(125, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	DefenseRanged  = ItsyScape.Utility.styleBonusForItem(100, ItsyScape.Utility.ARMOR_BODY_WEIGHT),
	Prayer         = 30,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Body.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Coat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "By slaying a god, she herself became one.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Resource.Item "ErrinTheHeathensStaff" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(100)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(110, ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT),
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(120),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(120),
	Prayer = 20,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Staff.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Staff",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains the Eye of Man'tok, the First One.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensHat", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensCoat", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensGloves", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensBoots", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensStaff", "x_debug")
