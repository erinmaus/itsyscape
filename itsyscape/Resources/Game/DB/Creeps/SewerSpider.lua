--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/SewerSpider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local SewerSpider = ItsyScape.Resource.Peep "SewerSpider"

	ItsyScape.Resource.Peep "SewerSpider" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Arachnid.SewerSpider",
		Resource = SewerSpider
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sewer spider",
		Language = "en-US",
		Resource = SewerSpider
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lurks in damp sewers, waiting for an injured or sickly rat to wander too close and get caught in a web...",
		Language = "en-US",
		Resource = SewerSpider
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Arachnid/SewerSpider_IdleLogic.lua",
		IsDefault = 1,
		Resource = SewerSpider
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = SewerSpider
	}
end

do
	local SewerSpiderMatriarch = ItsyScape.Resource.Peep "SewerSpiderMatriarch"

	ItsyScape.Resource.Peep "SewerSpiderMatriarch" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Arachnid.SewerSpiderMatriarch",
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sewer spider matriarch",
		Language = "en-US",
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An armored spider?!",
		Language = "en-US",
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Arachnid/SewerSpiderMatriarch_AttackLogic.lua",
		IsDefault = 1,
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = SewerSpiderMatriarch
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(60, 1),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(60, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(50, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(50, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(50, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(60, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(60),
		Prayer = 5,
		Resource = SewerSpiderMatriarch
	}
end
