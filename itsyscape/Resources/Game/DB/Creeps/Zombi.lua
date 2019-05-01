--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Zombi.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Zombi_Base" {
	-- Nothing.
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Zombi.BaseZombi",
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Zombi",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Brains over brawn.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Zombi_Base"
}

ItsyScape.Resource.Peep "Zombi_Base_Attackable" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Zombi.BaseZombi",
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.ResourceName {
	Value = "Zombi",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Not that kind of zombie.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Zombi/Zombi_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Zombi_Base_Attackable"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Coins",
	Weight = 200,
	Count = 100,
	Range = 50,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeHatchet",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzePickaxe",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "TinCan",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "MooishLeatherBoots",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BronzeBoots",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BlueCottonSlippers",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "WeakGum",
	Weight = 100,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "ZombiBrains",
	Weight = 20,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "EldritchMyrrh",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 9,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "ZombiBrains",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary"	
}

ItsyScape.Meta.Item {
	Value = 132,
	Resource = ItsyScape.Resource.Item "ZombiBrains"
}

ItsyScape.Meta.ResourceName {
	Value = "Zombi brains",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ZombiBrains"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Unlikely the zombi will be needing that anytime soon.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ZombiBrains"
}
