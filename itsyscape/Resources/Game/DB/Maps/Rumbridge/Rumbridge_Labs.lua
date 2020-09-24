--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Labs.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------f-------------------------------------------------------

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "Hex" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Hex.BaseHex",
		Resource = ItsyScape.Resource.Peep "Hex"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Hex",
		Resource = ItsyScape.Resource.Peep "Hex"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "...she might be totally, irrevocably, permanently insane.",
		Resource = ItsyScape.Resource.Peep "Hex"
	}
end

do
	ItsyScape.Resource.Peep "Emily_Default" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Emily.BaseEmily",
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Emily",
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "She's usually friendly... Usually.",
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(1000),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(1000),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(250),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(255),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForItem(95),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(95),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(90),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(110, 1.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(110, 1.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(110, 1.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(100, 0.7),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(100, 0.7),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(100),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(100),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(120),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Emily/Emily_IdleLogic.lua",
		IsDefault = 1,
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}
end
