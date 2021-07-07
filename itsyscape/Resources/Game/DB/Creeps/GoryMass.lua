--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/GoryMass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "GoryMass" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.GoryMass.GoryMass",
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.ResourceName {
	Value = "Gory mass",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.ResourceDescription {
	Value = "That must be where all the organs are going...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(500),
	Resource = ItsyScape.Resource.Peep "GoryMass"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(60, 1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	Resource = ItsyScape.Resource.Peep "GoryMass"
}
