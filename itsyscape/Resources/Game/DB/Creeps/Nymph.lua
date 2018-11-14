--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Nymph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Nymph_Base" {
	-- Nothing.
}

ItsyScape.Meta.ResourceDescription {
	Value = "The revenge of felled trees.",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Nymph.BaseNymph",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Nymph",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "WoodlandRobe",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand" {
	ItsyScape.Action.Attack(),
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Nymph.BaseNymph",
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.ResourceName {
	Value = "Nymph",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Revenging felled trees since the dawn of humanity.",
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "DinkyWand",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "WoodlandRobe",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
}

ItsyScape.Resource.Item "WoodlandRobe" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Woodland robe",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WoodlandRobe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Feels like nothing at all.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WoodlandRobe"
}

local ARMOR_BODY_WEIGHT = 1
ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForItem(5, 0.2),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(5, ARMOR_BODY_WEIGHT),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(4, ARMOR_BODY_WEIGHT),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(6, ARMOR_BODY_WEIGHT),
	DefenseRanged = -ItsyScape.Utility.styleBonusForItem(2, ARMOR_BODY_WEIGHT),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(5, 0.5),
	Prayer = 3,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "WoodlandRobe"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/WoodlandRobe/WoodlandRobe.lua",
	Resource = ItsyScape.Resource.Item "WoodlandRobe"
}
