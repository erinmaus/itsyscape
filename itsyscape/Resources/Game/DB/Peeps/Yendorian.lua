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
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(99),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(100, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(100, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(100, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(100, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(80, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(70, 1),
	Prayer = 100,
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(120),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Yendorian_Base"
}
ItsyScape.Resource.Peep "Yendorian_Ballista" {
	ItsyScape.Action.Attack()
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
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(90),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(99),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(90, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(80, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(80, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(80, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(100, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(70, 1),
	Prayer = 100,
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(120),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Yendorian_Ballista"
}
