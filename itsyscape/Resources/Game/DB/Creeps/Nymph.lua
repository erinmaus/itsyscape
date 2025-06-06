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
	Language = "en-US",
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

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Nymph_Base_Secondary",
			Count = 1
		}
	},
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Nymph/Nymph_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand"
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
	Language = "en-US",
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

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "AirRune",
	Weight = 100,
	Count = 20,
	Range = 10,
	Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "EarthRune",
	Weight = 100,
	Count = 20,
	Range = 10,
	Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "CosmicRune",
	Weight = 50,
	Count = 5,
	Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BlueCotton",
	Weight = 200,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "WoodlandRobe",
	Weight = 20,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Nymph_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Nymph_Base_Secondary"	
}

ItsyScape.Resource.Item "WoodlandRobe" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(10) * 5,
	Resource = ItsyScape.Resource.Item "WoodlandRobe"
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
