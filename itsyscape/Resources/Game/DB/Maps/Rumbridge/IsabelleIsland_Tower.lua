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
		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Isabelle_Primary",
				Count = 2
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Isabelle_Secondary",
				Count = 1
			}
		}
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

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
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
		Prayer = 20,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Isabelle/AttackLogic.lua",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 200,
		Count = 1500,
		Range = 1000,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BoneShards",
		Weight = 50,
		Count = 100,
		Range = 25,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MooishLeatherHide",
		Weight = 100,
		Count = 10,
		Range = 2,
		Noted = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueCotton",
		Weight = 100,
		Count = 10,
		Range = 2,
		Noted = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeBar",
		Weight = 100,
		Count = 10,
		Range = 2,
		Noted = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeArrow",
		Weight = 100,
		Count = 100,
		Range = 50,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Dynamite",
		Weight = 150,
		Count = 20,
		Range = 5,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AirRune",
		Weight = 100,
		Count = 150,
		Range = 50,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "FireRune",
		Weight = 100,
		Count = 100,
		Range = 50,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CosmicRune",
		Weight = 100,
		Count = 50,
		Range = 25,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "UnfocusedRune",
		Weight = 10,
		Count = 200,
		Range = 100,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Primary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumShard",
		Weight = 97,
		Count = 3,
		Range = 2,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Secondary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumZweihander",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Secondary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumLongbow",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Secondary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumStaff",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_Secondary"
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_Rosalind" {
		-- Nothing.
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
	ItsyScape.Resource.Peep "IsabelleIsland_Orlando" {
		ItsyScape.Action.InvisibleAttack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Orlando.Orlando",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Ser Orlando",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Hopeless romantic.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(20, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(20, 1),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
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
		Value = "Seems a bit pretentious but he means well.",
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

do
	local Milk = ItsyScape.Resource.Item "IsabelleIsland_BessiesMilk" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "IsabelleIsland_BessiesMilk",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bessie's milk",
		Language = "en-US",
		Resource = Milk
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Milk from the sweetest cow on Isabelle Island!",
		Language = "en-US",
		Resource = Milk
	}

	ItsyScape.Meta.Ingredient {
		Item = Milk,
		Ingredient = ItsyScape.Resource.Ingredient "Milk"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(6),
		Resource = Milk
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Milk,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Milk,
		Value = ItsyScape.Utility.valueForItem(6)
	}
end
