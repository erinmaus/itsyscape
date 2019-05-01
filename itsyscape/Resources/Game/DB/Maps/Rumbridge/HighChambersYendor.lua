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
	ItsyScape.Resource.Prop "HighChambersYendor_Entrance" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "High Chambers Yendor",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Entrance"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The deeper you delve, the more you risk madness.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Entrance"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Entrance"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2,
		SizeY = 4,
		SizeZ = 2,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_Entrance"
	}
end

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
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Ghost_Primary"
	local SecondaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Ghost_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Count = 5000,
		Range = 2500,
		Weight = 100,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BoneShards",
		Count = 100,
		Range = 50,
		Weight = 100,
		Resource = SecondaryDropTable
	}
end

do
	local Ghost = ItsyScape.Resource.Peep "HighChambersYendor_Ghost"

	ItsyScape.Resource.Peep "HighChambersYendor_Ghost" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Ghost_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Ghost_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Ghost.BaseGhost",
		Resource = Ghost
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ghost",
		Language = "en-US",
		Resource = Ghost
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Boo!",
		Language = "en-US",
		Resource = Ghost
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Ghost
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Ghost
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Ghost
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = Ghost
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Ghost
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Ghost
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(10),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
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
	local Archer = ItsyScape.Resource.Peep "HighChambersYendor_ZombiArcher"

	ItsyScape.Resource.Peep "HighChambersYendor_ZombiArcher" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Archer_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Zombi.BaseZombi",
		Resource = Archer
	}

	ItsyScape.Meta.ResourceName {
		Value = "Zombi archer",
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
		Item = ItsyScape.Resource.Item "MooishLeatherBoots",
		Count = 1,
		Resource = Archer
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "MooishLeatherGloves",
		Count = 1,
		Resource = Archer
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PunyLongbow",
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
	local Parasite = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite_Regular"

	ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite_Regular" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_CthulhianParasite_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_CthulhianParasite_Primary",
				Count = 1
			}
		}
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

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Parasite
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = Parasite
	}
end

do
	local Warrior = ItsyScape.Resource.Peep "HighChambersYendor_ZombiWarrior"

	ItsyScape.Resource.Peep "HighChambersYendor_ZombiWarrior" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Warrior_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Zombi.BaseZombi",
		Resource = Warrior
	}

	ItsyScape.Meta.ResourceName {
		Value = "Zombi warrior",
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
		Item = ItsyScape.Resource.Item "RustyPlatebody",
		Count = 1,
		Resource = Warrior
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "RustyGloves",
		Count = 1,
		Resource = Warrior
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "RustyBoots",
		Count = 1,
		Resource = Warrior
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeLongsword",
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
	local Pirate = ItsyScape.Resource.Peep "HighChambersYendor_ZombiPirate"

	ItsyScape.Resource.Peep "HighChambersYendor_ZombiPirate" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Pirate_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Zombi.BaseZombi",
		Resource = Pirate
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/PirateVest.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Pirate
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceName {
		Value = "Zombi pirate",
		Language = "en-US",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A member of the Black Tentacle bound to an eternity in service to Yendor.",
		Language = "en-US",
		Resource = Pirate
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Pirate
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeLongsword",
		Count = 1,
		Resource = Pirate
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Pirate_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 200,
		Count = 2000,
		Range = 1000,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CookedSardine",
		Weight = 200,
		Count = 3,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CookedSeaBass",
		Weight = 100,
		Count = 2,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PiratesHat",
		Weight = 25,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronCannonball",
		Weight = 100,
		Count = 10,
		Range = 5,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyDagger",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_CthulhianParasite_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 400,
		Count = 1000,
		Range = 500,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CookedSeaBass",
		Weight = 200,
		Count = 2,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Weight = 25,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "PiratesHat",
		Weight = 10,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AirRune",
		Weight = 50,
		Count = 100,
		Range = 50,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "EarthRune",
		Weight = 50,
		Count = 100,
		Range = 50,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyDagger",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
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

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Parasite
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "DinkyStaff",
		Count = 1,
		Resource = Parasite
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_SoulSiphon" {
		ItsyScape.Action.Collect()
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Soul siphon",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SoulSiphon"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "A divine scrying tool constructed to steal souls at any distance by Prisium, the Great Intelligence.",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SoulSiphon"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicChest",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_SoulSiphon"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 2.5,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "HighChambersYendor_SoulSiphon"
	}

	local CavePotatoReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CavePotato",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CavePotatoReward,
		Weight = 200
	}

	local SailorsHatReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "SailorsHat",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = SailorsHatReward,
		Weight = 10
	}

	local AirRuneReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 100
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = AirRuneReward,
		Weight = 100
	}

	local EarthRuneReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 30
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = EarthRuneReward,
		Weight = 100
	}

	local BoneShardsReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "BoneShards",
			Count = 30
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = BoneShardsReward,
		Weight = 100
	}

	local BonesReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Bones",
			Count = 2
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = BonesReward,
		Weight = 100
	}

	local WeakGumReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "WeakGum",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = WeakGumReward,
		Weight = 50
	}

	local EldritchMyrrhReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "EldritchMyrrh",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = EldritchMyrrhReward,
		Weight = 5
	}

	ItsyScape.Resource.DropTable "HighChambersYendor_SoulSiphon_Rewards" {
		CavePotatoReward,
		SailorsHatReward,
		AirRuneReward,
		EarthRuneReward,
		BoneShardsReward,
		BonesReward,
		EldritchMyrrhReward
	}
end

do
	local Sailor = ItsyScape.Resource.Peep "HighChambersYendor_ZombiSailor"

	ItsyScape.Resource.Peep "HighChambersYendor_ZombiSailor" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Sailor_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Zombi_Base_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Zombi.BaseZombi",
		Resource = Sailor
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hands/Zombi.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Sailor
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/White.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Sailor
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shoes/LongBoots1.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Sailor
	}

	ItsyScape.Meta.ResourceName {
		Value = "Zombi sailor",
		Language = "en-US",
		Resource = Sailor
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Driven mad by Cthulhu and forced to serve Yendor for eternity.",
		Language = "en-US",
		Resource = Sailor
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = Sailor
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Sailor
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Sailor
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = Sailor
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = Sailor
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeLongsword",
		Count = 1,
		Resource = Sailor
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Count = 1,
		Resource = Sailor
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Sailor_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 400,
		Count = 500,
		Range = 100,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CookedSardine",
		Weight = 200,
		Count = 3,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CookedSeaBass",
		Weight = 100,
		Count = 2,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Weight = 200,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronCannonball",
		Weight = 100,
		Count = 5,
		Range = 3,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyDagger",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BronzeDagger",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "TinCan",
		Weight = 25,
		Count = 10,
		Range = 5,
		Noted = 1,
		Resource = PrimaryDropTable
	}
end

do
	local Rat = ItsyScape.Resource.Peep "HighChambersYendor_Rat"

	ItsyScape.Resource.Peep "HighChambersYendor_Rat" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Rat_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.BaseRat",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Disgusting!",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = Rat
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(10),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Rat
	}
end

do
	local RatKing = ItsyScape.Resource.Peep "HighChambersYendor_RatKing"

	ItsyScape.Resource.Peep "HighChambersYendor_RatKing" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "HighChambersYendor_Rat_Secondary",
				Count = 1
			}
		}
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
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = RatKing
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = RatKing
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(15),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = RatKing
	}
end

do
	local Coins500Reward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 500
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = Coins500Reward,
		Weight = 500
	}

	local Coins1000Reward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 1000
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = Coins1000Reward,
		Weight = 250
	}

	local Coins100KReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100000
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = Coins100KReward,
		Weight = 1
	}

	local SapphireReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Sapphire",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = SapphireReward,
		Weight = 40
	}

	local EmeraldReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Emerald",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = EmeraldReward,
		Weight = 20
	}

	local RubyReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Ruby",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = RubyReward,
		Weight = 10
	}

	local DiamondReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Diamond",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = DiamondReward,
		Weight = 10
	}

	local GoldenRingReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldenRing",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldenRingReward,
		Weight = 20
	}

	ItsyScape.Resource.DropTable "HighChambersYendor_RatKing_Rewards" {
		Coins500Reward,
		Coins1000Reward,
		Coins100KReward,
		SapphreReward,
		EmeraldReward,
		RubyReward,
		DiamondReward,
		GoldenRingReward
	}
end

do
	local SecondaryDropTable = ItsyScape.Resource.DropTable "HighChambersYendor_Rat_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end

do
	ItsyScape.Resource.Prop "YendorianObelisk" {
		ItsyScape.Action.Offer() {
			Input {
				Resource = ItsyScape.Resource.Item "Bones",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian obelisk",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "YendorianObelisk"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Your prayers may be heard, given a sacrifice...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "YendorianObelisk"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "YendorianObelisk"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant1"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant1"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian vase",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant1"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Who knows what those patterns represent...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant1"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant2"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant2"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian vase",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant2"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's something moving inside!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Vase_Variant2"
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_Mirror"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicMirror",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Mirror"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient mirror",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Mirror"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Light glints off the surface.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_Mirror"
	}

	local RotateRightAction = ItsyScape.Action.Rotate()
	ItsyScape.Meta.RotateActionDirection {
		RotationX = -ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = -ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = -ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Action = RotateRightAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Rotate-right",
		Language = "en-US",
		Action = RotateRightAction
	}

	local RotateLeftAction = ItsyScape.Action.Rotate()
	ItsyScape.Meta.RotateActionDirection {
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Action = RotateLeftAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Rotate-left",
		Language = "en-US",
		Action = RotateLeftAction
	}

	ItsyScape.Resource.Prop "HighChambersYendor_Mirror" {
		RotateRightAction,
		RotateLeftAction
	}
end

do
	ItsyScape.Resource.Prop "HighChambersYendor_LightSphere"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.HighChambersYendor.LightSphere",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_LightSphere"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Eye of Man'Tok, The First One",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_LightSphere"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The ancient eye of an ancient beast. What horrors has it seen?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HighChambersYendor_LightSphere"
	}

	local RotateRightAction = ItsyScape.Action.Rotate()
	ItsyScape.Meta.RotateActionDirection {
		RotationX = -ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = -ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = -ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Action = RotateRightAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Rotate-right",
		Language = "en-US",
		Action = RotateRightAction
	}

	local RotateForwardAction = ItsyScape.Action.Rotate()
	ItsyScape.Meta.RotateActionDirection {
		RotationX = ItsyScape.Utility.Quaternion.Z_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Z_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Z_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Z_90.w,
		Action = RotateForwardAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Rotate-forward",
		Language = "en-US",
		Action = RotateForwardAction
	}

	ItsyScape.Resource.Prop "HighChambersYendor_LightSphere" {
		RotateRightAction,
		RotateForwardAction
	}
end

ItsyScape.Resource.Item "HighChambersYendor_BloodyIronKey" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "HighChambersYendor_BloodyIronKey"
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Bloody iron key",
	Resource = ItsyScape.Resource.Item "HighChambersYendor_BloodyIronKey"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "This key unlocks access to the innermost room in the High Chambers of Yendor, Floor 1 West.",
	Resource = ItsyScape.Resource.Item "HighChambersYendor_BloodyIronKey"
}
