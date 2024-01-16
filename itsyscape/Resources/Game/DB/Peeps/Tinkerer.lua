--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Tinkerer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Tinkerer" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Tinkerer.BaseTinkerer",
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.ResourceName {
	Value = "Tinkerer",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The best kind of medic... when you're dead.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(500),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Faith",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(50),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 0.4),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(30, 1.1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1.1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(45, 1.3),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(45, 1.2),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(65),
	Prayer = 30,
	Resource = ItsyScape.Resource.Peep "Tinkerer"
}

do
	local Tinkerer = ItsyScape.Resource.Peep "Tinkerer_DragonValley_Unattackable" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Tinkerer.DragonValleyTinkerer",
		Resource = Tinkerer
	}

	ItsyScape.Meta.ResourceName {
		Value = "Tinkerer",
		Language = "en-US",
		Resource = Tinkerer
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The best kind of medic... when you're dead.",
		Language = "en-US",
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(40),
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Tinkerer
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(50),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 0.4),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(30, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(45, 1.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(45, 1.2),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(65),
		Prayer = 30,
		Resource = Tinkerer
	}

	ItsyScape.Resource.Peep "Tinkerer_DragonValley_Attackable" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Tinkerer/Tinkerer_DragonValley_Phase1Logic.lua",
		IsDefault = 1,
		Resource = Tinkerer
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Tinkerer/Tinkerer_DragonValley_AttackLogic.lua",
		Resource = Tinkerer
	}
end

do
	ItsyScape.Resource.Item "PlagueDoctorHat" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60),
		Resource = ItsyScape.Resource.Item "PlagueDoctorHat"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Plague doctor hat",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PlagueDoctorHat"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Won't stop the plague, but makes you look good.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PlagueDoctorHat"
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "PlagueDoctorHat"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlagueDoctor/PlagueDoctorJustHat.lua",
		Resource = ItsyScape.Resource.Item "PlagueDoctorHat"
	}
end

do
	ItsyScape.Resource.Item "PlagueDoctor" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60),
		Resource = ItsyScape.Resource.Item "PlagueDoctor"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Plague doctor mask",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PlagueDoctor"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Filters out plague partikles",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PlagueDoctor"
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "PlagueDoctor"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlagueDoctor/PlagueDoctor.lua",
		Resource = ItsyScape.Resource.Item "PlagueDoctor"
	}
end

do
	ItsyScape.Resource.Item "PlagueDoctorHatAndMask" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60) * 2.5,
		Resource = ItsyScape.Resource.Item "PlagueDoctorHatAndMask"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Plague doctor hat and mask",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PlagueDoctorHatAndMask"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The hat just makes you look dapper.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "PlagueDoctorHatAndMask"
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "PlagueDoctorHatAndMask"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlagueDoctor/PlagueDoctorHat.lua",
		Resource = ItsyScape.Resource.Item "PlagueDoctorHatAndMask"
	}
end

do
	local Zombi = ItsyScape.Resource.Peep "SurgeonZombi" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "SurgeonZombi_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Zombi_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Zombi
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Zombi.SurgeonZombi",
		Resource = Zombi
	}

	ItsyScape.Meta.ResourceName {
		Value = "Surgeon zombi",
		Language = "en-US",
		Resource = Zombi
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Either very good or very bad at brain surgery...",
		Language = "en-US",
		Resource = Zombi
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Zombi
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Zombi
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = Zombi
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = Zombi
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "SurgeonsScalpel",
		Count = 1,
		Resource = Zombi
	}

	ItsyScape.Resource.Peep "SurgeonZombi_Attackable" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "SurgeonZombi_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "SurgeonZombi_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SurgeonsScalpel",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "SurgeonZombi_Primary"	
	}
end

do
	local Scalpel = ItsyScape.Resource.Item "SurgeonsScalpel" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(30),
		Resource = Scalpel
	}

	ItsyScape.Meta.ResourceName {
		Value = "Surgeon's scalpel",
		Language = "en-US",
		Resource = Scalpel
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Use it to cut through tissue like it's, well, tissue paper!",
		Language = "en-US",
		Resource = Scalpel
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(35),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(35),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
		Resource = Scalpel
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Tools/Scalpel.lua",
		Resource = Scalpel
	}
end

do
	local FleshyPillar = ItsyScape.Resource.Peep "EmptyRuins_DragonValley_FleshyPillar" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Zombi.FleshyPillar",
		Resource = FleshyPillar
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fleshy pillar",
		Language = "en-US",
		Resource = FleshyPillar
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Better kill that before something bad happens!",
		Language = "en-US",
		Resource = FleshyPillar
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(250),
		Resource = FleshyPillar
	}
end
