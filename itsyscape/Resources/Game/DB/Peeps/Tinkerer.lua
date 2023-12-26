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
