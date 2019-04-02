--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Chicken.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Chicken_Base" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Chicken_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Chicken_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Chicken.BaseChicken",
	Resource = ItsyScape.Resource.Peep "Chicken_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Chicken",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Chicken_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Why did she cross the road? To get to the other side!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Chicken_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Chicken_Base"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chicken_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Feather",
	Weight = 1,
	Count = 15,
	Range = 5,
	Resource = ItsyScape.Resource.DropTable "Chicken_Secondary"	
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
	Resource = ItsyScape.Resource.Peep "Chicken"
}
