--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/WarfMite.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local WarfMite = ItsyScape.Resource.Peep "WarfMite" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Arachnid.WarfMite",
	Resource = WarfMite
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = WarfMite
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = WarfMite
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = WarfMite
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(30, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(15, 1.1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(15, 1.1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(15, 1.1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 1.2),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(20, 0.9),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(21),
	Resource = WarfMite
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Arachnid/Mite_IdleLogic.lua",
	IsDefault = 1,
	Resource = WarfMite
}
