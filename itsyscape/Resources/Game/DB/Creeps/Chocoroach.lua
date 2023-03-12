--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Chocoroach.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Chocoroach" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Chocoroach_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary",
			Count = 1
		}
	},
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Bug.Chocoroach",
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.ResourceName {
	Value = "Chocoroach",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A roach with a sweet... mandible...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(35),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "BugGutsHide",
	Weight = 1,
	Count = 2,
	Range = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Chocolate",
	Weight = 200,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "DarkChocolate",
	Weight = 100,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "WhiteChocolate",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "WhiteSugar",
	Weight = 150,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "LightBrownSugar",
	Weight = 100,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "DarkBrownSugar",
	Weight = 100,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Honey",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Chocoroach_Secondary"
}

ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(20, 1),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(20),
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Bug/Chocoroach_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Chocoroach"
}
