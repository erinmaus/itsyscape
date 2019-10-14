--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/FungalDemogorgon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "FungalDemogorgon" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.FungalDemogorgon.FungalDemogorgon",
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.ResourceName {
	Value = "Fungal Demogorgon",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Fear in a handful of dust.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(255),
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(255),
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(255),
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(255),
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForItem(90),
	AccuracyStab = ItsyScape.Utility.styleBonusForItem(90),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(120, 1.1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(120, 1.1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(120, 1.1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(50, 0.5),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(50, 0.5),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(255),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(120),
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/FungalDemogorgon/FungalDemogorgon_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "FungalDemogorgon"
}
