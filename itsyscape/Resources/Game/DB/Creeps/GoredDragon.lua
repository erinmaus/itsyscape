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
	ItsyScape.Action.Attack(),
	ItsyScape.Action.Travel()
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

local Intestines = ItsyScape.Resource.Prop "GoredDragonIntestines" {
	ItsyScape.Action.Travel()
}

ItsyScape.Meta.ResourceName {
	Value = "Gored royal dragon intestines",
	Language = "en-US",
	Resource = Intestines
}

ItsyScape.Meta.ResourceDescription {
	Value = "Try not to think about it!",
	Language = "en-US",
	Resource = Intestines
}

ItsyScape.Meta.PeepID {
	Value = "ItsyScape.Peep.Peeps.Prop",
	Resource = Intestines
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2,
	SizeZ = 0.5,
	MapObject = Intestines
}

local FlameSac = ItsyScape.Resource.Prop "GoredDragonFlameSac" {
	FurnaceAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicFurnace",
	Resource = FlameSac
}

ItsyScape.Meta.ResourceName {
	Value = "Gored royal dragon flame sac",
	Language = "en-US",
	Resource = FlameSac
}

ItsyScape.Meta.ResourceDescription {
	Value = "A dragon's flame sac creates the hottest flames on the Realm, capable of smelting all known metals. But perhaps there are flames even hotter for metals even tougher...",
	Language = "en-US",
	Resource = FlameSac
}

ItsyScape.Meta.MakeOffset {
	OffsetX = 0,
	OffsetY = 0.25,
	OffsetZ = -0.25,
	Resource = FlameSac
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 5,
	SizeZ = 0.5,
	MapObject = FlameSac
}

ItsyScape.Meta.ArtisanProperty {
	Count = 1,
	Property = ItsyScape.Resource.ArtisanProperty "CommonFurnaceFire_Smelt",
	Resource = FlameSac
}

ItsyScape.Meta.ArtisanProperty {
	Count = 1,
	Property = ItsyScape.Resource.ArtisanProperty "NuclearHeat_Smelt",
	Resource = FlameSac
}

ItsyScape.Meta.ArtisanProperty {
	Count = 1,
	Property = ItsyScape.Resource.ArtisanProperty "DragonHeat_Smelt",
	Resource = FlameSac
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
	Value = "A royal dragon torn apart for access to its flame sac and kept alive in perpetual pain to ensure the flames burn hot.",
	Language = "en-US",
	Resource = GoredDragon
}

local GoredDragonStunned = ItsyScape.Resource.Peep "GoredDragon_Stunned" {
	ItsyScape.Action.Travel()
}

ItsyScape.Meta.ResourceName {
	Value = "Gored royal dragon",
	Language = "en-US",
	Resource = GoredDragonStunned
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hurry! Now that the gored dragon is stunned, you can smelt ores using its flame sac!",
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
	Value = ItsyScape.Utility.xpForLevel(30),
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
	Value = ItsyScape.Utility.xpForLevel(30),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(120),
	Resource = GoredDragon
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(30),
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
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(25),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(25),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(25),
	Resource = GoredDragon
}

ItsyScape.Meta.XWeaponBoost {
	AccuracyBonus = 100,
	StrengthBonus = 0,
	AlwaysHits = 1,
	Resource = ItsyScape.Resource.Item "X_Dragon_ChargedDragonfyreHit"
}

ItsyScape.Meta.XWeaponBoost {
	AccuracyBonus = 50,
	StrengthBonus = 0,
	Resource = ItsyScape.Resource.Item "X_Dragon_Dragonfyre"
}

local StomachAcid = ItsyScape.Resource.Prop "GoredDragonStomachAcid"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.GoredDragon.GoredDragonStomachAcid",
	Resource = StomachAcid
}

local StomachAcidFire = ItsyScape.Resource.Prop "GoredDragonStomachAcidFire"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = StomachAcidFire
}
