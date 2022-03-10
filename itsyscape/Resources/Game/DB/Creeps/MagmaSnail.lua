--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/MagmaSnail.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local AnvilAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Metal",
	ActionType = "Smith",
	Action = AnvilAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Smith",
	XProgressive = "Smithing",
	Language = "en-US",
	Action = AnvilAction
}

ItsyScape.Resource.Peep "MagmaSnail" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.MagmaSnail.MagmaSnail",
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.ResourceName {
	Value = "Magma snail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Technically, it's a lava snail when above ground...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Resource.Peep "MagmaSnail_Dead" {
	AnvilAction,
	ItsyScape.Action.UseCraftWindow()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.MagmaSnail.MagmaSnail",
	Resource = ItsyScape.Resource.Peep "MagmaSnail_Dead"
}

ItsyScape.Meta.ResourceName {
	Value = "Magma snail",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MagmaSnail_Dead"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Looks like it's possible to smith on its shell.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MagmaSnail_Dead"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(30, 1),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(30),
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/MagmaSnail/MagmaSnail_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "MagmaSnail"
}
