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
	local Knight = ItsyScape.Resource.Peep "IsabelleIsland_Knight"

	ItsyScape.Resource.Peep "IsabelleIsland_Knight" {
		ItsyScape.Action.InvisibleAttack()
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = Knight,
		Character = ItsyScape.Resource.Character "VizierRockKnight"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.Guard",
		Resource = Knight
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier Rock knight",
		Language = "en-US",
		Resource = Knight
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A knight from Vizier's Rock belonging to Vizier-King Yohn's personal guard. Lady Isabelle is obviously well connected.",
		Language = "en-US",
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 99,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantPlatebody",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantBoots",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantGloves",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantHelmet",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AdamantLongsword",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantShield",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "GoldenRing",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "GoldenAmulet",
		Count = 1,
		Resource = Knight
	}
end

do
	local KnightCommander = ItsyScape.Resource.Peep "IsabelleIsland_KnightCommander"

	ItsyScape.Resource.Peep "IsabelleIsland_KnightCommander" {
		ItsyScape.Action.InvisibleAttack()
	}

	ItsyScape.Meta.PeepCharacter {
		Peep = KnightCommander,
		Character = ItsyScape.Resource.Character "VizierRockKnight"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.SerCommander",
		Resource = KnightCommander
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ser Commander",
		Language = "en-US",
		Resource = KnightCommander
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Being a Vizier-Rock knight is the goal of any knight of the Realm, but to be a commander of the Vizier-Rock knights is an accomplishment that raises families to nobility. Too bad humility isn't a part of the job.",
		Language = "en-US",
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 99,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantPlatebody",
		Count = 1,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantBoots",
		Count = 1,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantGloves",
		Count = 1,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AdamantLongsword",
		Count = 1,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantShield",
		Count = 1,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "GoldenRing",
		Count = 1,
		Resource = KnightCommander
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "GoldenAmulet",
		Count = 1,
		Resource = KnightCommander
	}
end

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

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumBoots",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumPlatebody",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumHelmet",
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
		Weight = 50,
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
		ItsyScape.Action.InvisibleAttack()
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

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(50),
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

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumGloves",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumBoots",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumPlatebody",
		Count = 1,
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

do
	ItsyScape.Resource.Prop "Desk_Isabelle_DragonBone" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = ItsyScape.Resource.Prop "Desk_Isabelle_DragonBone"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Desk_Isabelle_DragonBone"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's desk",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Desk_Isabelle_DragonBone"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A desk made from the remains of a young dragon... Is this just a display of Isabelle's cruelty or vanity?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Desk_Isabelle_DragonBone"
	}
end

do
	ItsyScape.Resource.Prop "Armoire_Isabelle" {
		ItsyScape.Action.Dresser_Search()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDresserProp",
		Resource = ItsyScape.Resource.Prop "Armoire_Isabelle"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 4,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Armoire_Isabelle"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's armoire",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Armoire_Isabelle"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A fancier way of saying wardrobe. Wonder what's inside..? Probably a bunch of pink dresses...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Armoire_Isabelle"
	}
end

do
	ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle" {
		ItsyScape.Action.Sleep()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3.5,
		SizeY = 3,
		SizeZ = 3.5,
		MapObject = ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's bed",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's one expensive looking bed...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Bed_FourPoster_Isabelle"
	}
end

do
	ItsyScape.Resource.Prop "ComfyChair_Isabelle" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.FurnitureProp",
		Resource = ItsyScape.Resource.Prop "ComfyChair_Isabelle"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 2,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "ComfyChair_Isabelle"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's desk chair",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "ComfyChair_Isabelle"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Of course Isabelle could afford such a comfy chair.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "ComfyChair_Isabelle"
	}
end

do
	ItsyScape.Resource.Prop "Chest_Isabelle" {
		ItsyScape.Action.Dresser_Search()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicChest",
		Resource = ItsyScape.Resource.Prop "Chest_Isabelle"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Chest_Isabelle"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's chest",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Chest_Isabelle"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "I bet that won't open easily... But if you do manage... there might be something valuable in there!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Chest_Isabelle"
	}
end

do
	ItsyScape.Resource.Prop "Lamp_IsabelleTower" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = ItsyScape.Resource.Prop "Lamp_IsabelleTower"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = ItsyScape.Resource.Prop "Lamp_IsabelleTower"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lamp",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Lamp_IsabelleTower"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lights the way.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Lamp_IsabelleTower"
	}
end
