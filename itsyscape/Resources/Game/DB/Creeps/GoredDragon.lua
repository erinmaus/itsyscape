--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/GoredDragon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local GoredDragon = ItsyScape.Resource.Peep "GoredDragon" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ArtisanProperty {
	Count = 1,
	Property = ItsyScape.Resource.ArtisanProperty "CommonFurnaceFire_Smelt",
	Resource = GoredDragon
}

ItsyScape.Meta.ArtisanProperty {
	Count = 1,
	Property = ItsyScape.Resource.ArtisanProperty "NuclearHeat_Smelt",
	Resource = GoredDragon
}

ItsyScape.Meta.ArtisanProperty {
	Count = 1,
	Property = ItsyScape.Resource.ArtisanProperty "DragonHeat_Smelt",
	Resource = GoredDragon
}

local FurnaceAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Metal",
	ActionType = "Smelt",
	Action = FurnaceAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Smelt",
	XProgressive = "Smelting",
	Language = "en-US",
	Action = FurnaceAction
}

local GoredDragonStunned = ItsyScape.Resource.Peep "GoredDragon_Stunned" {
	FurnaceAction
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0.25,
	Resource = GoredDragonStunned
}

ItsyScape.Meta.MakeOffset {
	OffsetX = -2,
	OffsetY = 0.25,
	OffsetZ = 0.75,
	Resource = GoredDragonStunned
}

ItsyScape.Meta.PeepMashinaState {
	State = "attack",
	Tree = "Resources/Game/Peeps/GoredDragon/GoredDragon_TestAttackLogic.lua",
	Resource = GoredDragon
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.GoredDragon.GoredDragon",
	Resource = GoredDragon
}

ItsyScape.Meta.ResourceName {
	Value = "Gored royal dragon",
	Language = "en-US",
	Resource = GoredDragon
}

ItsyScape.Meta.ResourceDescription {
	Value = "A royal dragon torn apart for access to its flame sack and kept alive in perpetual pain to ensure the flames burn hot.",
	Language = "en-US",
	Resource = GoredDragon
}

ItsyScape.Meta.ResourceName {
	Value = "Gored royal dragon",
	Language = "en-US",
	Resource = GoredDragonStunned
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hurry! Now that the gored dragon is stunned, you can smelt ores using its flame sack!",
	Language = "en-US",
	Resource = GoredDragonStunned
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(120),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(120),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 2000,
	Resource = GoredDragon
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(70),
	AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(60),
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55),
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(75),
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(60),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(55),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(70),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(50),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(75),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(45),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(50),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(70),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(65),
	Resource = GoredDragon
}

ItsyScape.Meta.XWeaponBoost {
	AccuracyBonus = 100,
	StrengthBonus = 50,
	AlwaysHits = 1,
	Resource = ItsyScape.Resource.Item "X_Dragon_ChargedDragonfyreHit"
}
