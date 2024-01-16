--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/BarrelMimic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "BarrelMimic" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ChestMimic.BaseBarrelMimic",
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.ResourceTag {
	Value = "Mimic",
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.ResourceName {
	Value = "Barrel mimic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can't trust anything, can you? Thanks, Gammon!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(55),
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(150),
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(60),
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(60),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(60),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(60),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(20),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(20),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "BarrelMimic"
}
