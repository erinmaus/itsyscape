--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Fish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Supplies
do
	ItsyScape.Resource.Item "Bait" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Bait"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bait",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bait"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for fish, or if you're on a diet.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bait"
	}

	ItsyScape.Resource.Item "OldBoot" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(2),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(2),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "OldBoot"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 50,
		Resource = ItsyScape.Resource.Item "OldBoot"
	}

	ItsyScape.Meta.Item {
		Value = 0,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "OldBoot"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Waterlogged old boot with a hole in the sole",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "OldBoot"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This boot is useless, no one could patch it up! At least a fish won't eat it now!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "OldBoot"
	}

	ItsyScape.Resource.Item "WaterSlug" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(2),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(4),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "WaterSlug"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 200,
		Resource = ItsyScape.Resource.Item "WaterSlug"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3.5),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "WaterSlug"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Water slug",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WaterSlug"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Aww, what a cute lil' guy!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WaterSlug"
	}

	ItsyScape.Resource.Item "FishEggs" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(5),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(6.5),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "FishEggs"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 100,
		Resource = ItsyScape.Resource.Item "FishEggs"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(11.25),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "FishEggs"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fish eggs",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FishEggs"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Who knows what fish will hatch from these!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FishEggs"
	}

	ItsyScape.Resource.Item "WaterWorm" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(5),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(7.5),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "WaterWorm"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 50,
		Resource = ItsyScape.Resource.Item "WaterWorm"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(17.5),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "WaterWorm"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Water worm",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WaterWorm"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Eww, what a gross lil' guy!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WaterWorm"
	}

	ItsyScape.Resource.Item "BronzeDubloon" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(20),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(20),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "BronzeDubloon"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 10,
		Resource = ItsyScape.Resource.Item "BronzeDubloon"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(30),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BronzeDubloon"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bronze dubloon",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeDubloon"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not worth a lot to landlubbers, but can definitely barter with pirates.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BronzeDubloon"
	}

	ItsyScape.Resource.Item "SilverDubloon" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(40),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(40),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "SilverDubloon"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 5,
		Resource = ItsyScape.Resource.Item "SilverDubloon"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(45),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "SilverDubloon"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Silver dubloon",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SilverDubloon"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Worth something a bit to landlubbers, but worth more to pirates.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SilverDubloon"
	}

	ItsyScape.Resource.Item "GoldDubloon" {
		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Count = ItsyScape.Utility.xpForLevel(55),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = ItsyScape.Utility.xpForResource(55),
				Resource = ItsyScape.Resource.Skill "Fishing"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "GoldDubloon"
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 1,
		Resource = ItsyScape.Resource.Item "GoldDubloon"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(65),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "GoldDubloon"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Gold dubloon",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldDubloon"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Worth a lot to pirates and landlubbers alike!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GoldDubloon"
	}
end

-- Sardines
do
	ItsyScape.Resource.Prop "Sardine_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Sardine",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a sardine swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 2,
		SpawnTime = 20,
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Sardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(3)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "Sardine" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Beady eyes! Needs cooked.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "Sardine",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Sardine",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 4,
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Sardine",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "Sardine",
		Value = ItsyScape.Utility.valueForItem(3)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 4,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Sardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedSardine",
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
			Resource = ItsyScape.Resource.Item "Sardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntSardine",
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
		Start = 0,
		Stop = 4,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedSardine" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Bit salty. Better with rice.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(4),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Resource.Item "BurntSardine" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not even rice can make this better...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}
end

-- Sea bass
do
	ItsyScape.Resource.Prop "SeaBass_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "SeaBass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(5)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a sea bass swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 5,
		SpawnTime = 30,
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "SeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "SeaBass" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Only worth a few Bells. Whatever Bells are.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(6),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "SeaBass",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "SeaBass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 6,
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "SeaBass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "SeaBass",
		Value = ItsyScape.Utility.valueForItem(6)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 6,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "SeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedSeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "SeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntSeaBass",
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
		Start = 5,
		Stop = 10,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedSeaBass" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tastes like fish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(6),
		Weight = 1.1,
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Resource.Item "BurntSeaBass" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tastes like charred fish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}
end

-- Coelacanth
do
	ItsyScape.Resource.Prop "Coelacanth_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(20)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SeaBass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Coelacanth",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "Coelacanth_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Coelacanth.Coelacanth",
		Resource = ItsyScape.Resource.Prop "Coelacanth_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coelacanth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Coelacanth_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a coelacanth swimming in the water!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Coelacanth_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 100,
		SpawnTime = 1800,
		Resource = ItsyScape.Resource.Prop "Coelacanth_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Coelacanth",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(30)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "Coelacanth" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Coelacanth"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedCoelacanth"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedCoelacanth"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coelacanth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Coelacanth"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A rare, pre-historic monstrosity, what a catch!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Coelacanth"
	}

	ItsyScape.Meta.Item {
		Value = 150000,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Coelacanth"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "Coelacanth",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Coelacanth",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 20,
		Resource = ItsyScape.Resource.Item "Coelacanth"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Coelacanth",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "Coelacanth",
		Value = 200000
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 20,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Coelacanth",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedCoelacanth",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(30)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Coelacanth",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntCoelacanth",
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
		Start = 20,
		Stop = 100,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedCoelacanth" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedCoelacanth"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked coelacanth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedCoelacanth"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Dine like a dinosaur!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedCoelacanth"
	}

	ItsyScape.Meta.Item {
		Value = 200000,
		Weight = 1.1,
		Resource = ItsyScape.Resource.Item "CookedCoelacanth"
	}

	ItsyScape.Resource.Item "BurntCoelacanth" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt coelacanth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntCoelacanth"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Well that's one way to ruin a fish. Can still probably sell it for a pretty penny though...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntCoelacanth"
	}

	ItsyScape.Meta.Item {
		Value = 50000,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntCoelacanth"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntCoelacanth"
	}

	local TakeAction = ItsyScape.Action.Pick() {
		Output {
			Resource = ItsyScape.Resource.Item "Coelacanth",
			Count = 1
		}
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Take",
		XProgressive = "Taking",
		Language = "en-US",
		Action = TakeAction
	}

	ItsyScape.Resource.Prop "Coelacanth_Dead" {
		TakeAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Coelacanth.DeadCoelacanth",
		Resource = ItsyScape.Resource.Prop "Coelacanth_Dead"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dead coelacanth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Coelacanth_Dead"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Literally a fish out of water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Coelacanth_Dead"
	}

	ItsyScape.Resource.Peep "Coelacanth_Default"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Fish.Coelacanth",
		Resource = ItsyScape.Resource.Peep "Coelacanth_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coelacanth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Coelacanth_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "When you see a living, swimming coelacanth, an eldritch horror often isn't far behind.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "Coelacanth_Default"
	}
end

-- Bass
do
	ItsyScape.Resource.Prop "Bass_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Bass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "Bass_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Bass_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a bass swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Bass_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 8,
		SpawnTime = 15,
		Resource = ItsyScape.Resource.Prop "Bass_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "Bass_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(11)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "Bass" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Bass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Those are some big lips! Needs to be cooked.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(11),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Bass"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "Bass",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Bass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 12,
		Resource = ItsyScape.Resource.Item "Bass"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Bass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "Bass",
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Bass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 1,
		Resource = ItsyScape.Resource.Item "Bass"
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 8,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(11)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Bass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntBass",
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
		Start = 10,
		Stop = 15,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedBass" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "It might be radioactive...?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(24),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedBass"
	}

	ItsyScape.Resource.Item "BurntBass" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Is this radioactive..? Better toss it out and not found out!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntBass"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntBass"
	}
end

-- Alligator gar
do
	ItsyScape.Resource.Prop "AlligatorGar_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(15)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "AlligatorGar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(16)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "AlligatorGar_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Alligator gar",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "AlligatorGar_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's an alligator gar eyeing you from the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "AlligatorGar_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 10,
		SpawnTime = 15,
		Resource = ItsyScape.Resource.Prop "AlligatorGar_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "AlligatorGar_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AlligatorGar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(16)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "AlligatorGar" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Alligator gar",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's a big fish! Needs to be cooked.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(15),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "AlligatorGar",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "AlligatorGar",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 10,
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "AlligatorGar",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "AlligatorGar",
		Value = ItsyScape.Utility.valueForItem(15)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "AlligatorGar",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 1,
		Resource = ItsyScape.Resource.Item "AlligatorGar"
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 10,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AlligatorGar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedAlligatorGar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(16)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(15)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AlligatorGar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntAlligatorGar",
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
		Start = 15,
		Stop = 20,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedAlligatorGar" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedAlligatorGar"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedAlligatorGar"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedAlligatorGar"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked alligator gar",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedAlligatorGar"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tastes like a freshly grilled steak with a hint of fish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedAlligatorGar"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(16),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedAlligatorGar"
	}

	ItsyScape.Resource.Item "BurntAlligatorGar" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt alligator gar",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntAlligatorGar"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's ruined!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntAlligatorGar"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntAlligatorGar"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntAlligatorGar"
	}
end

-- Shrimp
do
	ItsyScape.Resource.Prop "Shrimp_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(20)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Shrimp",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(21)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "Shrimp_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Shrimp",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Shrimp_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a shrimp swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Shrimp_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 25,
		SpawnTime = 10,
		Resource = ItsyScape.Resource.Prop "Shrimp_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "Shrimp_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Shrimp",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "Shrimp" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Shrimp"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Shrimp",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Shrimp"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A bottom feeder. Needs to be cooked.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Shrimp"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(21),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Shrimp"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "Shrimp",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Shrimp",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 12,
		Resource = ItsyScape.Resource.Item "Shrimp"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Shrimp",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "Shrimp",
		Value = ItsyScape.Utility.valueForItem(21)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 12,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Shrimp",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedShrimp",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Shrimp",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntShrimp",
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
		Start = 20,
		Stop = 21,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedShrimp" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedShrimp"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedShrimp"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedShrimp"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked shrimp",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedShrimp"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "How does this tiny lil' guy heal so much?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedShrimp"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(24),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedShrimp"
	}

	ItsyScape.Resource.Item "BurntShrimp" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt shrimp",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntShrimp"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Crunchy...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntShrimp"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntShrimp"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntShrimp"
	}
end

-- Crawfish
do
	ItsyScape.Resource.Prop "Crawfish_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(25)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Crawfish",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(26)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "Crawfish_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Crawfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Crawfish_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a crawfish swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Crawfish_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 35,
		SpawnTime = 25,
		Resource = ItsyScape.Resource.Prop "Crawfish_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "Crawfish_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(25)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Crawfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(26)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "Crawfish" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Crawfish"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Crawfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Crawfish"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An angry, snappy bottom feeder. Needs to be cooked.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Crawfish"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(27),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Crawfish"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "Crawfish",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Crawfish",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 14,
		Resource = ItsyScape.Resource.Item "Crawfish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "Crawfish",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "Crawfish",
		Value = ItsyScape.Utility.valueForItem(27)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 14,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(25)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Crawfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedCrawfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(26)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(25)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Crawfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntCrawfish",
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
		Start = 20,
		Stop = 21,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedCrawfish" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedCrawfish"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedCrawfish"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedCrawfish"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked crawfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedCrawfish"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Hard to eat.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedCrawfish"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(29),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedCrawfish"
	}

	ItsyScape.Resource.Item "BurntCrawfish" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt crawfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntCrawfish"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Even necromancy can't bring this thing back from the dead.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntCrawfish"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntCrawfish"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntCrawfish"
	}
end

-- Lightning stormfish
do
	ItsyScape.Resource.Prop "LightningStormfish_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(35)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WaterWorm",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "LightningStormfish",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(36)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "LightningStormfish_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lightning stormfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "LightningStormfish_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a lightning stormfish swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "LightningStormfish_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 100,
		SpawnTime = 20,
		Resource = ItsyScape.Resource.Prop "LightningStormfish_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "LightningStormfish_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(35)
		},

		Input {
			Resource = ItsyScape.Resource.Item "LightningStormfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(37)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "LightningStormfish" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lightning stormfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A majestic, rare fish that swims to the surface only during storms. Some believe the fish to be a stormbringer itself.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(37),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "LightningStormfish",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "LightningStormfish",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 18,
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "LightningStormfish",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Firemaking",
		Boost = 3,
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 3,
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "LightningStormfish",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 6,
		Resource = ItsyScape.Resource.Item "LightningStormfish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "LightningStormfish",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "LightningStormfish",
		Value = ItsyScape.Utility.valueForItem(37)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 18,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(35)
		},

		Input {
			Resource = ItsyScape.Resource.Item "LightningStormfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedLightningStormfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(37)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(35)
		},

		Input {
			Resource = ItsyScape.Resource.Item "LightningStormfish",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntLightningStormfish",
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
		Start = 35,
		Stop = 40,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedLightningStormfish" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedLightningStormfish"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedLightningStormfish"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedLightningStormfish"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked lightning stormfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedLightningStormfish"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Quite a mouthful. Gives a tiny shock, but has a rich taste.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedLightningStormfish"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(40),
		Resource = ItsyScape.Resource.Item "CookedLightningStormfish"
	}

	ItsyScape.Resource.Item "BurntLightningStormfish" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt lightning stormfish",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntLightningStormfish"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "What a waste of such an amazing fish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntLightningStormfish"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntLightningStormfish"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntLightningStormfish"
	}
end

-- Blackmelt bass
do
	ItsyScape.Resource.Prop "BlackmeltBass_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WaterSlug",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BlackmeltBass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		}
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = ItsyScape.Resource.Prop "BlackmeltBass_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Blackmelt bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "BlackmeltBass_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a Blackmelt bass swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "BlackmeltBass_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 35,
		SpawnTime = 10,
		Resource = ItsyScape.Resource.Prop "BlackmeltBass_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "BlackmeltBass_Default"
	}

	local CookIngredientAction = ItsyScape.Action.CookIngredient() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Input {
			Resource = ItsyScape.Resource.Item "BlackmeltBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(32)
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = CookIngredientAction
	}

	ItsyScape.Resource.Item "BlackmeltBass" {
		CookIngredientAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Blackmelt bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An ugly fish that needs to be cooked well or you might just die.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(32),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.Ingredient {
		Item = ItsyScape.Resource.Item "BlackmeltBass",
		Ingredient = ItsyScape.Resource.Ingredient "Fish"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "BlackmeltBass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ItemHealingUserdata {
		Hitpoints = 16,
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "BlackmeltBass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Fishing",
		Boost = 3,
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Boost = 2,
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "BlackmeltBass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 2,
		Resource = ItsyScape.Resource.Item "BlackmeltBass"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = ItsyScape.Resource.Item "BlackmeltBass",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = ItsyScape.Resource.Item "BlackmeltBass",
		Value = ItsyScape.Utility.valueForItem(32)
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 16,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Input {
			Resource = ItsyScape.Resource.Item "BlackmeltBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedBlackmeltBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(32)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Input {
			Resource = ItsyScape.Resource.Item "BlackmeltBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntBlackmeltBass",
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
		Start = 30,
		Stop = 35,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedBlackmeltBass" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedBlackmeltBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodFire",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedBlackmeltBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethodRange",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedBlackmeltBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked Blackmelt bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedBlackmeltBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Looks raw, but if you cook it too long, the poison strengthens.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedBlackmeltBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(32),
		Resource = ItsyScape.Resource.Item "CookedBlackmeltBass"
	}

	ItsyScape.Resource.Item "BurntBlackmeltBass" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt Blackmelt bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntBlackmeltBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Eat that and die!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntBlackmeltBass"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntBlackmeltBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntBlackmeltBass"
	}
end

local SECONDARIES = {
	"OldBoot",
	"WaterSlug",
	"WaterWorm",
	"FishEggs",
	"BronzeDubloon",
	"SilverDubloon",
	"GoldDubloon",
	"Key_BlackmeltLagoon1",
	"SageSeaSalt",
	"DexterousSeaSalt",
	"KosherSeaSalt",
	"WarriorSeaSalt",
	"ToughSeaSalt",
	"ArtisanSeaSalt",
	"GathererSeaSalt",
	"AdventurerSeaSalt"
}

local FISH = {
	"Sardine",
	"SeaBass",
	"Coelacanth",
	"Bass",
	"AlligatorGar",
	"Shrimp",
	"Crawfish",
	"BlackmeltBass",
	"LightningStormfish"
}

for _, fish in ipairs(FISH) do
	local prop = string.format("%s_Default", fish)

	for _, secondary in ipairs(SECONDARIES) do
		local Action = ItsyScape.Action.ObtainSecondary() {
			Output {
				Resource = ItsyScape.Resource.Item(secondary),
				Count = 1
			}
		}

		ItsyScape.Meta.HiddenFromSkillGuide {
			Action = Action
		}

		ItsyScape.Resource.Prop(prop) {
			Action
		}
	end
end
