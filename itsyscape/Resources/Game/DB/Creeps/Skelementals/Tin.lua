--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Skelementals/TinSkelemental.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "TinSkelemental" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "TinSkelemental_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skelemental.TinSkelemental",
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.ResourceName {
	Value = "Tin Skelemental",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Put-tin on the ritz.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(1),
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Skelemental/TinSkelemental_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "TinSkelemental"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2) / 5,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "TinFlake"
}

ItsyScape.Meta.ResourceName {
	Value = "Tin flake",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "TinFlake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Metal dandruff from an undead elemental, ew!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "TinFlake"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "TinFlake",
	Weight = 100,
	Count = 15,
	Range = 5,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeGloves",
	Weight = 10,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeBoots",
	Weight = 10,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeHelmet",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzePlatebody",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "TinBar",
	Weight = 25,
	Count = 1,
	Noted = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "TinOre",
	Weight = 25,
	Count = 1,
	Noted = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Dynamite",
	Weight = 50,
	Count = 15,
	Range = 5,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "TinSkelemental_Secondary"	
}
