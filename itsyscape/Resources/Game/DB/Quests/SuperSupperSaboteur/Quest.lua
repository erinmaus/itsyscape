--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/SuperSupperSaboteur/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Poison = ItsyScape.Resource.Item "SuperSupperSaboteur_Poison"

	ItsyScape.Meta.ResourceName {
		Value = "Poison evidence",
		Language = "en-US",
		Resource = Poison
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You found this poison in Lyra's shop.",
		Language = "en-US",
		Resource = Poison
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Resource = Poison
	}
end

do
	local UnlitBirthdayCandle = ItsyScape.Resource.Item "SuperSupperSaboteur_UnlitBirthdayCandle"
	local LitBirthdayCandle = ItsyScape.Resource.Item "SuperSupperSaboteur_LitBirthdayCandle"

	local LightAction = ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		},

		Input {
			Resource = UnlitBirthdayCandle,
			Count = 1
		},

		Output {
			Resource = LitBirthdayCandle,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}

	UnlitBirthdayCandle {
		LightAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Light",
		XProgressive = "Lighting",
		Language = "en-US",
		Action = LightAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fat",
		Value = "Candle",
		Resource = UnlitBirthdayCandle
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unlit birthday candle",
		Language = "en-US",
		Resource = UnlitBirthdayCandle
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A candle to celebrate Earl Reddick's birthday. Needs to be lit.",
		Language = "en-US",
		Resource = UnlitBirthdayCandle
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Value = ItsyScape.Utility.valueForItem(15),
		Resource = UnlitBirthdayCandle
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lit birthday candle",
		Language = "en-US",
		Resource = LitBirthdayCandle
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A lit candle to be put atop Earl Reddick's birthday carrot cake.",
		Language = "en-US",
		Resource = LitBirthdayCandle
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Value = ItsyScape.Utility.valueForItem(16),
		Resource = LitBirthdayCandle
	}
end

do
	local DemonContract = ItsyScape.Resource.Item "SuperSupperSaboteur_DemonContract"

	ItsyScape.Meta.ResourceName {
		Value = "Demonic assassin contract",
		Language = "en-US",
		Resource = DemonContract
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Summons a demon to assassinate Earl Reddick.",
		Language = "en-US",
		Resource = DemonContract
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Resource = DemonContract
	}

	local Assassin = ItsyScape.Resource.Peep "SuperSupperSaboteur_DemonicAssassin"

	ItsyScape.Meta.ResourceTag {
		Value = "Demonic",
		Resource = Assassin
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Demonic.BaseDemonic",
		Resource = Assassin
	}

	ItsyScape.Meta.ResourceName {
		Value = "Demonic assassin",
		Language = "en-US",
		Resource = Assassin
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "He's here to assassinate the Earl!",
		Language = "en-US",
		Resource = Assassin
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronZweihander",
		Count = 1,
		Resource = Assassin
	}
end

do
	local HellhoundContract = ItsyScape.Resource.Item "SuperSupperSaboteur_HellhoundContract"

	ItsyScape.Meta.ResourceName {
		Value = "Hellhound contract",
		Language = "en-US",
		Resource = HellhoundContract
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Summons a hellhound to assassinate Earl Reddick.",
		Language = "en-US",
		Resource = HellhoundContract
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Resource = HellhoundContract
	}

	local Hellhound = ItsyScape.Resource.Peep "SuperSupperSaboteur_Hellhound"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Demonic.Hellhound",
		Resource = Hellhound
	}

	ItsyScape.Meta.ResourceName {
		Value = "Hellhound",
		Language = "en-US",
		Resource = Hellhound
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's one ferocious dog from Daemon Realm!",
		Language = "en-US",
		Resource = Hellhound
	}
end

do
	local RecipeCard = ItsyScape.Resource.Item "SuperSupperSaboteur_SecretCarrotCakeRecipeCard" {
		ItsyScape.Action.ReadRecipe() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "VegetableOil",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "DarkBrownSugar",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "RegalPecan",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chef Allon's secret carrot cake recipe",
		Language = "en-US",
		Resource = RecipeCard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This is the secret carrot cake recipe Chef Allon prepared for Earl Reddick's birthday.",
		Language = "en-US",
		Resource = RecipeCard
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Resource = RecipeCard
	}
end

do
	local Milk = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Old Girl's milk",
		Language = "en-US",
		Resource = Milk
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Milk from the sweetest cow in the Realm!",
		Language = "en-US",
		Resource = Milk
	}

	ItsyScape.Meta.Ingredient {
		Item = Milk,
		Ingredient = ItsyScape.Resource.Ingredient "Milk"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Milk
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Milk,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Milk,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Milk,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 3,
		Resource = Milk
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Milk,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Cooking",
		Boost = 3,
		Resource = Milk
	}
end

do
	local Butter = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		},

		ItsyScape.Action.Churn() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsMilk",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			},

			Output {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_OldGirlsButter",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Churn",
		Value = "Butter",
		Resource = Butter
	}

	ItsyScape.Meta.ResourceName {
		Value = "Old Girl's butter",
		Language = "en-US",
		Resource = Butter
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The sweetest butter from the sweetest cow in the Realm!",
		Language = "en-US",
		Resource = Butter
	}

	ItsyScape.Meta.Ingredient {
		Item = Butter,
		Ingredient = ItsyScape.Resource.Ingredient "Butter"
	}

	ItsyScape.Meta.Ingredient {
		Item = Butter,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Butter
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Butter,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Butter,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Butter,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 3,
		Resource = Butter
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Butter,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Foraging",
		Boost = 3,
		Resource = Butter
	}
end

do
	local GoldenEgg = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Golden egg",
		Language = "en-US",
		Resource = GoldenEgg
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That egg won't crack if you drop it!",
		Language = "en-US",
		Resource = GoldenEgg
	}

	ItsyScape.Meta.Ingredient {
		Item = GoldenEgg,
		Ingredient = ItsyScape.Resource.Ingredient "Egg"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10),
		Stackable = 1,
		Resource = GoldenEgg
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenEgg,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = GoldenEgg,
		Value = ItsyScape.Utility.valueForItem(10)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenEgg,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 3,
		Resource = GoldenEgg
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenEgg,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Crafting",
		Boost = 3,
		Resource = GoldenEgg
	}
end

do
	local GoldenCarrot = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		},

		ItsyScape.Action.Pick() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Foraging",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Foraging",
				Count = ItsyScape.Utility.xpForResource(11)
			},

			Output {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Golden carrot",
		Language = "en-US",
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "One fine carrot, yum!",
		Language = "en-US",
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.Ingredient {
		Item = GoldenCarrot,
		Ingredient = ItsyScape.Resource.Ingredient "Carrot"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(15),
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenCarrot,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = GoldenCarrot,
		Value = ItsyScape.Utility.valueForItem(15)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenCarrot,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 1,
		Resource = GoldenCarrot
	}

	ItsyScape.Meta.ItemUserdata {
		Item = GoldenCarrot,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Woodcutting",
		Boost = 5,
		Resource = GoldenCarrot
	}
end

do
	local Flour = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SuperSupperSaboteur_DandelionFlour",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dandelion flour",
		Language = "en-US",
		Resource = Flour
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Flour from the roots of a crazy dandelion.",
		Language = "en-US",
		Resource = Flour
	}

	ItsyScape.Meta.Ingredient {
		Item = Flour,
		Ingredient = ItsyScape.Resource.Ingredient "Flour"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(10),
		Resource = Flour
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Flour,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Flour,
		Value = ItsyScape.Utility.valueForItem(10)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Flour,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 5,
		Resource = Flour
	}
end

do
	local Chicken = ItsyScape.Resource.Peep "SuperSupperSaboteur_GoldenChicken" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Chicken_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "GoldenChicken_Secondary",
				Count = 1
			},
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "GoldenChicken_Tertiary",
				Count = 1
			}
		}
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = Chicken,
		Name = "Chicken",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Peeps/Chicken/GoldenChicken_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	Chicken {
		TalkAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Chicken.GoldenChicken",
		Resource = Chicken
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chicken",
		Language = "en-US",
		Resource = Chicken
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What a golden chicken! Looks kind of tough too!",
		Language = "en-US",
		Resource = Chicken
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Chicken
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = Chicken
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(100),
		Resource = Chicken
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "GoldenFeather",
		Weight = 1,
		Count = 10,
		Range = 5,
		Resource = ItsyScape.Resource.DropTable "GoldenChicken_Secondary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Egg",
		Weight = 10,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "GoldenChicken_Tertiary"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenEgg",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "GoldenChicken_Tertiary"
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(50, 1),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(45),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Chicken
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Chicken/Chicken_IdleLogic.lua",
		IsDefault = 1,
		Resource = Chicken
	}
end

do
	local GoldenCarrotProp = ItsyScape.Resource.Prop "SuperSupperSaboteur_GoldenCarrot"

	local FakePickAction = ItsyScape.Action.Talk() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(10),
		}
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Pick",
		XProgressive = "Picking",
		Language = "en-US",
		Action = FakePickAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = GoldenCarrotProp,
		Name = "GoldenCarrot",
		Action = FakePickAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Farm1/Dialog/GoldenCarrot_en-US.lua",
		Language = "en-US",
		Action = FakePickAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "Rumbridge_Farmer",
		Name = "Farmer",
		Action = FakePickAction
	}

	GoldenCarrotProp {
		FakePickAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Golden carrot",
		Language = "en-US",
		Resource = GoldenCarrotProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's one shiny carrot!",
		Language = "en-US",
		Resource = GoldenCarrotProp
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Veggies.BaseVeggieProp",
		Resource = GoldenCarrotProp
	}

	local GoldenCarrotPeep = ItsyScape.Resource.Peep "SuperSupperSaboteur_GoldenCarrot" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "SuperSupperSaboteur_GoldenCarrot_Primary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "SuperSupperSaboteur_GoldenCarrot",
		Weight = 1,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "SuperSupperSaboteur_GoldenCarrot_Primary"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Veggies.GoldenCarrot",
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.ResourceName {
		Value = "Angry golden carrot",
		Language = "en-US",
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That is one *angry* carrot!",
		Language = "en-US",
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(75),
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(15),
		Resource = GoldenCarrotPeep
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(15),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10, 0.9),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 0.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(15, 1.3),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(30),
		Resource = GoldenCarrotPeep
	}
end

local Quest = ItsyScape.Utility.Quest
local Step = ItsyScape.Utility.QuestStep
local Branch = ItsyScape.Utility.QuestBranch
local Description = ItsyScape.Utility.QuestStepDescription

ItsyScape.Meta.ResourceName {
	Value = "Super Supper Saboteur",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "SuperSupperSaboteur"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Chef Allon is planning to make dinner and dessert for the Earl of Rumbridge, but is in over his head.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "SuperSupperSaboteur"
}

ItsyScape.Resource.Quest "SuperSupperSaboteur"

Quest "SuperSupperSaboteur" {
	requirements = {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(5)
		}
	},

	rewards = {
		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = 5000
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = 2000
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = 1500
		},

		Output {
			Resource = ItsyScape.Resource.Item "Carrot",
			Count = 20
		},

		Output {
			Resource = ItsyScape.Resource.Item "AllPurposeFlour",
			Count = 20
		},

		Output {
			Resource = ItsyScape.Resource.Item "Butter",
			Count = 20
		},

		Output {
			Resource = ItsyScape.Resource.Item "TableSalt",
			Count = 20
		},

		Output {
			Resource = ItsyScape.Resource.Item "VegetableOil",
			Count = 20
		},

		Output {
			Resource = ItsyScape.Resource.Item "GoldenPecan",
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 50000
		}
	},

	Step "SuperSupperSaboteur_Started",
	Step "SuperSupperSaboteur_GotRecipe",
	Step "SuperSupperSaboteur_GotYelledAtForGoldenCarrot",
	Step "SuperSupperSaboteur_GotPermissionForGoldenCarrot",
	Step "SuperSupperSaboteur_TurnedInCake",
	Step "SuperSupperSaboteur_ButlerDied",
	Step "SuperSupperSaboteur_ButlerInspected",
	Step "SuperSupperSaboteur_TalkedToGuardCaptain",
	Step "SuperSupperSaboteur_TalkedToLyra",
	Step "SuperSupperSaboteur_FoundEvidence",
	Step "SuperSupperSaboteur_GotConfessionFromLyra",
	Branch {
		{
			Step "SuperSupperSaboteur_TurnedInLyra",
			Branch {
				{
					Step "SuperSupperSaboteur_LitBirthdayCandle",
					Step "SuperSupperSaboteur_Complete"
				},
				{
					Step "SuperSupperSaboteur_LitKursedCandle",
					Step "SuperSupperSaboteur_Complete"
				}	
			}
		},

		{
			Step "SuperSupperSaboteur_AgreedToHelpLyra",
			Step "SuperSupperSaboteur_TalkedToCapnRaven",
			Step "SuperSupperSaboteur_MadeCandle",
			Step "SuperSupperSaboteur_GotContracts",
			Step "SuperSupperSaboteur_BlamedSomeoneElse",

			Branch {
				{
					Step "SuperSupperSaboteur_BetrayedLyra",
					Branch {
						{
							Step "SuperSupperSaboteur_LitBirthdayCandle",
							Step "SuperSupperSaboteur_Complete"
						},
						{
							Step "SuperSupperSaboteur_LitKursedCandle",
							Step "SuperSupperSaboteur_Complete"
						}	
					}
				},
				{
					Step "SuperSupperSaboteur_LitBirthdayCandle",
					Step "SuperSupperSaboteur_Complete"
				},
				{
					Step "SuperSupperSaboteur_LitKursedCandle",
					Step "SuperSupperSaboteur_Complete"
				}
			}
		}
	},
	Step "SuperSupperSaboteur_Complete"
}

Description "SuperSupperSaboteur_Started" {
	before = "Start Super supper Saboteur by speaking to Chef Allon at the Rumbridge Castle kitchen.",
	after = "Chef Allon wants to cook a spectacular dinner for the Earl, Reddick. He enlisted your help after receiving a glowing recommendation from Advisor Grimm."
}

Description "SuperSupperSaboteur_GotRecipe" {
	before = "What are the ingredients to the recipe?",
	after = "Chef Allon gave you a super secret recipe card with the ingredients. If you lost it, go back to see him for another."
}

Description "SuperSupperSaboteur_GotYelledAtForGoldenCarrot" {
	before = "The golden carrot is probably grown by a farmer from Rumbridge farms. The farms are east of the castle, north of Leafy Lake.",
	after = "The grumpy farmer won't let you pick his prized golden carrot. Maybe speak to him?",
}

Description "SuperSupperSaboteur_GotPermissionForGoldenCarrot" {
	before = "The grumpy farmer needs to give you permission to pick his golden carrot.",
	after = "The grumpy farmer decided to let you pick the golden carrot, since it is for the Earl's birthday."
}

Description "SuperSupperSaboteur_TurnedInCake" {
	before = "Gather the ingredients and bake the cake! Chef Allon will know if you don't follow the recipe...",
	after = "Chef Allon is pleased with your baking work and took in the cake."
}

Description "SuperSupperSaboteur_ButlerDied" {
	before = "The butler needs help.",
	after = "The butler died. Rest in peace."
}

Description "SuperSupperSaboteur_ButlerInspected" {
	before = "Maybe the scene of the crime has clues.",
	after = "After running to the butler's aid, a large canine ran away."
}

Description "SuperSupperSaboteur_TalkedToGuardCaptain" {
	before = "Chef Allon grabbed the Rumbridge guard captain to talk to them.",
	after = "Chef Allon insisted you investigate Lyra."
}

Description "SuperSupperSaboteur_TalkedToLyra" {
	before = "Lyra, the witch in the Shade district of Rumbridge, has a large wolf familiar, according to the Rumbridge guard captain.",
	after = "When speaking to Lyra, she seemed suspicious."
}

Description "SuperSupperSaboteur_FoundEvidence" {
	before = "Maybe Lyra is hiding something.",
	after = "Lyra had a dangerous, magical poison in the coffin. Is this enough evidence to get a confession?"
}

Description "SuperSupperSaboteur_GotConfessionFromLyra" {
	before = "Confront Lyra about the poison you found in her shop.",
	after = "Lyra confessed to preparing a poison to kill Earl Reddick."
}

Description "SuperSupperSaboteur_TurnedInLyra" {
	before = "Should you turn in Lyra to Earl Reddick above the kitchens of Rumbridge?",
	after = "You turned in Lyra to Earl Reddick, who got the guards to arrest her and confine her to the dungeon."
}

Description "SuperSupperSaboteur_LitBirthdayCandle" {
	before = "Chef Allon might be a good chef, but he lacks the firemaking level to light the birthday candle.",
	after = "Chef Allon appreciated your firemaking expertise when lighting the birthday candle."
}

Description "SuperSupperSaboteur_AgreedToHelpLyra" {
	before = "Should you help Lyra assassinate Earl Reddick?",
	after = "Wow, you agreed to help Lyra assassinate Earl Reddick! Look at you."
}

Description "SuperSupperSaboteur_TalkedToCapnRaven" {
	before = "Cap'n Raven and her crew has been bragging about finding a freshly beached Yendorian whale to drunkards at the bar, but she's keeping the location a secret.",
	after = "Cap'n Raven agreed to take you to the Yendorian whale because she likes your guts, but she stuck you in the brig when doing so."
}

Description "SuperSupperSaboteur_MadeCandle" {
	before = "Lyra lacks the firemaking level to make a kursed birthday candle from the whale wax.",
	after = "Thanks to your firemaking prowess, you made a kursed birthday candle for Lyra."
}

Description "SuperSupperSaboteur_GotContracts" {
	before = "Lyra said to meet her back in her shop in the Shade district.",
	after = "Lyra gave you some demonic contracts to summon a demon and its hellhound familiar to assassinate the Earl."
}

Description "SuperSupperSaboteur_BlamedSomeoneElse" {
	before = "Bring both demonic contracts with you and find the Earl to summon the demons.",
	after = "The Rumbridge guards proved too capable and the demon and hellhound were slain. Time for Plan B!"
}

Description "SuperSupperSaboteur_BetrayedLyra" {
	before = "Lyra can still be turned in to Earl Reddick.",
	after = "Lyra was betrayed by you after turning her in despite agreeing to help!"
}

Description "SuperSupperSaboteur_LitKursedCandle" {
	before = "Chef Allon needs you to light the birthday candle. Will you hand over a kursed candle instead?",
	after = "You lit the kursed candle and gave it to the Chef. The Earl will die!"
}

Description "SuperSupperSaboteur_Complete" {
	before = "Chef Allon still has something to say.",
	after = "You completed Super Supper Saboteur. Check your bank for rewards. What a quest!"
}
