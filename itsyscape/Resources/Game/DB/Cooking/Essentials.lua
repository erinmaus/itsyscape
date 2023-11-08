--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Essentials.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Item = ItsyScape.Resource.Item "AllPurposeFlour" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "AllPurposeFlour",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "All-purpose flour",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Useful for baking and cooking all kinds of things.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Flour"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "AlmondFlour" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "AlmondFlour",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Almond flour",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Useful for baking and cooking all kinds of things.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Flour"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(6),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(6)
	}
end

do
	local Item = ItsyScape.Resource.Item "WholeWheatFlour" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WholeWheatFlour",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Whole wheat flour",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Useful for baking and cooking all kinds of things.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Flour"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}
end

do
	local Item = ItsyScape.Resource.Item "WhiteSugar" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WhiteSugar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "White sugar",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Super sweet!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Sugar"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "DarkBrownSugar" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "DarkBrownSugar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dark brown sugar",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Super sweet!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Sugar"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(6),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(6)
	}
end

do
	local Item = ItsyScape.Resource.Item "LightBrownSugar" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "LightBrownSugar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Light brown sugar",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Super sweet!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Sugar"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "Honey" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Honey",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Honey",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "If chocoroaches are anything to go by, bees are probably very big...",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Sugar"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}
end

do
	local Item = ItsyScape.Resource.Item "TableSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "TableSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Table salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "Butter" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Butter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Butter",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for baking!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Butter"
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "Milk" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Milk",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Milk",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Yum, fresh whole milk!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Milk"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "Egg" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Egg",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Egg",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An egg from a chicken. Quack!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Egg"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(2),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(2)
	}
end

do
	local Item = ItsyScape.Resource.Item "ExtraCreamyButter" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "ExtraCreamyButter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Extra creamy butter",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for baking!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Butter"
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(6),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(6)
	}
end

do
	local Item = ItsyScape.Resource.Item "BrownedButter" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "BrownedButter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		},

		ItsyScape.Action.Cook() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Butter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BrownedButter",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Browned butter",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for baking!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Butter"
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}
end

do
	local Item = ItsyScape.Resource.Item "VegetableOil" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "VegetableOil",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vegetable oil",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for cooking or baking!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Oil"
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(6),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(6)
	}
end

do
	local Item = ItsyScape.Resource.Item "PeanutOil" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "PeanutOil",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(6)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Peanut oil",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for cooking or baking!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Oil"
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(6),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(6)
	}
end

do
	local Item = ItsyScape.Resource.Item "BlackGold" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(45)
			},

			Input {
				Resource = ItsyScape.Resource.Item "BlackGold",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(46)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Black gold",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Explosive ingredient!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Oil"
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "OilOrFat"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(47),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(47)
	}
end

do
	local Item = ItsyScape.Resource.Item "Chocolate" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Chocolate",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chocolate",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Excretion of a chocoroach! Super ew!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Chocolate"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}
end

do
	local Item = ItsyScape.Resource.Item "DarkChocolate" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(14)
			},

			Input {
				Resource = ItsyScape.Resource.Item "DarkChocolate",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(15)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dark chocolate",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Dark excretion of a chocoroach! Super ew!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Chocolate"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(16),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(16)
	}
end

do
	local Item = ItsyScape.Resource.Item "WhiteChocolate" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(14)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WhiteChocolate",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(15)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "White chocolate",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Despite the name, this isn't actually chocolate. But it's still from a chocoroach!",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Chocolate"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(16),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(16)
	}
end
