--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Svalbard.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Svalbard" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Svalbard.Svalbard",
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.ResourceName {
	Value = "Svalbard, Ganymede's Bane",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A dragon raised from the dead, thirsty for blood.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(150),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(150),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Base",
	DefenseStab = ItsyScape.Utility.styleBonusForItem(100, 1.1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(100, 1.1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(100, 1.1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(120, 1.2),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(90, 0.9),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Weakened",
	DefenseStab = ItsyScape.Utility.styleBonusForItem(80),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(80),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(80),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(100),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(60),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Attack (Melee)",
	AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(85),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(80),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Attack (Magic)",
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(85),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(80),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Attack (Archery)",
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(85),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(80),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Special Attack (Melee)",
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(100),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Special Attack (Magic)",
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(90),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(90),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Special Attack (Archery)",
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(100),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(100),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.Equipment {
	Name = "Special Attack (Dragonfyre)",
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(150),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(150),
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/Svalbard/AttackLogic.lua",
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Meta.PeepMashinaState {
	State = "special",
	Tree = "Resources/Game/Peeps/Svalbard/SpecialLogic.lua",
	Resource = ItsyScape.Resource.Peep "Svalbard"
}

ItsyScape.Resource.Peep "SvalbardsOrgans" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Svalbard.SvalbardOrgans",
	Resource = ItsyScape.Resource.Peep "SvalbardsOrgans"
}

ItsyScape.Meta.ResourceName {
	Value = "Svalbard's organs",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "SvalbardsOrgans"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Svalbard's organs, protected by his ribs and scales.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "SvalbardsOrgans"
}
