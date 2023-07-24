--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Cheep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Cheep_Base" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cheep_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cheep_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	--Value = "Resources.Game.Peeps.Cheep.BaseCheep",
	Value = "ItsyScape.Peep.Peeps.Creep",
	Resource = ItsyScape.Resource.Peep "Cheep_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Cheep",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cheep_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Cotton doesn't come from plants, silly - it comes from cheep!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cheep_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Cheep_Base"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Cheep_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "CottonCloth",
	Weight = 1,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Cheep_Secondary"	
}

ItsyScape.Meta.Equipment {
	AccuracyStab = -100,
	AccuracySlash = -100,
	AccuracyCrush = -100,
	DefenseStab = -50,
	DefenseSlash = -50,
	DefenseCrush = -50,
	DefenseMagic = -50,
	DefenseRanged = -50,
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "Cheep_Base"
}

ItsyScape.Meta.Dummy {
	Tier = 1,
	CombatStyle = ItsyScape.Utility.Weapon.STYLE_MELEE,
	Resource = ItsyScape.Resource.Peep "Cheep_Base"
}
