--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/RatKing.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local RatKing = ItsyScape.Resource.Peep "RatKing"

	ItsyScape.Resource.Peep "RatKing" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.BaseRatKing",
		Resource = RatKing
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King",
		Language = "en-US",
		Resource = RatKing
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "King of disgusting!",
		Language = "en-US",
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = RatKing
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(60, 1),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(60, 1.5),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(40, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(40, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(40, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(40, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(40, 0.95),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(55),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(50),
		Resource = RatKing
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Rat",
		Resource = RatKing
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Rat/RatKing_IdleLogic.lua",
		IsDefault = 1,
		Resource = RatKing
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Rat/RatKing_AttackLogic.lua",
		Resource = RatKing
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "hungry",
		Tree = "Resources/Game/Peeps/Rat/RatKing_HungryLogic.lua",
		Resource = RatKing
	}
end

do
	local RatKingsJester = ItsyScape.Resource.Peep "RatKingsJester"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.JesterRat",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King's jester",
		Language = "en-US",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "His jokes are really mean.",
		Language = "en-US",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.Dummy {
		Hitpoints = 25,

		Tier = 40,
		CombatStyle = ItsyScape.Utility.STYLE_MAGIC,

		Shield = "Shield",

		Resource = RatKingsJester
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "odd-one-out",
		Tree = "Resources/Game/Peeps/Rat/JesterRat_OddOneOutLogic.lua",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "poof",
		Tree = "Resources/Game/Peeps/Rat/JesterRat_PoofLogic.lua",
		Resource = RatKingsJester
	}

	local RatKingJesterPresent = ItsyScape.Resource.Prop "ViziersRock_Sewers_RatKingJesterPresent"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.RatKingJesterPresent",
		Resource = RatKingJesterPresent
	}

	local OpenAction = ItsyScape.Action.Pick()
	ItsyScape.Meta.ActionVerb {
		Value = "Open",
		XProgressive = "Opening",
		Language = "en-US",
		Action = OpenAction
	}

	local RatKingJesterPresentOpenable = ItsyScape.Resource.Prop "ViziersRock_Sewers_RatKingJesterPresent_Openable" {
		OpenAction
	}

	ItsyScape.Meta.PropAlias {
		Alias = RatKingJesterPresent,
		Resource = RatKingJesterPresentOpenable
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.RatKingJesterPresent",
		Resource = RatKingJesterPresentOpenable
	}
end

do
	local RatKingUnleashed = ItsyScape.Resource.Peep "RatKingUnleashed"

	ItsyScape.Resource.Peep "RatKingUnleashed" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.RatKingUnleashed",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King, The Empty King's Pet",
		Language = "en-US",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You are what you eat...",
		Language = "en-US",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Rat",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(40),
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(60, 1),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(60, 1.5),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 1.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(30, 1.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(30, 1.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(60, 0.95),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(60),
		Resource = RatKingUnleashed
	}
end
