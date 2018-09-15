--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Skeleton.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Skeleton_Base" {
	-- Nothing.
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skeleton.BaseSkeleton",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Skeleton",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base"
}

ItsyScape.Resource.Peep "Skeleton_Base_Attackable" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skeleton.BaseSkeleton",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Meta.ResourceName {
	Value = "Skeleton",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}
