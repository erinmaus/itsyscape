--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/HighChambersYendor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The doors have eyes. And the eyes are Yendor's.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_BigDoor" {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The doors have eyes. And the eyes are Yendor's.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian" {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The doors have eyes. And the eyes are Yendor's.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicGuardianDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Small dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Did it just creak?",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor_Base"
	}

	ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor" {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Small dungeon door",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Did it just creak?",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 2,
		SizeZ = 2,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SmallDoor"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_Bed" {
		ItsyScape.Action.Sleep()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Sack of hay",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Bed"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Not very comfortable, but better than nothing.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Bed"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Bed"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1.5,
		SizeZ = 3.5,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_Bed"
	}
end

do
	local Ghost = ItsyScape.Resource.Peep "HighChambersYendor_TorchPuzzleGhost"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.TorchPuzzleGhost",
		Resource = Ghost
	}

	ItsyScape.Meta.ResourceName {
		Value = "Angry ghost",
		Language = "en-US",
		Resource = Ghost
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "He wants a revelation, some kind of resolution.",
		Language = "en-US",
		Resource = Ghost
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Ghost
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Wizard_Primary"
	local SecondaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Wizard_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueCotton",
		Weight = 400,
		Count = 3,
		Range = 1,
		Noted = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AirRune",
		Weight = 400,
		Count = 20,
		Range = 10,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "EarthRune",
		Weight = 200,
		Count = 10,
		Range = 5,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueCottonRobe",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueCottonSlippers",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueCottonGloves",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueCottonHat",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "DinkyCane",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "DinkyWand",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Weight = 25,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PlainThread",
		Weight = 100,
		Count = 20,
		Range = 10,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end

do
	local Wizard = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard"

	ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Wizard_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Wizard_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.SkeletonWizard",
		Resource = Wizard
	}

	ItsyScape.Meta.ResourceName {
		Value = "Skeleton wizard",
		Language = "en-US",
		Resource = Wizard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A wizard faithful to Yendor, even in death.",
		Language = "en-US",
		Resource = Wizard
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Wizard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Wizard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Wizard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Wizard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Wizard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlueCottonRobe",
		Count = 1,
		Resource = Wizard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = Wizard
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Archer_Primary"
	local SecondaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Archer_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MooishLeatherHide",
		Weight = 400,
		Count = 3,
		Range = 1,
		Noted = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CommonLogs",
		Weight = 100,
		Count = 3,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeArrow",
		Weight = 200,
		Count = 10,
		Range = 5,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeArrowhead",
		Weight = 50,
		Count = 20,
		Range = 10,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MooishLeatherBody",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MooishLeatherBoots",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MooishLeatherGloves",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "MooishLeatherCoif",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PunyBow",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PunyBoomerang",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PunyLongbow",
		Weight = 25,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PlainThread",
		Weight = 100,
		Count = 20,
		Range = 10,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end

do
	local Archer = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher"

	ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Archer_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Archer_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.SkeletonArcher",
		Resource = Archer
	}

	ItsyScape.Meta.ResourceName {
		Value = "Skeleton archer",
		Language = "en-US",
		Resource = Archer
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An archer faithful to Yendor, even in death.",
		Language = "en-US",
		Resource = Archer
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Archer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Archer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Archer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Archer
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Archer
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherBody",
		Count = 1,
		Resource = Archer
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PunyBow",
		Count = 1,
		Resource = Archer
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeArrow",
		Count = 10000,
		Resource = Archer
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Warrior_Primary"
	local SecondaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Warrior_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeBar",
		Weight = 400,
		Count = 2,
		Range = 1,
		Noted = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzePlatebody",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeGloves",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeBoots",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeHelmet",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeLongsword",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeMace",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeDagger",
		Weight = 25,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "TinBar",
		Weight = 100,
		Count = 3,
		Range = 2,
		Noted = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CopperBar",
		Weight = 100,
		Count = 3,
		Range = 2,
		Noted = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end

do
	local Warrior = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior"

	ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Warrior_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Warrior_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.SkeletonWarrior",
		Resource = Warrior
	}

	ItsyScape.Meta.ResourceName {
		Value = "Skeleton warrior",
		Language = "en-US",
		Resource = Warrior
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A warrior faithful to Yendor, even in death.",
		Language = "en-US",
		Resource = Warrior
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Warrior
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Warrior
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Warrior
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Warrior
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Warrior
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzePlatebody",
		Count = 1,
		Resource = Warrior
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeMace",
		Count = 1,
		Resource = Warrior
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Chef_Primary"
	local SecondaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Chef_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CommonLogs",
		Weight = 200,
		Count = 2,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Sardine",
		Weight = 50,
		Count = 3,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SeaBass",
		Weight = 25,
		Count = 2,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "ChefsHat",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "WhiteApron",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeHelmet",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeDagger",
		Weight = 50,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end

do
	local Chef = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonChef"

	ItsyScape.Resource.Peep "HighChambersYendor_SkeletonChef" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Chef_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Chef_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.SkeletonChef",
		Resource = Chef
	}

	ItsyScape.Meta.ResourceName {
		Value = "Skeleton chef",
		Language = "en-US",
		Resource = Chef
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Don't have to worry about them spitting in your food.",
		Language = "en-US",
		Resource = Chef
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Chef
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Chef
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Chef
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Chef
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Chef
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "WhiteApron",
		Count = 1,
		Resource = Chef
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ChefsHat",
		Count = 1,
		Resource = Chef
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeDagger",
		Count = 1,
		Resource = Chef
	}
end

do
	local Parasite = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite"

	ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.CthulhuianParasite",
		Resource = Parasite
	}

	ItsyScape.Meta.ResourceName {
		Value = "New-born Cthulhuian parasite",
		Language = "en-US",
		Resource = Parasite
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A human recently turned by Cthulhu, Yendor's ancient avatar and the First High Priest of His faith.",
		Language = "en-US",
		Resource = Parasite
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Parasite
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Eldritch",
		Resource = Parasite
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = Parasite
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = Parasite
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = Parasite
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Parasite
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = Parasite
	}
end