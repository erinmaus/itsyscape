--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/CrateMimic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "CrateMimic" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ChestMimic.BaseCrateMimic",
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.ResourceTag {
	Value = "Mimic",
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.ResourceName {
	Value = "Crate mimic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "So many crates, this one had to be a mimic?!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(45),
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(45),
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(175),
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(45),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(45),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(45),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(20),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(20),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(50),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "CrateMimic"
}
