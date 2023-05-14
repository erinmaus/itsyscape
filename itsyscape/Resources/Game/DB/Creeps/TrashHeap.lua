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
