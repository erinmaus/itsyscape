--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/PetrifiedSpider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local PetrifiedSpider = ItsyScape.Resource.Peep "PetrifiedSpider"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Arachnid.PetrifiedSpider",
		Resource = PetrifiedSpider
	}

	ItsyScape.Meta.ResourceName {
		Value = "Petrified spider",
		Language = "en-US",
		Resource = PetrifiedSpider
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "And you thought it was dead!",
		Language = "en-US",
		Resource = PetrifiedSpider
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(200),
		Resource = PetrifiedSpider
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = PetrifiedSpider
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = PetrifiedSpider
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(60, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(65, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(65, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(60, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(20, 1),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(20, 1),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(60),
		Resource = PetrifiedSpider
	}
end

do
	local PetrifiedSpiderAttackable = ItsyScape.Resource.Peep "PetrifiedSpider_Attackable" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.ResourceName {
		Value = "Petrified spider",
		Language = "en-US",
		Resource = PetrifiedSpiderAttackable
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "And you thought it was dead!",
		Language = "en-US",
		Resource = PetrifiedSpiderAttackable
	}
end
