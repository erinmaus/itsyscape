--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/ChestMimic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "ChestMimic_Weak_Base" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ChestMimic.BaseChestMimic",
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Chest mimic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Well it's very obvious, isn't it?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForItem(60),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(30),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(30),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(80, 1.1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(80, 1.1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(30),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "ChestMimic_Weak_Base"
}
