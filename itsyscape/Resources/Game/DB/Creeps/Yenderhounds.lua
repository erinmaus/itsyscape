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
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = Yenderhound
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yenderhound",
		Language = "en-US",
		Resource = Yenderhound
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An extreme dangerous hound. Its bite can puncture even the strongest metals.",
		Language = "en-US",
		Resource = Yenderhound
	}

	ItsyScape.Meta.Yenderhound {
		Tier = 50,
		Hitpoints = 500,

		Weapon = "ItsyDagger",

		Resource = Yenderhound
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(65, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(25, 1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(25, 1),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Yenderhound
	}
end
