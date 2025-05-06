--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/BlackTentacle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local CapnRaven = ItsyScape.Resource.Peep "CapnRaven" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.CapnRaven.CapnRaven",
		Resource = CapnRaven
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Cap'n Raven",
		Resource = CapnRaven
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "In the running to become the legendary Queen of the Pirates...",
		Resource = CapnRaven
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "LitBullseyeLantern",
		Count = 1,
		Resource = CapnRaven
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(99),
		Resource = CapnRaven
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = CapnRaven,
		Character = ItsyScape.Resource.Character "CapnRaven"
	}
end

do
	local Pirate = ItsyScape.Resource.Peep "Pirate_BlackTentacle" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Pirate.BasePirate",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Black Tentacle pirate",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "One of the fiercest pirates to sail the seas.",
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(40),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 50,
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = Pirate,
		Character = ItsyScape.Resource.Character "BlackTentaclesPirate"
	}
end

do
	local Keelhauler = ItsyScape.Resource.Peep "Keelhauler" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Keelhauler.Keelhauler",
		Resource = Keelhauler
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Keelhauler",
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 600,
		Resource = Keelhauler
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "No one knows what the Keelhauler is. The remnants of an ancient civilization on the edge of R'lyeh, this magical, mechanical monster follows the commands of whoever possesses its heart... if you can call it a heart.",
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = Keelhauler,
		Character = ItsyScape.Resource.Character "BlackTentaclesPirate"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(30),
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Keelhauler
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(55),
		Resource = Keelhauler
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(55, 1),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(55, 1),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(55, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 1.2),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(30, 1.2),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1.2),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(30, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(30, 1.2),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(40),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(40),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(40),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Keelhauler
	}

	local LightningStrike = ItsyScape.Resource.Power "Keelhauler_LightningStrike" {
		ItsyScape.Action.Activate()
	}

	ItsyScape.Meta.PowerSpec {
		Resource = LightningStrike
	}

	ItsyScape.Meta.CombatPowerTier {
		Tier = 2,
		Resource = LightningStrike
	}

	ItsyScape.Meta.CombatPowerZealCost {
		Skill = ItsyScape.Resource.Skill "Magic",
		Resource = LightningStrike
	}

	ItsyScape.Meta.ResourceName {
		Value = "Stunning Strike",
		Language = "en-US",
		Resource = LightningStrike
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Summon a powerful bolt of lightning to stun your foe.",
		Language = "en-US",
		Resource = LightningStrike
	}

	local Laser = ItsyScape.Resource.Power "Keelhauler_Laser" {
		ItsyScape.Action.Activate()
	}

	ItsyScape.Meta.PowerSpec {
		Resource = Laser
	}

	ItsyScape.Meta.CombatPowerTier {
		Tier = 1,
		Resource = Laser
	}

	ItsyScape.Meta.CombatPowerZealCost {
		Skill = ItsyScape.Resource.Skill "Magic",
		Resource = Laser
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient Laser",
		Language = "en-US",
		Resource = Laser
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Blast your foe with a powerful bolt of light.",
		Language = "en-US",
		Resource = Laser
	}
end
