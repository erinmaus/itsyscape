--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/Isabelle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Character = ItsyScape.Resource.Character "Isabelle"

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Lady Isablle",
	Resource = Character
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "An ex-adventurer that leveraged the loot from her journeys to become not just a merchant, but among the richest merchants in history.",
	Resource = Character
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Humanity"
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Heroes"
}

do
	local Isabelle = ItsyScape.Resource.Peep "Isabelle"

	ItsyScape.Meta.PeepCharacter {
		Peep = Isabelle,
		Character = Character
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Isabelle.Isabelle",
		Resource = Isabelle
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Lady Isabelle",
		Resource = Isabelle
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Her old neighbors were noisy, or was it nosey?",
		Resource = Isabelle
	}
end

do
	local Isabelle = ItsyScape.Resource.Peep "Isabelle_Kursed"

	ItsyScape.Meta.PeepCharacter {
		Peep = Isabelle,
		Character = Character
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Isabelle.KursedIsabelle",
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumGloves",
		Count = 1,
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumBoots",
		Count = 1,
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumPlatebody",
		Count = 1,
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumZweihander",
		Count = 1,
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "IsabelliumLongbow",
		Count = 1,
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "IsabelliumStaff",
		Count = 1,
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = Isabelle
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Isabelle
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(15),
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(15),
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(15),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(15),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(15),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(10),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(15),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(15),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(15),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Isabelle
	}

	local UnknownIsabelle = ItsyScape.Resource.Peep "Isabelle_Kursed_Unknown" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = UnknownIsabelle,
		Character = Character
	}
end
