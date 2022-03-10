--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/SaberToothShrimp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "SaberToothShrimp" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.SaberToothShrimp.SaberToothShrimp",
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.ResourceName {
	Value = "Saber tooth shrimp",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Wait... Since when do shrimp have bones?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(500),
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(80, 1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(80),
	Resource = ItsyScape.Resource.Peep "SaberToothShrimp"
}
