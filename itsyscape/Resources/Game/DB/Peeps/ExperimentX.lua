--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Disemboweled.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ExperimentX = ItsyScape.Resource.Peep "ExperimentX" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Zombi.ExperimentX",
	Resource = ExperimentX
}

ItsyScape.Meta.ResourceName {
	Value = "Experiment X",
	Language = "en-US",
	Resource = ExperimentX
}

ItsyScape.Meta.ResourceDescription {
	Value = "Three powerful adventurers that were slain in the Ginsville raid, stitched together to form a powerful weapon.",
	Language = "en-US",
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(750),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ExperimentX
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(50),
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(50),
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(50),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(40),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(40),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(40),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(50),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(35),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(60),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60),
	Resource = ExperimentX
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Zombi/ExperimentX_IdleLogic.lua",
	IsDefault = 1,
	Resource = ExperimentX
}
