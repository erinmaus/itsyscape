--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Skelemental.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Yenderhound = ItsyScape.Resource.Peep "Yenderhound" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Dog.Yenderhound",
		Resource = Yenderhound
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yenderhound",
		Language = "en-US",
		Resource = Yenderhound
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A ferocious hound. Its bite can puncture even the strongest metals like paper.",
		Language = "en-US",
		Resource = Yenderhound
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 50,
		Resource = Yenderhound
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Yenderhound
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(65),
		Resource = Yenderhound
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(30),
		Resource = Yenderhound
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForItem(70, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(25, 1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(25, 1),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(35),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Yenderhound
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Dog/Dog_AggressiveIdleLogic.lua",
		IsDefault = 1,
		Resource = Yenderhound
	}
end
