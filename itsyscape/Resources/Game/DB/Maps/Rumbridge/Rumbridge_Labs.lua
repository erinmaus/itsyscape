--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Labs.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------f-------------------------------------------------------

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "Hex" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Hex.BaseHex",
		Resource = ItsyScape.Resource.Peep "Hex"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Hex",
		Resource = ItsyScape.Resource.Peep "Hex"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "...she might be totally, irrevocably, permanently insane.",
		Resource = ItsyScape.Resource.Peep "Hex"
	}
end

do
	ItsyScape.Resource.Peep "Emily_Default" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Emily.BaseEmily",
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Emily",
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "She's usually friendly... Usually.",
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(1000),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(500),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(1000),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(250),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(255),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForItem(95),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(95),
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(90),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(110, 1.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(110, 1.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(110, 1.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(100, 0.7),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(100, 0.7),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(100),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(100),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(120),
		Resource = ItsyScape.Resource.Peep "Emily_Default"
	}
end

do
	ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer_Pillar" {
		-- Nothing.
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 12,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer_Pillar"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer_Pillar"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Jakkenstone shard analyzer pillar",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer_Pillar"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The energy from that pillar tingles the spine...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer_Pillar"
	}
end

do
	ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer" {
		-- Nothing.
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 7.5,
		SizeY = 4,
		SizeZ = 7.5,
		MapObject = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Jakkenstone shard analyzer",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A mysterious artifact.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HexLabs_JakkenstoneShardAnalyzer"
	}
end

do
	ItsyScape.Resource.Prop "HexLabs_Vat" {
		-- Nothing.
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 4,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "HexLabs_Vat"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = ItsyScape.Resource.Prop "HexLabs_Vat"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Life support vat",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HexLabs_Vat"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Rather be out here than in there...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "HexLabs_Vat"
	}
end

do
	ItsyScape.Resource.Peep "Draconic_Sleeping" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Draconic",
		Resource = ItsyScape.Resource.Peep "Draconic_Sleeping"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Draconic.SleepingDraconic",
		Resource = ItsyScape.Resource.Peep "Draconic_Sleeping"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Draconic monstrosity",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Draconic_Sleeping"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What horrible experiment produced this monster?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Draconic_Sleeping"
	}
end

do
	ItsyScape.Resource.Peep "Robot_MkII" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Robot_MkII_Primary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Robot_MkII",
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Robot.MkIIRobot",
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Robot, Mk. II",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An example of sufficiently advanced technology being indistinguishable from magic.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(30),
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronBar",
		Weight = 10,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Robot_MkII_Primary"	
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronBar",
		Weight = 5,
		Count = 2,
		Resource = ItsyScape.Resource.DropTable "Robot_MkII_Primary"	
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronBar",
		Weight = 1,
		Count = 4,
		Resource = ItsyScape.Resource.DropTable "Robot_MkII_Primary"	
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForItem(20, 0.5),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(30, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(5, 1),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(30, 1.5),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(25),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "Robot_MkII"
	}
end

do
	ItsyScape.Resource.Prop "Door_HexLabs" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "Door_HexLabs"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lab door",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Door_HexLabs"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Prevents unauthorized access.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Door_HexLabs"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 12,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Door_HexLabs"
	}
end

do
	ItsyScape.Resource.Prop "TV_HexLabs" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicTV",
		Resource = ItsyScape.Resource.Prop "TV_HexLabs"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Televiewer",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "TV_HexLabs"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Scries across dimensions in high definition.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "TV_HexLabs"
	}
end

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "The door's lock refuses to budge.",
	Resource = ItsyScape.Resource.KeyItem "HexLabs_GainedAccessToElevator"
}
