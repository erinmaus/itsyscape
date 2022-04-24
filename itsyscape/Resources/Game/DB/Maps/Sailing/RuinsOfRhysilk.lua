--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Sailing/RuinsOfRhysilk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local TrollKeyItem = ItsyScape.Resource.KeyItem "Sailing_YendorTroll"

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Discover Yendor's resting place.",
		Resource = TrollKeyItem
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Discovered Yendor's resting place at the bottom of the Ruins of Rh'ysilk.",
		Resource = TrollKeyItem
	}
end

do
	local Lerper = ItsyScape.Resource.Prop "RuinsOfRhysilk_CastleLerper" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Lerper
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0,
		SizeY = 0,
		SizeZ = 0,
		MapObject = Lerper
	}
end

do
	local Lerper = ItsyScape.Resource.Prop "RuinsOfRhysilk_TempleLerper" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Lerper
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0,
		SizeY = 0,
		SizeZ = 0,
		MapObject = Lerper
	}
end

do
	local Maggot = ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot"

	ItsyScape.Resource.Peep "RuinsOfRhysilk_Maggot" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Maggot.BaseMaggot",
		Resource = Maggot
	}

	ItsyScape.Meta.ResourceName {
		Value = "Giant maggot",
		Language = "en-US",
		Resource = Maggot
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "It writhes in horror, eating at the carcass of a slain god.",
		Language = "en-US",
		Resource = Maggot
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(200),
		Resource = Maggot
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Maggot
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Maggot
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(50, 1),
		DefenseStab = -50,
		DefenseSlash = -50,
		DefenseCrush = -50,
		DefenseMagic = -50,
		DefenseRanged = -50,
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(50),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Maggot
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Maggot/Maggot_IdleLogic.lua",
		IsDefault = 1,
		Resource = Maggot
	}
end

do
	local Pirate = ItsyScape.Resource.Peep "RuinsOfRhysilk_Pirate"

	Pirate {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Pirate_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Pirate_Secondary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Pirate_Tertiary_Tier10",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Pirate.BasePirate",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Pirate",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Arrrrgh, matey.",
		Resource = Pirate
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PiratesHat",
		Count = 1,
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronBullet",
		Count = math.huge,
		Resource = Pirate
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(10),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Pirate
	}
end
