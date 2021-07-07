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

ItsyScape.Meta.ResourceDescription {
	Value = "Someone everyone grows up to be.",
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

ItsyScape.Meta.ResourceDescription {
	Value = "Not even a bit stringy.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Skeleton_Base_Attackable"
}

ItsyScape.Resource.Peep "AncientSkeleton" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skeleton.BaseAncientSkeleton",
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient skeleton",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Spooky!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(40),
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(150),
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55, 0),
	DefenseStab   = ItsyScape.Utility.styleBonusForItem(50, 1.3),
	DefenseSlash  = ItsyScape.Utility.styleBonusForItem(45, 1.3),
	DefenseCrush  = ItsyScape.Utility.styleBonusForItem(40, 1.3),
	DefenseMagic  = ItsyScape.Utility.styleBonusForItem(30, 0.5),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(35, 1.0),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(55),
	Resource = ItsyScape.Resource.Peep "AncientSkeleton"
}

ItsyScape.Resource.Peep "PrestigiousAncientSkeleton" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skeleton.BaseAncientSkeleton",
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.ResourceName {
	Value = "Prestigious ancient skeleton",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A li'l empty headed.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(45),
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(45),
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(150),
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientCeremonialRobe",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientCeremonialBoots",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientCeremonialGloves",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "AncientZweihander",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "PrestigiousAncientSkeleton"
}
