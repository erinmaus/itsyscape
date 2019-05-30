--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Tower.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice",
		Name = "Isabelle",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Drakkenson",
		Name = "Drakkenson",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/Isabelle_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Isabelle.IsabelleNice",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Isabelle",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Her old neighbors were noisy, or was it nosey?",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AmuletOfYendor",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice"
	}

	local Pickpocket = ItsyScape.Action.Pickpocket()
	ItsyScape.Meta.DebugAction {
		Action = Pickpocket
	}

	Pickpocket {
		Output {
			Resource = ItsyScape.Resource.Item "AmuletOfYendor",
			Count = 1
		}
	}

	ItsyScape.Resource.Peep "IsabelleIsland_IsabelleNice" {
		Pickpocket
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Isabelle.IsabelleMean",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Isabelle",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "But she was so nice!",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AmuletOfYendor",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(10, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(10, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(10, 0.5),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(10, 0.5),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(10, 0.5),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Isabelle/AttackLogic.lua",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "IsabelleIsland_Rosalind" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind",
		Name = "Rosalind",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/Rosalind_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.IsabelleIsland_Rosalind.Rosalind",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Idromancer Rosalind",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Helps you find yourself.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "IsabelleIsland_Orlando" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/Orlando_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Orlando.Orlando",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Sir Orlando",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Hopeless romantic.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm",
		Name = "AdvisorGrimm",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimm_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.AdvisorGrimm.AdvisorGrimm",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Advisor Grimm",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Gesundheit!",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_AdvisorGrimm"
	}
end

ItsyScape.Resource.Peep "IsabelleIsland_Drakkenson" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Mysterious voice",
	Resource = ItsyScape.Resource.Peep "IsabelleIsland_Drakkenson"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You want a spoiler? Page 606.",
	Resource = ItsyScape.Resource.Peep "IsabelleIsland_Drakkenson"
}
