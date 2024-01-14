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

	ItsyScape.Meta.PeepMashinaState {
		State = "odd-one-out",
		Tree = "Resources/Game/Peeps/Rat/JesterRat_OddOneOutLogic.lua",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "avoid",
		Tree = "Resources/Game/Peeps/Rat/JesterRat_AvoidLogic.lua",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "poof",
		Tree = "Resources/Game/Peeps/Rat/JesterRat_PoofLogic.lua",
		Resource = RatKingsJester
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = RatKingsJester
	}

	ItsyScape.Meta.Equipment {
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(55),
		Resource = RatKingsJester
	}

	local RatKingJesterPresent = ItsyScape.Resource.Prop "ViziersRock_Sewers_RatKingJesterPresent"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.RatKingJesterPresent",
		Resource = RatKingJesterPresent
	}

	ItsyScape.Meta.ResourceName {
		Value = "Present",
		Language = "en-US",
		Resource = RatKingJesterPresent
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a ticking sound inside...",
		Language = "en-US",
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

	ItsyScape.Meta.ResourceName {
		Value = "Suspicious present",
		Language = "en-US",
		Resource = RatKingJesterPresentOpenable
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wonder what's inside... A trick or treat?",
		Language = "en-US",
		Resource = RatKingJesterPresentOpenable
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
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "RatKing_Primary",
				Count = 2
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "RatKing_Secondary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "RatKing_Tertiary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.RatKingUnleashed",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King, Witch-King Wren's Pet",
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

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/Rat/RatKingUnleashed_AttackLogic.lua",
		Resource = RatKingUnleashed
	}
end

do
	local Tooth = ItsyScape.Resource.Item "RatKingTooth" {
		ItsyScape.Action.Bury() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "RatKingTooth",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForResource(45)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Bones",
		Value = "Rat",
		Resource = Tooth
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King tooth",
		Language = "en-US",
		Resource = Tooth
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A tooth from the Rat King. Bury it for some sick XP!",
		Language = "en-US",
		Resource = Tooth
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(45) / 4,
		Stackable = 1,
		Resource = Tooth
	}
end

do
	local DropTable = ItsyScape.Resource.DropTable "RatKing_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantTrim",
		Weight = 25,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantBar",
		Weight = 50,
		Count = 5,
		Range = 3,
		Noted = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantOre",
		Weight = 50,
		Count = 6,
		Range = 2,
		Noted = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 150,
		Count = 40000,
		Range = 10000,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RatKingTooth",
		Weight = 100,
		Count = 10,
		Range = 5,
		Resource = DropTable
	}
end

do
	local DropTable = ItsyScape.Resource.DropTable "RatKing_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyShard",
		Weight = 99,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyNeedle",
		Weight = 1,
		Count = 1,
		Resource = DropTable
	}
end

do
	local DropTable = ItsyScape.Resource.DropTable "RatKing_Tertiary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RatKingTooth",
		Weight = 1,
		Count = 2,
		Range = 1,
		Resource = DropTable
	}
end

do
	local RustyShard = ItsyScape.Resource.Item "RustyShard"

	ItsyScape.Meta.ResourceName {
		Value = "Rusty shard",
		Language = "en-US",
		Resource = RustyShard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A rusty shard dropped by the Rat King. Can be crafted into a loot bag!",
		Language = "en-US",
		Resource = RustyShard
	}

	ItsyScape.Meta.LootCategory {
		Item = RustyShard,
		Category = ItsyScape.Resource.LootCategory "Special"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60) / 10,
		Stackable = 1,
		Resource = RustyShard
	}

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Loot",
		CategoryValue = "Rusty",
		ActionType = "Craft",
		Action = CraftAction
	}

	RustyShard {
		CraftAction
	}
end

do
	local LootBag = ItsyScape.Resource.Item "RatKingLootBag" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "RustyShard",
				Count = 100
			},

			Output {
				Resource = ItsyScape.Resource.Item "RatKingLootBag",
				Count = 1
			}
		},

		ItsyScape.Action.LootBag() {
			Output {
				Resource = ItsyScape.Resource.DropTable "RatKing_LootBag",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King's loot bag",
		Language = "en-US",
		Resource = LootBag
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Contains a legendary item from fighting the Rat King...!",
		Language = "en-US",
		Resource = LootBag
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Loot",
		Value = "Rusty",
		Resource = LootBag
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60) * 10,
		Resource = LootBag
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyNeedle",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "RatKing_LootBag"
	}
end

do
	local RustyNeedle = ItsyScape.Resource.Item "RustyNeedle" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Attack",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Strength",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(50)
			}
		},

		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(60),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = RustyNeedle
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(60) * 10,
		Weight = 0,
		Resource = RustyNeedle
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "RustyNeedle",
		Category = ItsyScape.Resource.LootCategory "Legendary"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/RustyNeedle/RustyNeedle.lua",
		Resource = RustyNeedle
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rusty needle",
		Language = "en-US",
		Resource = RustyNeedle
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This will definitely give you tetanus if it hits!",
		Language = "en-US",
		Resource = RustyNeedle
	}

	ItsyScape.Meta.ResourceName {
		Value = "Tetanus",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "Tetanus"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Increases minimum hit by 1 per damaging attack up to 20% of maximum hit.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Effect "Tetanus"
	}
end
