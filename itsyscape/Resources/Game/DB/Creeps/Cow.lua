--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Cow.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Cow_Base" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cow_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cow_Secondary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cow_Tertiary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Cow.BaseCow",
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Cow",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cow_Base"
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
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Cow/Cow_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A factory that turns grass in to cow hide.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Resource.Peep "Cow_Milkable" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Milk() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(0)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(0)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bucket",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "Milk",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(2)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cow_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cow_Secondary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Cow_Tertiary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Cow.BaseCow",
	Resource = ItsyScape.Resource.Peep "Cow_Milkable"
}

ItsyScape.Meta.ResourceName {
	Value = "Cow",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cow_Milkable"
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
	Resource = ItsyScape.Resource.Peep "Cow_Milkable"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Cow/Cow_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Cow_Milkable"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A factory that turns grass in to cow hide.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Cow_Milkable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Cow_Milkable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Cow_Base"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Primary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "MooishLeatherHide",
	Weight = 1,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Secondary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Beef",
	Weight = 100,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Tertiary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Butter",
	Weight = 100,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Tertiary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "ExtraCreamyButter",
	Weight = 50,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Tertiary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BrownedButter",
	Weight = 25,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Tertiary"	
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Milk",
	Weight = 5,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Cow_Tertiary"	
}
