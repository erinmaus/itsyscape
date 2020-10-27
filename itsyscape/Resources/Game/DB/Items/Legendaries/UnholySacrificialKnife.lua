--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Legendaries/UnholySacrificialKnife.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "UnholySacrificialKnife" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(90)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Necromancy",
			Count = ItsyScape.Utility.xpForLevel(90)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(100, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
	AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(95, ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(55, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(95, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	Prayer = 7,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
	Resource = ItsyScape.Resource.Item "UnholySacrificialKnife"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(110) * 3,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "UnholySacrificialKnife"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/UnholySacrificialKnife/UnholySacrificialKnife.lua",
	Resource = ItsyScape.Resource.Item "UnholySacrificialKnife"
}

ItsyScape.Meta.ResourceName {
	Value = "Unholy sacrificial knife",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UnholySacrificialKnife"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A knife used in a horrific ritual by The Empty King to banish the gods from the Realm.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "UnholySacrificialKnife"
}

ItsyScape.Meta.ResourceName {
	Value = "Unholy Sacrifice",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "UnholySacrifice"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Restores prayer points by 1% of Necromancy level every 5 seconds. Can restore prayer points up to 20% over maximum.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "UnholySacrifice"
}
