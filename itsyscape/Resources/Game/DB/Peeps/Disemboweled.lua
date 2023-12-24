--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Disemboweled.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Adventurer = ItsyScape.Resource.Peep "DisemboweledAdventurer" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Zombi.DisemboweledZombi",
	Resource = Adventurer
}

ItsyScape.Meta.ResourceName {
	Value = "Disemboweled adventurer",
	Language = "en-US",
	Resource = Adventurer
}

ItsyScape.Meta.ResourceDescription {
	Value = "An adventurer that's been ressurrected and experimented on by Tinkerers. They yearn for death.",
	Language = "en-US",
	Resource = Adventurer
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(400),
	Resource = Adventurer
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = Adventurer
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Adventurer
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = Adventurer
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(40),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(40),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(40),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(50),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(35),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	Resource = Adventurer
}
