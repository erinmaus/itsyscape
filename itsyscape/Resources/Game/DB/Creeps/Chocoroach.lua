--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Chocoroach.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Chocoroach" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Bug.Chocoroach",
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.ResourceName {
	Value = "Chocoroach",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A roach with a sweet... mandible...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(35),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(20, 1),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(20),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Bug/Chocoroach_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}
