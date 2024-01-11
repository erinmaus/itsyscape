--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Behemoth.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Behemoth" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceTag {
	Value = "Mimic",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.Behemoth",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth, Lord of the Mimics",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mimic shed from Gammon's rocky skin, it took the shape of a fortress and wrought havoc across The Empty Ruins until it was imprisoned by the The Empty King's elite zealots, the Priests of the Simulacrum.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Archery",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Dexterity",
	Value = ItsyScape.Utility.xpForLevel(80),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(80),
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(80),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(80),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(80),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(80),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(45),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(85),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60),
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Resource.Peep "Behemoth_Stunned" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth, Lord of the Mimics",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth_Stunned"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The Behemoth is stunned! Now climb on to it and mine away at its skin!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth_Stunned"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Behemoth/Behemoth_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Resource.Prop "BehemothSkin" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.BehemothSkin",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth's skin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Makes the Behemoth look cool.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Resource.Prop "BehemothMap" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Climb on to the Behemoth!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.BehemothMap",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

local ClimbAction = ItsyScape.Action.Travel()

ItsyScape.Meta.ActionVerb {
	Value = "Climb",
	Language = "en-US",
	XProgressive = "Climbing",
	Action = ClimbAction
}

ItsyScape.Resource.Prop "BehemothMap_Climbable" {
	ClimbAction	
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap_Climbable"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Climb on to the Behemoth!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap_Climbable"
}
