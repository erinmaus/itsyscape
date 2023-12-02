--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/TrashHeap.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "TrashHeap" {
	ItsyScape.Action.Attack(),

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "TrashHeap_Primary",
			Count = 1
		}
	},

	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "TrashHeap_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.TrashHeap.TrashHeap",
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.ResourceName {
	Value = "Trash heap",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Looks like a tree...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForItem(5),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(5),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(5),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(5),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(5),
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(40, 1),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(45),
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/TrashHeap/TrashHeap_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/TrashHeap/TrashHeap_AttackLogic.lua",
	Resource = ItsyScape.Resource.Peep "TrashHeap"
}



do
	local DropTable = ItsyScape.Resource.DropTable "TrashHeap_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantTrim",
		Weight = 50,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 500,
		Count = 1500,
		Range = 1000,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Crawfish",
		Weight = 100,
		Count = 3,
		Range = 2,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BurntCrawfish",
		Weight = 50,
		Count = 100,
		Range = 50,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Shrimp",
		Weight = 75,
		Count = 3,
		Range = 2,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BurntShrimp",
		Weight = 50,
		Count = 100,
		Range = 50,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BurntCoelacanth",
		Weight = 25,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeDubloon",
		Weight = 25,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SilverDubloon",
		Weight = 10,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "GoldDubloon",
		Weight = 1,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "TinCan",
		Weight = 500,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "OldBoot",
		Weight = 500,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueTableSalt",
		Weight = 500,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}
end

do
	local DropTable = ItsyScape.Resource.DropTable "TrashHeap_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 500,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "ToxicSludge",
		Weight = 500,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RatPaw",
		Weight = 200,
		Count = 1,
		Resource = DropTable
	}
end

do
	local Sludge = ItsyScape.Resource.Item "ToxicSludge" {
		ItsyScape.Action.Bury() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(25)
			},

			Input {
				Resource = ItsyScape.Resource.Item "ToxicSludge",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForResource(35) / 5
			}
		},

		BoneCraftAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Bones",
		Value = "Sludge",
		Resource = Sludge
	}

	ItsyScape.Meta.ResourceName {
		Value = "Toxic sludge",
		Language = "en-US",
		Resource = Sludge
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(25) / 3,
		Stackable = 1,
		Resource = Sludge
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Better bury it and leave it for someone else to deal with anytime in then next 5 billion years",
		Language = "en-US",
		Resource = Sludge
	}
end
