--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/ExtraterrestrialYenderling.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Yenderling = ItsyScape.Resource.Peep "ExtraterrestrialYenderling" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Yenderling.ExtraterrestrialYenderling",
		Resource = Yenderling
	}

	ItsyScape.Meta.ResourceName {
		Value = "Extraterrestrial yenderling",
		Language = "en-US",
		Resource = Yenderling
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A yenderling from outer space. If left alone, they quickly devastate local ecosystems and mature in to yenderbeasts. Better stop this parasite now because you might not be able to stop it later!",
		Language = "en-US",
		Resource = Yenderling
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 150,
		Resource = Yenderling
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(75),
		Resource = Yenderling
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(75),
		Resource = Yenderling
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = -1000,
		DefenseCrush = -1000,
		DefenseSlash = -1000,
		DefenseMagic = -1000,
		DefenseRanged = -1000,
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(50),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(50),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Yenderling
	}
end
