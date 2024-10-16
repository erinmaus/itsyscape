--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Boop.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Boop" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Boop_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "Boop_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Boop.Boop",
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.ResourceName {
	Value = "Boop",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A ghost so lost they can't remember who they once were or what they looked like.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(1),
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(20),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(20),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(20),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(5),
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(20, 1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(10),
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Boop/Boop_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Boop"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "CottonCloth",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Boop_Primary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "WhiteSugar",
	Weight = 100,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Boop_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "AllPurposeFlour",
	Weight = 200,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Boop_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "AlmondFlour",
	Weight = 100,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Boop_Secondary"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "WholeWheatFlour",
	Weight = 50,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "Boop_Secondary"
}
