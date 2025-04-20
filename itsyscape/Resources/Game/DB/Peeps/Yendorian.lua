--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Yendorian.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Yendorian_Base" {
	-- Nothing.
}

ItsyScape.Meta.PeepCharacter {
	Peep = ItsyScape.Resource.Peep "Yendorian_Base",
	Character = ItsyScape.Resource.Character "Yendorian"
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Yendorian.BaseYendorian",
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Yendorian",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "One of the First Children of Yendor.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(35, 1),
	Prayer = 55,
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Resource.Peep "Yendorian_Ballista" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepCharacter {
	Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
	Character = ItsyScape.Resource.Character "Yendorian"
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Yendorian.BallistaYendorian",
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.ResourceName {
	Value = "Yendorian archer",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Is that a frigging ballista?!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 400,
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(55, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(40, 1),
	Prayer = 55,
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/Yendorian/BallistaYendorian_AttackLogic.lua",
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Yendorian/GenericYendorian_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Resource.Peep "Yendorian_Mast" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepCharacter {
	Peep = ItsyScape.Resource.Peep "Yendorian_Mast",
	Character = ItsyScape.Resource.Character "Yendorian"
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Yendorian.MastYendorian",
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.ResourceName {
	Value = "Yendorian wizard",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.ResourceDescription {
	Value = "I have a feeling that this wizard might not just be a book nerd.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 400,
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(55, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(35, 1),
	Prayer = 55,
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(60),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/Yendorian/MastYendorian_AttackLogic.lua",
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Yendorian/GenericYendorian_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Yendorian_Mast"
}

ItsyScape.Meta.PeepCharacter {
	Peep = ItsyScape.Resource.Peep "Yendorian_Swordfish",
	Character = ItsyScape.Resource.Character "Yendorian"
}

ItsyScape.Resource.Peep "Yendorian_Swordfish" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Yendorian.SwordfishYendorian",
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.ResourceName {
	Value = "Yendorian warrior",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Takes reduce, re-use, recycle pretty far.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 400,
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.Equipment {
	AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(55, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(40, 1),
	Prayer = 55,
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/Yendorian/SwordfishYendorian_AttackLogic.lua",
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Yendorian/SwordfishYendorian_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Yendorian_Swordfish"
}

do
	local Scout = ItsyScape.Resource.Peep "Yendorian_Scout" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = Scout,
		Character = ItsyScape.Resource.Character "Yendorian"
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Eldritch",
		Resource = Scout
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Yendorian.ScoutYendorian",
		Resource = Scout
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian scout",
		Language = "en-US",
		Resource = Scout
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Where there's a Yendorian scout, there's Yendorian troops not too far away.",
		Language = "en-US",
		Resource = Scout
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Scout
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Scout
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(30),
		Resource = Scout
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Scout
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 150,
		Resource = Scout
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = -1000,
		DefenseStab = -1000,
		DefenseSlash = -1000,
		DefenseCrush = -1000,
		DefenseMagic = -1000,
		DefenseRanged = -1000,
		StrengthMelee = 0,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Scout
	}
end

