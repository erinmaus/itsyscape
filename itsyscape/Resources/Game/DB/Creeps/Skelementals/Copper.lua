--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Skelementals/CopperSkelemental.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "CopperSkelemental" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skelemental.CopperSkelemental",
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.ResourceName {
	Value = "Copper Skelemental",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Could gain to pack on a few pounds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(1),
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Skelemental/CopperSkelemental_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "CopperSkelemental"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2) / 5,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "CopperFlake"
}

ItsyScape.Meta.ResourceName {
	Value = "Copper flake",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CopperFlake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Very poor source of vitamins, but rich in nutrients.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CopperFlake"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "CopperFlake",
	Weight = 100,
	Count = 15,
	Range = 5,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeGloves",
	Weight = 10,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeBoots",
	Weight = 10,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeHelmet",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzePlatebody",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "CopperBar",
	Weight = 25,
	Count = 1,
	Noted = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "CopperOre",
	Weight = 25,
	Count = 1,
	Noted = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Dynamite",
	Weight = 50,
	Count = 15,
	Range = 5,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "CopperSkelemental_Secondary"	
}
