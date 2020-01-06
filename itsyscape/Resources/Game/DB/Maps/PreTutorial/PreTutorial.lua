--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/PreTutorial/PreTutorial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
do
	local Rat = ItsyScape.Resource.Peep "PreTutorial_Rat"

	ItsyScape.Resource.Peep "PreTutorial_Rat" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "PreTutorial_Rat_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "PreTutorial_Rat_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.BaseRat",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceName {
		Value = "Purple rat",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Disgusting! But at least it smells like lavender.",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Rat
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = -100,
		AccuracySlash = -100,
		AccuracyCrush = -100,
		DefenseStab = -50,
		DefenseSlash = -50,
		DefenseCrush = -50,
		DefenseMagic = -50,
		DefenseRanged = -50,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Rat
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "PreTutorial_Rat_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 300,
		Count = 50,
		Range = 25,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CavePotato",
		Weight = 200,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "TinCan",
		Weight = 200,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "ShadowLogs",
		Weight = 100,
		Count = 1,
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
	local SecondaryDropTable = ItsyScape.Resource.DropTable "PreTutorial_Rat_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end

-- Larry
do
	ItsyScape.Resource.Prop "Larry_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Output {
				Resource = ItsyScape.Resource.Item "Larry",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Larry the 8th",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Larry_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Fancy name for a goldfish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Larry_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 2,
		SpawnTime = 1,
		Resource = ItsyScape.Resource.Prop "Larry_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "Larry_Default"
	}

	ItsyScape.Resource.Item "Larry" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Larry"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Larry the 8th",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Larry"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Aw, he's gone! Maybe he can be cooked...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Larry"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Larry"
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 1,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Larry",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedLarry",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(3)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Larry",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntLarry",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = 1
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = FailAction
	}

	ItsyScape.Meta.CookingFailedAction {
		Output = FailAction,
		Start = 1,
		Stop = 6,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedLarry" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedLarry"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Fire",
		Resource = ItsyScape.Resource.Item "CookedLarry"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Range",
		Resource = ItsyScape.Resource.Item "CookedLarry"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked Larry",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedLarry"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "WOW!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedLarry"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(4),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedLarry"
	}

	ItsyScape.Resource.Item "BurntLarry" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt Larry",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntLarry"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Should've just flushed him.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntLarry"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntLarry"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntLarry"
	}
end

do
	ItsyScape.Resource.Prop "Door_PreTutorialAzathothMansion" {
		ItsyScape.Action.Open() {
			Output {
				Resource = ItsyScape.Resource.KeyItem "PreTutorial_Start",
				Count = 1
			}
		},
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "Door_PreTutorialAzathothMansion"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Door",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Door_PreTutorialAzathothMansion"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 2,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Door_PreTutorialAzathothMansion"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Knock, knock.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Door_PreTutorialAzathothMansion"
	}
end

do
	ItsyScape.Resource.Prop "Door_PreTutorialAzathothFrontDoor" {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicDoor",
		Resource = ItsyScape.Resource.Prop "Door_PreTutorialAzathothFrontDoor"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Front door",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Door_PreTutorialAzathothFrontDoor"
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3.5,
		SizeY = 2,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "Door_PreTutorialAzathothFrontDoor"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What's behind that door?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Door_PreTutorialAzathothFrontDoor"
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "PreTutorial_ZombiButler" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "PreTutorial_ZombiButler",
		Name = "Butler",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/PreTutorial/ZombiButler_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PreTutorial.ZombiButler",
		Resource = ItsyScape.Resource.Peep "PreTutorial_ZombiButler"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Hans, Zombi Butler",
		Resource = ItsyScape.Resource.Peep "PreTutorial_ZombiButler"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "He's a bit slow, but what's left of his heart is in the right place.",
		Resource = ItsyScape.Resource.Peep "PreTutorial_ZombiButler"
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "PreTutorial_Elizabeth" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "PreTutorial_ZombiButler",
		Name = "Butler",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "PreTutorial_Elizabeth",
		Name = "Elizabeth",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/PreTutorial/Elizabeth_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PreTutorial.Elizabeth",
		Resource = ItsyScape.Resource.Peep "PreTutorial_Elizabeth"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Elizabeth",
		Resource = ItsyScape.Resource.Peep "PreTutorial_Elizabeth"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Cold, even for a ghost.",
		Resource = ItsyScape.Resource.Peep "PreTutorial_Elizabeth"
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "PreTutorial_Edward" {
		TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "PreTutorial_ZombiButler",
		Name = "Butler",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "PreTutorial_Edward",
		Name = "Edward",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/PreTutorial/Edward_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PreTutorial.Edward",
		Resource = ItsyScape.Resource.Peep "PreTutorial_Edward"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Edward",
		Resource = ItsyScape.Resource.Peep "PreTutorial_Edward"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Scared and pale as a ghost. Wait...",
		Resource = ItsyScape.Resource.Peep "PreTutorial_Edward"
	}
end
