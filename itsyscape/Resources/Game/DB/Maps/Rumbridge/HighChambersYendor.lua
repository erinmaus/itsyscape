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
		SizeX = 2,
		SizeY = 1.5,
		SizeZ = 4,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_Bed"
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
