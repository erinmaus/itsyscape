--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Recipes.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Recipe "CarrotCake" {
	ItsyScape.Action.CookRecipe() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Milk",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Butter",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Flour",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Egg",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Oil",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Sugar",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Carrot",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Ingredient "Pecan",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CarrotCake",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(12)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Carrot cake",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CarrotCake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A carrot cake topped with a creamy butter frosting - yum!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CarrotCake"
}

ItsyScape.Resource.Item "CarrotCake" {
	ItsyScape.Action.Eat()
}
