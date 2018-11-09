--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Nymph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Nymph_Base" {
	-- Nothing.
}

ItsyScape.Meta.ResourceDescription {
	Value = "The revenge of felled trees."
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Nymph.BaseNymph",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Nymph",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Base"
}ItsyScape.Resource.Peep "Nymph_Attackable_Wand" {
	ItsyScape.Action.Attack(),
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Nymph.BaseNymph",
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.ResourceName {
	Value = "Nymph",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Revenging felled trees since the dawn of humanity."
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(5),
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(10),
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "DinkyWand",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "WoodlandRobe",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "Nymph_Attackable_Wand"
}
