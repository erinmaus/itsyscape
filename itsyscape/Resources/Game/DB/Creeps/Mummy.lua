--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Mummy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Mummy" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Zombi.BaseMummy",
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.ResourceName {
	Value = "Mummy",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Somehow, despite missing more organs than a zombi, they're meaner than ever.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55, 0),
	DefenseStab   = ItsyScape.Utility.styleBonusForItem(50, 1.3),
	DefenseSlash  = ItsyScape.Utility.styleBonusForItem(45, 1.3),
	DefenseCrush  = ItsyScape.Utility.styleBonusForItem(40, 1.3),
	DefenseMagic  = ItsyScape.Utility.styleBonusForItem(30, 0.5),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(35, 1.0),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(55),
	Resource = ItsyScape.Resource.Peep "Mummy"
}

ItsyScape.Resource.Peep "PrestigiousMummy" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Zombi.BaseMummy",
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.ResourceName {
	Value = "Prestigious mummy",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Won parent of the year a thousand years in a row.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(45),
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(45),
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(200),
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientCeremonialRobe",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientCeremonialBoots",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientCeremonialGloves",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientZweihander",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousMummy"
}

