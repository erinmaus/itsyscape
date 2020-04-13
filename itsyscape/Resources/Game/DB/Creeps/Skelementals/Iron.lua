--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Skelementals/IronSkelemental.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "IronSkelemental" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "IronSkelemental_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "IronSkelemental_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skelemental.IronSkelemental",
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron Skelemental",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Where is it carrying the loot?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForItem(20, 1),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(20),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Skelemental/IronSkelemental_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/Skelemental/IronSkelemental_AttackLogic.lua",
	IsDefault = 0,
	Resource = ItsyScape.Resource.Peep "IronSkelemental"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(10) / 5,
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "IronFlake"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron flake",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronFlake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not to be used as a supplement.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronFlake"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "IronFlake",
	Weight = 100,
	Count = 15,
	Range = 5,
	Resource = ItsyScape.Resource.DropTable "IronSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "IronBar",
	Weight = 25,
	Count = 2,
	Noted = 1,
	Resource = ItsyScape.Resource.DropTable "IronSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "IronOre",
	Weight = 25,
	Count = 2,
	Noted = 1,
	Resource = ItsyScape.Resource.DropTable "IronSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Dynamite",
	Weight = 50,
	Count = 30,
	Range = 10,
	Resource = ItsyScape.Resource.DropTable "IronSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BoneBoomerang",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "IronSkelemental_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "IronSkelemental_Secondary"	
}
